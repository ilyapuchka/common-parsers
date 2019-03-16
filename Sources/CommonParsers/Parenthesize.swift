//  Based on:
//  https://github.com/pointfreeco/swift-web/blob/master/Sources/ApplicativeRouter/PartialIso.swift
//

import Prelude

// MARK: A, B, C

/// Converts a partial isomorphism of a flat 2-tuple to one of a right-weighted nested tuple.
public func parenthesize<A, B, C>(_ f: PartialIso<(A, B), C>) -> PartialIso<(A, B), C> {
    return f
}

public func parenthesize<A, B, C>(_ a: A, _ b: B, _ c: C) -> (A, (B, C)) {
    return (a, (b, c))
}

/// Flattens a right-weighted nested 3-tuple.
public func flatten<A, B, C>() -> PartialIso<(A, (B, C)), (A, B, C)> {
    return .init(
        apply: { flatten($0) },
        unapply: { parenthesize($0, $1, $2) }
    )
}

public func flatten<A, B, C>(_ f: (A, (B, C))) -> (A, B, C) {
    return (f.0, f.1.0, f.1.1)
}

// MARK: A, B, C, D

/// Converts a partial isomorphism of a flat 3-tuple to one of a right-weighted nested tuple.
public func parenthesize<A, B, C, D>(_ f: PartialIso<(A, B, C), D>) -> PartialIso<(A, (B, C)), D> {
    return flatten() >>> f
}

public func parenthesize<A, B, C, D>(_ a: A, _ b: B, _ c: C, _ d: D) -> (A, (B, (C, D))) {
    return (a, (b, (c, d)))
}

/// Flattens a left-weighted nested 4-tuple.
public func flatten<A, B, C, D>() -> PartialIso<(A, (B, (C, D))), (A, B, C, D)> {
    return .init(
        apply: { flatten($0) },
        unapply: { parenthesize($0, $1, $2, $3) }
    )
}

public func flatten<A, B, C, D>(_ f: (A, (B, (C, D)))) -> (A, B, C, D) {
    return (f.0, f.1.0, f.1.1.0, f.1.1.1)
}

// MARK: A, B, C, D, E

/// Converts a partial isomorphism of a flat 4-tuple to one of a right-weighted nested tuple.
public func parenthesize<A, B, C, D, E>(_ f: PartialIso<(A, B, C ,D), E>) -> PartialIso<(A, (B, (C, D))), E> {
    return flatten() >>> f
}

public func parenthesize<A, B, C, D, E>(_ a: A, _ b: B, _ c: C, _ d: D, _ e: E) -> (A, (B, (C, (D, E)))) {
    return (a, (b, (c, (d, e))))
}

/// Flattens a left-weighted nested 4-tuple.
public func flatten<A, B, C, D, E>() -> PartialIso<(A, (B, (C, (D, E)))), (A, B, C, D, E)> {
    return .init(
        apply: { flatten($0) },
        unapply: { parenthesize($0, $1, $2, $3, $4) }
    )
}

public func flatten<A, B, C, D, E>(_ f: (A, (B, (C, (D, E))))) -> (A, B, C, D, E) {
    return (f.0, f.1.0, f.1.1.0, f.1.1.1.0, f.1.1.1.1)
}

// MARK: A, B, C, D, E, F

/// Converts a partial isomorphism of a flat 4-tuple to one of a right-weighted nested tuple.
public func parenthesize<A, B, C, D, E, F>(_ f: PartialIso<(A, B, C ,D, E), F>) -> PartialIso<(A, (B, (C, (D, E)))), F> {
    return flatten() >>> f
}

public func parenthesize<A, B, C, D, E, F>(_ a: A, _ b: B, _ c: C, _ d: D, _ e: E, _ f: F) -> (A, (B, (C, (D, (E, F))))) {
    return (a, (b, (c, (d, (e, f)))))
}

/// Flattens a left-weighted nested 4-tuple.
public func flatten<A, B, C, D, E, F>() -> PartialIso<(A, (B, (C, (D, (E, F))))), (A, B, C, D, E, F)> {
    return .init(
        apply: { flatten($0) },
        unapply: { parenthesize($0, $1, $2, $3, $4, $5) }
    )
}

public func flatten<A, B, C, D, E, F>(_ f: (A, (B, (C, (D, (E, F)))))) -> (A, B, C, D, E, F) {
    return (f.0, f.1.0, f.1.1.0, f.1.1.1.0, f.1.1.1.1.0, f.1.1.1.1.1)
}
