//  Based on:
//  https://github.com/pointfreeco/swift-web/blob/master/Sources/ApplicativeRouter/PartialIso.swift
//

import Prelude

// MARK: A, B

public func parenthesize<A, B, U>(_ f: PartialIso<(A, B), U>) -> PartialIso<(A, B), U> {
    return f
}

public func parenthesize<A, B, U>(_ a: A, _ b: B, _ u: U) -> (A, (B, U)) {
    return (a, (b, u))
}

public func flatten<A, B, U>() -> PartialIso<(A, (B, U)), (A, B, U)> {
    return .init(
        apply: { flatten($0) },
        unapply: { parenthesize($0, $1, $2) }
    )
}

public func flatten<A, B, U>(_ f: (A, (B, U))) -> (A, B, U) {
    return (f.0, f.1.0, f.1.1)
}

// MARK: A, B, C

public func parenthesize<A, B, C, U>(_ f: PartialIso<(A, B, C), U>) -> PartialIso<(A, (B, C)), U> {
    return flatten() >>> f
}

public func parenthesize<A, B, C, U>(_ a: A, _ b: B, _ c: C, _ u: U) -> (A, (B, (C, U))) {
    return (a, (b, (c, u)))
}

public func flatten<A, B, C, U>() -> PartialIso<(A, (B, (C, U))), (A, B, C, U)> {
    return .init(
        apply: { flatten($0) },
        unapply: { parenthesize($0, $1, $2, $3) }
    )
}

public func flatten<A, B, C, U>(_ f: (A, (B, (C, U)))) -> (A, B, C, U) {
    return (f.0, f.1.0, f.1.1.0, f.1.1.1)
}

// MARK: A, B, C, D

public func parenthesize<A, B, C, D, U>(_ f: PartialIso<(A, B, C ,D), U>) -> PartialIso<(A, (B, (C, D))), U> {
    return flatten() >>> f
}

public func parenthesize<A, B, C, D, U>(_ a: A, _ b: B, _ c: C, _ d: D, _ u: U) -> (A, (B, (C, (D, U)))) {
    return (a, (b, (c, (d, u))))
}

public func flatten<A, B, C, D, U>() -> PartialIso<(A, (B, (C, (D, U)))), (A, B, C, D, U)> {
    return .init(
        apply: { flatten($0) },
        unapply: { parenthesize($0, $1, $2, $3, $4) }
    )
}

public func flatten<A, B, C, D, U>(_ f: (A, (B, (C, (D, U))))) -> (A, B, C, D, U) {
    return (f.0, f.1.0, f.1.1.0, f.1.1.1.0, f.1.1.1.1)
}

// MARK: A, B, C, D, E

public func parenthesize<A, B, C, D, E, U>(_ f: PartialIso<(A, B, C ,D, E), U>) -> PartialIso<(A, (B, (C, (D, E)))), U> {
    return flatten() >>> f
}

public func parenthesize<A, B, C, D, E, U>(_ a: A, _ b: B, _ c: C, _ d: D, _ e: E, _ u: U) -> (A, (B, (C, (D, (E, U))))) {
    return (a, (b, (c, (d, (e, u)))))
}

public func flatten<A, B, C, D, E, U>() -> PartialIso<(A, (B, (C, (D, (E, U))))), (A, B, C, D, E, U)> {
    return .init(
        apply: { flatten($0) },
        unapply: { parenthesize($0, $1, $2, $3, $4, $5) }
    )
}

public func flatten<A, B, C, D, E, U>(_ f: (A, (B, (C, (D, (E, U)))))) -> (A, B, C, D, E, U) {
    return (f.0, f.1.0, f.1.1.0, f.1.1.1.0, f.1.1.1.1.0, f.1.1.1.1.1)
}

// MARK: A, B, C, D, E, F

public func parenthesize<A, B, C, D, E, F, U>(_ f: PartialIso<(A, B, C ,D, E, F), U>) -> PartialIso<(A, (B, (C, (D, (E, F))))), U> {
    return flatten() >>> f
}

public func parenthesize<A, B, C, D, E, F, U>(_ a: A, _ b: B, _ c: C, _ d: D, _ e: E, _ f: F, _ u: U) -> (A, (B, (C, (D, (E, (F, U)))))) {
    return (a, (b, (c, (d, (e, (f, u))))))
}

public func flatten<A, B, C, D, E, F, U>() -> PartialIso<(A, (B, (C, (D, (E, (F, U)))))), (A, B, C, D, E, F, U)> {
    return .init(
        apply: { flatten($0) },
        unapply: { parenthesize($0, $1, $2, $3, $4, $5, $6) }
    )
}

public func flatten<A, B, C, D, E, F, U>(_ f: (A, (B, (C, (D, (E, (F, U))))))) -> (A, B, C, D, E, F, U) {
    return (f.0, f.1.0, f.1.1.0, f.1.1.1.0, f.1.1.1.1.0, f.1.1.1.1.1.0, f.1.1.1.1.1.1)
}

// MARK: A, B, C, D, E, F, G

public func parenthesize<A, B, C, D, E, F, G, U>(_ f: PartialIso<(A, B, C ,D, E, F, G), U>) -> PartialIso<(A, (B, (C, (D, (E, (F, G)))))), U> {
    return flatten() >>> f
}

public func parenthesize<A, B, C, D, E, F, G, U>(_ a: A, _ b: B, _ c: C, _ d: D, _ e: E, _ f: F, _ g: G, _ u: U) -> (A, (B, (C, (D, (E, (F, (G, U))))))) {
    return (a, (b, (c, (d, (e, (f, (g, u)))))))
}

