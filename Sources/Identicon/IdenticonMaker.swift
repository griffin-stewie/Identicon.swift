import Foundation
import CryptoKit
import Algorithms
import AppKit

/// Make a Identicon
public struct IdenticonMaker {

    /// Generate using Transformer
    /// - Parameters:
    ///   - input: input string
    ///   - transformer: Object compliant with the `Transformer` protocol.
    /// - Returns: Transformer's result
    public static func generate<T: Transformer>(input: String, transformer: T) -> T.TransformedResult {
        let blocks = binaryBlocks(input: input)
        return transformer.transform(blocks: blocks)
    }

    /// Grid of booleans
    /// - Parameter input: input string
    /// - Returns: 5x5 grid of Booleans
    public static func binaryBlocks(input: String) -> [[Bool]] {
        let chunk = input.identiconStringForPattern()
            .compactMap { c in
                Int16(String(c), radix: 16)
            }
            .chunks(ofCount: 5)

        let chunksOfBlock = chunk.map { $0.map { $0.isEven } }
        let blocks: [[Bool]] = chunksOfBlock
            .transposed()
            .map { array in
                array.reversed() + array.dropFirst()
            }

        return blocks
    }

    /// Hash-determined color
    /// - Parameter input: input string
    /// - Returns: Generated color from last 7 chracters from md5 input string.
    public static func color(from input: String) -> NSColor {
        let colorHex = input.identiconStringForColor()

        let hue = Int(colorHex.prefix(3), radix: 16)!
        let hueInHSL = Double(hue) / 4095 * 360

        let s = colorHex.index(colorHex.startIndex, offsetBy: 3)
        let e = colorHex.index(colorHex.endIndex, offsetBy: -2)
        let saturation = Int(colorHex[s..<e], radix: 16)!
        let saturationInHSL = 65 - Double(saturation) / 255 * 20

        let brightness = Int(colorHex.suffix(2), radix: 16)!
        let brightnessInHSL = 75 -  Double(brightness) / 255 * 20

        let hsl: NSColor.HSL = .init(hue: hueInHSL, saturation: saturationInHSL, lightness: brightnessInHSL)

        return .init(hsl)
    }
}

extension String {
    func md5() -> String {
        let hashed = Insecure.MD5.hash(data: self.data(using: .utf8)!)
        return hashed.compactMap { String(format: "%02hhx", $0) }.joined()
    }

    func identiconStringForPattern() -> String {
        return String(self.md5().prefix(15))
    }

    func identiconStringForColor() -> String {
        return String(self.md5().suffix(7))
    }
}

extension BinaryInteger {
    var isEven: Bool { isMultiple(of: 2) }
    var isOdd:  Bool { !isEven }
}

extension Collection where Self.Iterator.Element: RandomAccessCollection {
    func transposed() -> [[Self.Iterator.Element.Iterator.Element]] {
        guard let firstRow = self.first else { return [] }
        return firstRow.indices.map { index in
            self.map{ $0[index] }
        }
    }
}

/// https://gist.github.com/adamgraham/3ada1f7f4cdf8131dd3d2d95bd116cfc
/// An extension to provide conversion to and from HSL (hue, saturation, lightness) colors.
extension NSColor {

    /// The HSL (hue, saturation, lightness) components of a color.
    struct HSL: Hashable {

        /// The hue component of the color, in the range [0, 360°].
        var hue: CGFloat
        /// The saturation component of the color, in the range [0, 100%].
        var saturation: CGFloat
        /// The lightness component of the color, in the range [0, 100%].
        var lightness: CGFloat

    }

    /// The HSL (hue, saturation, lightness) components of the color.
    var hsl: HSL {
        var (h, s, b) = (CGFloat(), CGFloat(), CGFloat())
        getHue(&h, saturation: &s, brightness: &b, alpha: nil)

        let l = ((2.0 - s) * b) / 2.0

        switch l {
        case 0.0, 1.0:
            s = 0.0
        case 0.0..<0.5:
            s = (s * b) / (l * 2.0)
        default:
            s = (s * b) / (2.0 - l * 2.0)
        }

        return HSL(hue: h * 360.0,
                   saturation: s * 100.0,
                   lightness: l * 100.0)
    }

    /// Initializes a color from HSL (hue, saturation, lightness) components.
    /// - parameter hsl: The components used to initialize the color.
    /// - parameter alpha: The alpha value of the color.
    convenience init(_ hsl: HSL, alpha: CGFloat = 1.0) {
        let h = hsl.hue / 360.0
        var s = hsl.saturation / 100.0
        let l = hsl.lightness / 100.0

        let t = s * ((l < 0.5) ? l : (1.0 - l))
        let b = l + t
        s = (l > 0.0) ? (2.0 * t / b) : 0.0

        self.init(hue: h, saturation: s, brightness: b, alpha: alpha)
    }
}
