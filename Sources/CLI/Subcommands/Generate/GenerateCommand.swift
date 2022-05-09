import Foundation
import AppKit
import ArgumentParser
import Identicon
import Path

struct GenerateCommand: AsyncParsableCommand {

    static var configuration = CommandConfiguration(
        commandName: "generate",
        abstract: "Generate Identicon image"
    )

    @OptionGroup()
    var options: GenerateCommandOptions

    func run() async throws {
        try await run(options: options)
    }
}

extension GenerateCommand {
    private func run(options: GenerateCommandOptions) async throws {
        let output = IdenticonMaker.generateImage(size: options.size, input: options.input)
        try output.writePNG(to: options.output.url)
    }
}
