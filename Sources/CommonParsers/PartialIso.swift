//  Based on:
//  https://github.com/pointfreeco/swift-web/blob/master/Sources/ApplicativeRouter/PartialIso.swift
//

import Foundation
import Prelude

public func >>> <A, B, C>(_ a2b: @escaping (A) throws -> B, _ b2c: @escaping (B) throws -> C) -> (A) throws -> C {
    return { a in try b2c(a2b(a)) }
}

public func >=> <A, B, C>(lhs: @escaping (A) throws -> B?, rhs: @escaping (B) throws -> C?) -> (A) throws -> C? {
    return lhs >>> flatMap(rhs)
}

func flatMap<A, B>(_ a2b: @escaping (A) throws -> B?) -> (A?) throws -> B? {
    return { a in
        try a.flatMap(a2b)
    }
}

public struct PartialIso<A, B> {
    public let apply: (A) throws -> B?
    public let unapply: (B) throws -> A?

    public init(apply: @escaping (A) throws -> B?, unapply: @escaping (B) throws -> A?) {
        self.apply = apply
        self.unapply = unapply
    }

    /// Inverts the partial isomorphism.
    public var inverted: PartialIso<B, A> {
        return .init(apply: self.unapply, unapply: self.apply)
    }

    /// A partial isomorphism between `(A, B)` and `(B, A)`.
    public static var flip: PartialIso<(A, B), (B, A)> {
        return .init(
            apply: { ($1, $0) },
            unapply: { ($1, $0) }
        )
    }

    /// Composes two partial isomorphisms.
    public static func >>> <C> (lhs: PartialIso<A, B>, rhs: PartialIso<B, C>) -> PartialIso<A, C> {
        return .init(
            apply: lhs.apply >=> rhs.apply,
            unapply: rhs.unapply >=> lhs.unapply
        )
    }

    /// Backwards composes two partial isomorphisms.
    public static func <<< <C> (lhs: PartialIso<B, C>, rhs: PartialIso<A, B>) -> PartialIso<A, C> {
        return .init(
            apply: rhs.apply >=> lhs.apply,
            unapply: lhs.unapply >=> rhs.unapply
        )
    }
}

extension PartialIso where B == A {
    /// The identity partial isomorphism.
    static var id: PartialIso {
        return .init(apply: { $0 }, unapply: { $0 })
    }
}

extension PartialIso where B == (A, Prelude.Unit) {
    /// An isomorphism between `A` and `(A, Unit)`.
    static var unit: PartialIso {
        return .init(
            apply: { ($0, Prelude.unit) },
            unapply: { $0.0 }
        )
    }
}

extension Optional {
    public enum iso {
        /// A partial isomorphism `(A) -> A?`
        static var some: PartialIso<Wrapped, Wrapped?> {
            return .init(
                apply: Optional.some,
                unapply: id
            )
        }
    }
}

public func opt<A, B>(_ f: PartialIso<A, B>) -> PartialIso<A?, B?> {
    return PartialIso<A?, B?>(
        apply: { try $0.flatMap(f.apply) },
        unapply: { try $0.flatMap(f.unapply) }
    )
}

public func req<A, B>(_ f: PartialIso<A, B>) -> PartialIso<A?, B> {
    return Optional.iso.some.inverted >>> f
}

extension PartialIso where A == String, B == Any {
    public static var any: PartialIso {
        return PartialIso(
            apply: { $0 },
            unapply: { ($0 as? A) ?? String(describing: $0) }
        )
    }
}

extension PartialIso {
    public static var any: PartialIso {
        return PartialIso(
            apply: { ($0 as? B) },
            unapply: { ($0 as? A) }
        )
    }
}

extension PartialIso where A == String, B == Int {
    /// An isomorphism between strings and integers.
    public static var int: PartialIso {
        return PartialIso(
            apply: { Int.init($0) },
            unapply: String.init(describing:)
        )
    }
}

extension PartialIso where A == String, B == Bool {
    /// An isomorphism between strings and booleans.
    public static var bool: PartialIso {
        return .init(
            apply: {
                $0 == "true" || $0 == "1" ? true
                    : $0 == "false" || $0 == "0" ? false
                    : nil
        },
            unapply: { $0 ? "true" : "false" }
        )
    }
}

extension PartialIso where A == String, B == String {
    /// The identity isomorphism between strings.
    public static var string: PartialIso {
        return .id
    }
}

extension PartialIso where A == String, B == Character {
    /// The identity isomorphism between strings.
    public static var char: PartialIso {
        return PartialIso(
            apply: Character.init,
            unapply: String.init
        )
    }
}

extension PartialIso where A == String, B == Double {
    /// An isomorphism between strings and doubles.
    public static var double: PartialIso {
        return PartialIso(
            apply: Double.init,
            unapply: String.init(describing:)
        )
    }
}

extension PartialIso where A == String, B: LosslessStringConvertible {
    public static var losslessStringConvertible: PartialIso {
        return PartialIso(
            apply: B.init,
            unapply: String.init
        )
    }
}

extension PartialIso where B: RawRepresentable, B.RawValue == A {
    public static var rawRepresentable: PartialIso {
        return .init(
            apply: B.init(rawValue:),
            unapply: { $0.rawValue }
        )
    }
}

extension PartialIso where A == String, B == UUID {
    public static var uuid: PartialIso<String, UUID> {
        return PartialIso(
            apply: UUID.init(uuidString:),
            unapply: { $0.uuidString }
        )
    }
}

extension PartialIso where A: Codable, B == Data {
    public static func codableToJsonData(
        _ type: A.Type,
        encoder: JSONEncoder = .init(),
        decoder: JSONDecoder = .init()
        )
        -> PartialIso {

            return .init(
                apply: { try? encoder.encode($0) },
                unapply: { try? decoder.decode(type, from: $0) }
            )
    }
}

public let jsonDictionaryToData = PartialIso<[String: String], Data>(
    apply: { try? JSONSerialization.data(withJSONObject: $0) },
    unapply: {
        (try? JSONSerialization.jsonObject(with: $0))
            .flatMap { $0 as? [String: String] }
})

//extension PartialIso where A == String, B: Collection {
//    public static func array() -> PartialIso {
//        return PartialIso(apply: { (string) in
//            return B
//        }, unapply: { (l) -> String? in
//            return String(describing: l)
//        })
//    }
//}
//
//public func array<A>() -> PartialIso<String, [A]> {
//    return PartialIso<String, [A]>(
//        apply: { (string) -> [A]? in
//            return nil
//    },
//        unapply: { (array) -> String? in
//            return nil
//    }
//    )
//}

public func first<A>(where predicate: @escaping (A) -> Bool) -> PartialIso<[A], A> {
    return PartialIso<[A], A>(
        apply: { $0.first(where: predicate) },
        unapply: { [$0] }
    )
}

public func filter<A>(_ isIncluded: @escaping (A) -> Bool) -> PartialIso<[A], [A]> {
    return PartialIso<[A], [A]>(
        apply: { $0.filter(isIncluded) },
        unapply: id
    )
}

public func key<K, V>(_ key: K) -> PartialIso<[K: V], V> {
    return PartialIso<[K: V], V>(
        apply: { $0[key] },
        unapply: { [key: $0] }
    )
}

public func keys<K, V>(_ keys: [K]) -> PartialIso<[K: V], [K: V]> {
    return .init(
        apply: { $0.filter { key, _ in keys.contains(key) } },
        unapply: id
    )
}

extension Collection {
    public func head() -> (Self.Element, Self.SubSequence)? {
        guard let x = self.first else { return nil }
        return (x, self.dropFirst())
    }
}
