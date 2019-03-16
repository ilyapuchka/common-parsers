import Prelude

public protocol Matchable: Equatable {
    func match<A>(_ constructor: (A) -> Self) -> A?
}

public func iso<U: Matchable>(_ f: U) -> PartialIso<Prelude.Unit, U> {
    return PartialIso<Prelude.Unit, U>(
        apply: { _ in f },
        unapply: { $0.match({ _ in f }) }
    )
}

public func iso<A, U: Matchable>(_ f: @escaping (A) -> U) -> PartialIso<A, U> {
    return PartialIso<A, U>(
        apply: f,
        unapply: { $0.match(f) }
    )
}

public func iso<A, B, U: Matchable>(_ f: @escaping ((A, B)) -> U) -> PartialIso<(A, B), U> {
    return PartialIso<(A, B), U>(
        apply: f,
        unapply: { $0.match(f) }
    )
}

public func iso<A, B, C, U: Matchable>(_ f: @escaping ((A, B, C)) -> U) -> PartialIso<(A, (B, C)), U> {
    return parenthesize(PartialIso<(A, B, C), U>(
        apply: f,
        unapply: { $0.match(f) }
    ))
}

public func iso<A, B, C, D, U: Matchable>(_ f: @escaping ((A, B, C, D)) -> U) -> PartialIso<(A, (B, (C, D))), U> {
    return parenthesize(PartialIso<(A, B, C, D), U>(
        apply: f,
        unapply: { $0.match(f) }
    ))
}