public func flatten<A, B, C, D, E, F, G, U>() -> PartialIso<(A, (B, (C, (D, (E, (F, (G, U))))))), (A, B, C, D, E, F, G, U)> {
    return .init(
        apply: { flatten($0) },
        unapply: { parenthesize($0, $1, $2, $3, $4, $5, $6, $7) }
    )
}

public func flatten<A, B, C, D, E, F, G, U>(_ f: (A, (B, (C, (D, (E, (F, (G, U)))))))) -> (A, B, C, D, E, F, G, U) {
    return (f.0, f.1.0, f.1.1.0, f.1.1.1.0, f.1.1.1.1.0, f.1.1.1.1.1.0, f.1.1.1.1.1.1.0, f.1.1.1.1.1.1.1)
}

// MARK: A, B, C, D, E, F, G, H

public func parenthesize<A, B, C, D, E, F, G, H, U>(_ f: PartialIso<(A, B, C ,D, E, F, G, H), U>) -> PartialIso<(A, (B, (C, (D, (E, (F, (G, H))))))), U> {
    return flatten() >>> f
}

public func parenthesize<A, B, C, D, E, F, G, H, U>(_ a: A, _ b: B, _ c: C, _ d: D, _ e: E, _ f: F, _ g: G, _ h: H, _ u: U) -> (A, (B, (C, (D, (E, (F, (G, (H, U)))))))) {
    return (a, (b, (c, (d, (e, (f, (g, (h, u))))))))
}

public func flatten<A, B, C, D, E, F, G, H, U>() -> PartialIso<(A, (B, (C, (D, (E, (F, (G, (H, U)))))))), (A, B, C, D, E, F, G, H, U)> {
    return .init(
        apply: { flatten($0) },
        unapply: { parenthesize($0, $1, $2, $3, $4, $5, $6, $7, $8) }
    )
}

public func flatten<A, B, C, D, E, F, G, H, U>(_ f: (A, (B, (C, (D, (E, (F, (G, (H, U))))))))) -> (A, B, C, D, E, F, G, H, U) {
    return (f.0, f.1.0, f.1.1.0, f.1.1.1.0, f.1.1.1.1.0, f.1.1.1.1.1.0, f.1.1.1.1.1.1.0, f.1.1.1.1.1.1.1.0, f.1.1.1.1.1.1.1.1)
}

// MARK: A, B, C, D, E, F, G, H, I

public func parenthesize<A, B, C, D, E, F, G, H, I, U>(_ f: PartialIso<(A, B, C ,D, E, F, G, H, I), U>) -> PartialIso<(A, (B, (C, (D, (E, (F, (G, (H, I)))))))), U> {
    return flatten() >>> f
}

public func parenthesize<A, B, C, D, E, F, G, H, I, U>(_ a: A, _ b: B, _ c: C, _ d: D, _ e: E, _ f: F, _ g: G, _ h: H, _ i: I, _ u: U) -> (A, (B, (C, (D, (E, (F, (G, (H, (I, U))))))))) {
    return (a, (b, (c, (d, (e, (f, (g, (h, (i, u)))))))))
}

public func flatten<A, B, C, D, E, F, G, H, I, U>() -> PartialIso<(A, (B, (C, (D, (E, (F, (G, (H, (I, U))))))))), (A, B, C, D, E, F, G, H, I, U)> {
    return .init(
        apply: { flatten($0) },
        unapply: { parenthesize($0, $1, $2, $3, $4, $5, $6, $7, $8, $9) }
    )
}

public func flatten<A, B, C, D, E, F, G, H, I, U>(_ f: (A, (B, (C, (D, (E, (F, (G, (H, (I, U)))))))))) -> (A, B, C, D, E, F, G, H, I, U) {
    return (f.0, f.1.0, f.1.1.0, f.1.1.1.0, f.1.1.1.1.0, f.1.1.1.1.1.0, f.1.1.1.1.1.1.0, f.1.1.1.1.1.1.1.0, f.1.1.1.1.1.1.1.1.0, f.1.1.1.1.1.1.1.1.1)
}

// MARK: A, B, C, D, E, F, G, H, I, J

public func parenthesize<A, B, C, D, E, F, G, H, I, J, U>(_ f: PartialIso<(A, B, C ,D, E, F, G, H, I, J), U>) -> PartialIso<(A, (B, (C, (D, (E, (F, (G, (H, (I, J))))))))), U> {
    return flatten() >>> f
}

public func parenthesize<A, B, C, D, E, F, G, H, I, J, U>(_ a: A, _ b: B, _ c: C, _ d: D, _ e: E, _ f: F, _ g: G, _ h: H, _ i: I, _ j: J, _ u: U) -> (A, (B, (C, (D, (E, (F, (G, (H, (I, (J, U)))))))))) {
    return (a, (b, (c, (d, (e, (f, (g, (h, (i, (j, u))))))))))
}

public func flatten<A, B, C, D, E, F, G, H, I, J, U>() -> PartialIso<(A, (B, (C, (D, (E, (F, (G, (H, (I, (J, U)))))))))), (A, B, C, D, E, F, G, H, I, J, U)> {
    return .init(
        apply: { flatten($0) },
        unapply: { parenthesize($0, $1, $2, $3, $4, $5, $6, $7, $8, $9, $10) }
    )
}

public func flatten<A, B, C, D, E, F, G, H, I, J, U>(_ f: (A, (B, (C, (D, (E, (F, (G, (H, (I, (J, U))))))))))) -> (A, B, C, D, E, F, G, H, I, J, U) {
    return (f.0, f.1.0, f.1.1.0, f.1.1.1.0, f.1.1.1.1.0, f.1.1.1.1.1.0, f.1.1.1.1.1.1.0, f.1.1.1.1.1.1.1.0, f.1.1.1.1.1.1.1.1.0, f.1.1.1.1.1.1.1.1.1.0, f.1.1.1.1.1.1.1.1.1.1)
}
