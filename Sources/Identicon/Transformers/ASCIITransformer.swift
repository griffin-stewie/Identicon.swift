import Foundation

/// Transform to ASCII art of Identicon.
public struct ASCIITransformer: Transformer {
    public typealias TransformedResult = String

    public init() { }

    /// Generate ASCII art of Identicon
    /// - Parameter blocks: 5x5 grid of Booleans
    /// - Returns: ASCII art version of Identicon
    public func transform(blocks: [[Bool]]) -> String {
        let a = blocks.map { $0.map { $0 ? "1" : "0" } }
            .map { $0.joined() }
        return a.joined(separator: "\n")
    }
}
