import Prelude

public protocol FormatType: ExpressibleByArrayLiteral {
    associatedtype T: TemplateType
    associatedtype A

    var parser: Parser<T, A> { get }
    init(_ parser: Parser<T, A>)

    func match(_ a: T) throws -> A?
    func print(_ a: A) throws -> T?
    func template(for a: A) throws -> T?
}

extension FormatType {
    /// A Format that always fails and doesn't print anything.
    public static var empty: Self {
        return .init(.empty)
    }

    /// Processes with the left side Format, and if that fails uses the right side Format.
    public static func <|> (lhs: Self, rhs: Self) -> Self {
        return .init(lhs.parser <|> rhs.parser)
    }

    public func map<F: FormatType, B>(_ f: PartialIso<A, B>) -> F
        where F.A == B, F.T == T {
            return .init(parser.map(f))
    }

    public static func <¢> <F: FormatType, B> (lhs: PartialIso<A, B>, rhs: Self) -> F
        where F.A == B, F.T == T {
            return .init(lhs <¢> rhs.parser)
    }
}

extension FormatType {
    public init(arrayLiteral elements: Self...) {
        self = elements.reduce(.empty, <|>)
    }
}

extension FormatType {
    init(
        parse: @escaping (T) throws -> (rest: T, match: A)?,
        print: @escaping (A) throws -> T?,
        template: @escaping (A) throws -> T?,
        templateValue: @escaping () throws -> A?
    ) {
        self.init(Parser<T, A>(parse: parse, print: print, template: template, templateValue: templateValue))
    }

    public func match(_ t: T) throws -> A? {
        return try parser.parse(t)?.match
    }

    public func print(_ a: A) throws -> T? {
        return try self.parser.print(a)
    }

    public func template() throws -> T? {
        try self.parser.templateValue().flatMap(self.parser.template)
    }
}
