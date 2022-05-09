import AppKit

extension NSImage {
    fileprivate var cgImage: CGImage? {
        var rect = CGRect.init(origin: .zero, size: self.size)
        return self.cgImage(forProposedRect: &rect, context: nil, hints: nil)
    }
}

extension NSImage {
    public func writePNG(to url: URL) throws {
        guard let data = tiffRepresentation,
              let rep = NSBitmapImageRep(data: data),
              let imgData = rep.representation(using: .png, properties: [.compressionFactor : NSNumber(floatLiteral: 1.0)]) else {
            throw "Error Function '\(#function)' Line: \(#line) No tiff rep found for image writing to \(url)"
        }

        try imgData.write(to: url)
    }
}
