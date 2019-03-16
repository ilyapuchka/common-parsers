//  Based on:
//  https://github.com/pointfreeco/swift-web/blob/master/Sources/ApplicativeFormatter/SyntaxFormatter.swift
//

import Prelude

public struct Parser<T: Monoid, A> {
    public let parse: (T) throws -> (rest: T, match: A)?
    public let print: (A) throws -> T?
    public let template: (A) throws -> T?

    public init(
        parse: @escaping (T) throws -> (rest: T, match: A)?,
        print: @escaping (A) throws -> T?,
        template: @escaping (A) throws -> T?
    ) {
        self.parse = parse
        self.print = print
        self.template = template
    }
}

extension Parser {
    /// Processes with the left and right side parsers, and if they succeed returns the pair of their results.
    public static func <%> <B> (lhs: Parser, rhs: Parser<T, B>) -> Parser<T, (A, B)> {
        return Parser<T, (A, B)>(
            parse: { str in
                guard let (more, a) = try lhs.parse(str) else { return nil }
                guard let (rest, b) = try rhs.parse(more) else { return nil }
                return (rest, (a, b))
        },
            print: { ab in
                let lhs = try lhs.print(ab.0)
                let rhs = try rhs.print(ab.1)
                return (curry(<>) <¢> lhs <*> rhs)
        },
            template: { ab in
                let lhs = try lhs.template(ab.0)
                let rhs = try rhs.template(ab.1)
                return (curry(<>) <¢> lhs <*> rhs)
        })
    }

    /// Processes with the left and right side parsers, discarding the result of the left side.
    public static func %> (x: Parser<T, Prelude.Unit>, y: Parser) -> Parser {
        return (PartialIso.flip >>> PartialIso.unit.inverted) <¢> x <%> y
    }
}

extension Parser where A == Prelude.Unit {
    /// Processes with the left and right parsers, discarding the result of the right side.
    public static func <% <B>(x: Parser<T, B>, y: Parser) -> Parser<T, B> {
        return PartialIso.unit.inverted <¢> x <%> y
    }
}

extension Parser {
    public func map<B>(_ f: PartialIso<A, B>) -> Parser<T, B> {
        return f <¢> self
    }

    public static func <¢> <B> (lhs: PartialIso<A, B>, rhs: Parser) -> Parser<T, B> {
        return Parser<T, B>(
            parse: { route in
                guard let (rest, match) = try rhs.parse(route) else { return nil }
                return try lhs.apply(match).map { (rest, $0) }
        },
            print: lhs.unapply >=> rhs.print,
            template: lhs.unapply >=> rhs.template
        )
    }
}

func <|> <A, B>(_ f: @escaping (A) throws -> B?, _ g: @escaping (A) throws -> B?) -> (A) throws -> B? {
    return { a in
        let b: B?
        do {
            b = try f(a)
        } catch {
            return try g(a)
        }
        return try b ?? g(a)
    }
}

extension Parser {

    public static func <|> (lhs: Parser, rhs: Parser) -> Parser {
        return .init(
            parse: lhs.parse <|> rhs.parse,
            print: lhs.print <|> rhs.print,
            template: lhs.template <|> rhs.template
        )
    }

    /// A Parser that always fails and doesn't print anything.
    public static var empty: Parser {
        return Parser(
            parse: const(nil),
            print: const(nil),
            template: const(nil)
        )
    }
}

public func reduce<T: Monoid>(parsers: [(Parser<T, Any>, Any.Type)]) -> Parser<T, Any> {
    guard var (composed, lastType) = parsers.last else { return .empty }

    parsers.dropLast().reversed().forEach { (f, prevType) in
        if lastType == Prelude.Unit.self { // A <% ()
            (composed, lastType) = (f <% composed.map(.any), prevType)
        } else if prevType == Prelude.Unit.self { // () %> A
            composed = f.map(.any) %> composed
        } else { // A <%> B
            (composed, lastType) = (.any <¢> f <%> composed, prevType)
        }
    }
    return composed
}
