import Prelude

public protocol TemplateType: Monoid {
    var isEmpty: Bool { get }
    func render() -> String
}
