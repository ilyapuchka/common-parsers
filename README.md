# common-parsers

Common parser-printer inspired by [swift-parser-printer](https://github.com/pointfreeco/swift-parser-printer)

## Usage

### PartialIso

`PartialIso` is a value type that represents a partial isomorphism, that is a pair of failable transformations from `A` to `B` (`apply`) and from `B` to `A` (`unapply`). There are several of built-in `PartialIso`s for common types, for example to transform from `String` to `Int`:

```swift
extension PartialIso where A == String, B == Int {
    public static var int: PartialIso {
        return PartialIso(
            apply: { Int.init($0) },
            unapply: String.init(describing:)
        )
    }
}
```

### Parser

`Parser` is a value type responsible for parsing seqential data (that is not necessary string data) as well as "printing" it, which is an operation of converting parsed data to parser's expected input type and optionally creating a template for the input data.

For example we can define a parser that is responsible for parsing string literal in URL path:

```swift
public func path(_ str: String) -> Parser<URLComponents, Prelude.Unit> {
    return Parser<URLComponents, Prelude.Unit>.init(
        parse: { components in
            let pathComponents = components.path.components(separatedBy: "/")
            return components.pathComponents.head().flatMap { (p, ps) in
                return p == str
                    ? (components.with { $0.path = ps.joined(separator: "/") }, unit)
                    : nil
            }
        },
        print: { _ in URLComponents().with { $0.path = str } },
        template: { _ in URLComponents().with { $0.path = str } }
    )
}
```

`Parser`'s input type should implement `Prelude.Monoid` protocol:

```swift
import Prelude

extension URLComponents: Monoid {
    public static var empty: URLComponents { return URLComponents() }
    public static func <>(lhs: URLComponents, rhs: URLComponents) -> URLComponents {
        // create URLComponents by composing lhs and rhs components
    }
}
```

### FormatType

`FormatType` is a protocol that your type can implement so that it can parse inputs using `Parser`. When conforming to this protocol you will get `match`, `print` and `template` functions for free, but you can override them if needed. It also comes with few operators like `<¢>` (`map`) and `<|>` that you will use to compose simple formats into more complex formats.

For example with `<|>` and `reduce` function you can combine multiple formats into one that will parse either of these formats:

```swift
public struct URLFormat<A>: FormatType { ... }

let formats: URLFormat = 
    scheme("https") </> host("me.com") </> [
        // matches URLs with "/echo" path
        path("echo"),
        // matches URLs with "/hello" path
        path("hello")
    ].reduce(.empty, <|>)
    
formats.match(URLComponents(string: "https://me.com/echo")!) // Prelude.unit
formats.match(URLComponents(string: "https://me.com/hello")!) // Prelude.unit
formats.match(URLComponents(string: "https://me.com/echo/hello")!) // nil
```

> Note: you can create same `FormatType` from array literal of `FormatType` elements.

This works well when all formats have the same type, i.e. `URLFormat<Prelude.Unit>` or `URLFormat<String>`, but it's not possible to combine `URLFormat<Prelude.Unit>` with `URLFormat<String>`. For that you can define a sum type (in Swift it's an `enum`) for such formatter use `<¢>` operator.

```swift
enum Routes {
  case echo
  case hello(String)
}

let formats: URLFormat = 
    scheme("https") </> host("me.com") </> [
        // matches URLs with "/echo" path
        iso(Routes.echo) <¢> path("echo"),
        // matches URLs with "/hello/:string" path
        iso(Routes.hello) <¢> path("hello") </> path(.string)
    ].reduce(.empty, <|>)

formats.match(URLComponents(string: "https://me.com/echo")!) // Routes.echo
formats.match(URLComponents(string: "https://me.com/hello/world")!) // Routes.hello("world")
```

`iso` here is a helper function that can be used on types that implement `Matchable` protocol. Alternatively you can define partial isomorphisms for your sum type like this:

```swift
extension Routes {
    enum iso {
        static let echo = PartialIso(
            apply: { (_: Prelude.Unit) -> Routes? in
                return .echo
            },
            unapply: { (r: Routes) -> Prelude.Unit? in
                return Prelude.unit
        })

        static let hello = PartialIso(
            apply: { (s: String) -> Routes? in
                return .hello(s)
            },
            unapply: { (r: Routes) -> String? in
                guard case let .hello(str) = r else { return nil }
                return str
        })
    }
}

let formats: URLFormat =
    scheme("https") </> host("me.com") </> [
        // matches URLs with "/echo" path
        Routes.iso.echo <¢> path("echo"),
        // matches URLs with "/hello/:string" path
        Routes.iso.hello <¢> path("hello") </> path(.string)
    ].reduce(.empty, <|>)
```

### Matchable

`Matchable` protocol is a helper protocol that simplifies defining partial isomoprhisms for your sum types. Instead of implementing partial isomorphis for each case you can implement as single method where you can use simple pattern matching. Then you can use `iso` functions with enum case constructors to create partial isomorphism for these enum cases.

```swift
extension Routes: Matchable {
    func match<A>(_ constructor: (A) -> Routes) -> A? {
        switch self {
        case let .hello(values):
            guard let a = values as? A, self == constructor(a) else { return nil }
            return a
        case .echo:
            guard let a = unit as? A, self == constructor(a) else { return nil }
            return a
        default: return nil
        }
    }
}

let formats: URLFormat =
    scheme("https") </> host("me.com") </> [
        // matches URLs with "echo/" path
        iso(Routes.echo) <¢> path("echo"),
        // matches URLs with "hello/:string" path
        iso(Routes.hello) <¢> path("hello") </> path(.string)
    ].reduce(.empty, <|>)
```

> Note: you can generate code for either `Matchable` implementation or for separate `iso`s for each case using Sourcery or SwiftSyntax.

### `print` and `template`

`Parser` can not only parse arbitrary inputs into arbitrary output types but can also be used to produce input based on output. For example with `URLFormat` we can print URLs for arbitrary routes:

```swift
try formats.print(.echo)!.render() // "https://me.com/echo"
try formats.print(.hello("world"))!.render() // "https://me.com/hello/world"
```

This can be helpful when you need to provide an input required to get particular output, i.e. in case of URLs you can use it to render URLs leading to particular content.

You can also use `template` function to get a template-like input:

```swift
try formats.template(.echo)!.render() // "https://me.com/echo"
try formats.template(.hello("world"))!.render() // "https://me.com/hello/:string"
```

This can be useful for things like documentation, logs or error messages.

## Installation

```swift
import PackageDescription

let package = Package(
    dependencies: [
        .package(url: "https://github.com/ilyapuchka/common-parsers.git", .branch("master")),
    ]
)
```
