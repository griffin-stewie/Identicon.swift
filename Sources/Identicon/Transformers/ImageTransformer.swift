import Foundation
import AppKit

/// Transform to NSImage
public struct ImageTransformer: Transformer {
    public typealias TransformedResult = NSImage

    /// Image size
    public let imageSize: CGSize

    /// Forground color. True blocks are drawn this color.
    public let forgroundColor: NSColor

    /// Background color. False blocks are drawn this color.
    public let backgroundColor: NSColor

    /// Initializer
    /// - Parameters:
    ///   - size: Image size you want to generate.
    ///   - forgroundColor: Forground color. True blocks are drawn this color.
    ///   - backgroundColor: Background color. False blocks are drawn this color.
    public init(size: CGSize, forgroundColor: NSColor, backgroundColor: NSColor = .white) {
        imageSize = size
        self.forgroundColor = forgroundColor
        self.backgroundColor = backgroundColor
    }

    /// Transform 5x5 grid of Booleans to NSImage
    /// If the image size cannot be divided into 5x5, the remainder is drawn as a padding.
    /// - Parameter blocks: 5x5 grid of Booleans
    /// - Returns: NSImage.
    public func transform(blocks: [[Bool]]) -> NSImage {
        NSImage(size: imageSize, flipped: true) { imageRect in
            NSGraphicsContext.saveGraphicsState()
            defer {
                NSGraphicsContext.restoreGraphicsState()
            }

            let context = NSGraphicsContext.current!.cgContext

            let results = rects(source: imageRect, blocks: blocks)
            context.setFillColor(self.forgroundColor.cgColor)
            context.fill(results.onRects)
            context.setFillColor(self.backgroundColor.cgColor)
            context.fill(results.offRects)

            return true
        }
    }
}

extension ImageTransformer {
    private func rects(source: NSRect, blocks: [[Bool]]) -> (onRects: [NSRect], offRects: [NSRect]) {
        let row = blocks.count
        let column = blocks[0].count

        let gridInfo = gridInfo(length: Int(source.width), count: row)
        let rectsGrid = offset(
            reminder: CGFloat(gridInfo.reminder),
            rects: rects(source: source, blockSize: gridInfo.size, row: row, column: column)
        )

        var onRects: [NSRect] = []
        var offRects: [NSRect] = []

        for pair in zip(blocks.flatMap({ $0 }), rectsGrid.flatMap({ $0 })) {
            if pair.0 {
                onRects.append(pair.1)
            } else {
                offRects.append(pair.1)
            }
        }

        return (onRects: onRects, offRects: offRects)
    }

    private func rects(source: NSRect, blockSize: NSSize, row: Int, column: Int) -> [[NSRect]] {
        var rects: [[NSRect]] = []

        for i in 0..<row {
            let y = CGFloat(i) * blockSize.height
            var row: [NSRect] = []
            for j in 0..<column {
                let x = CGFloat(j) * CGFloat(blockSize.width)
                row.append(.init(origin: NSPoint(x: x, y: y), size: blockSize))
            }

            rects.append(row)
        }

        return rects
    }

    private func gridInfo(length: Int, count: Int) -> (size: NSSize, reminder: Int) {
        let reminder = length % count
        let size = (length - reminder) / count

        return (size: NSSize(width: size, height: size), reminder: reminder)
    }

    private func offset(reminder: CGFloat, rects: [[NSRect]]) -> [[NSRect]] {
        let offsetValue = reminder / 2
        return rects.map { $0.map { $0.offsetBy(dx: offsetValue, dy: offsetValue) } }
    }
}

extension IdenticonMaker {

    /// Generate NSImage
    /// Shorthands to generate an Identicon image.
    /// - Parameters:
    ///   - size: Image size you want to generate.
    ///   - input: input string
    /// - Returns: Identicon image
    public static func generateImage(size: CGSize, input: String) -> ImageTransformer.TransformedResult {
        let color = IdenticonMaker.color(from: input)
        let transformer = ImageTransformer(size: size, forgroundColor: color)
        let blocks = binaryBlocks(input: input)
        return transformer.transform(blocks: blocks)
    }
}
