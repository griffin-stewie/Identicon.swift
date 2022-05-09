/// Protocol that transforms 5x5 grid of Booleans to something
public protocol Transformer {
    /// Result type of `transform(blocks:)`
    associatedtype TransformedResult

    /// Transform 5x5 grid of Booleans to something
    func transform(blocks: [[Bool]]) -> TransformedResult
}
