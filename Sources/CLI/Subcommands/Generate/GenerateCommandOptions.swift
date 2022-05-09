import Foundation
import ArgumentParser
import Path

struct GenerateCommandOptions: ParsableArguments {
    @Option()
    var width: Double = 1024

    @Option()
    var height: Double = 1024

    @Option()
    var output: Path

    @Argument()
    var input: String
}

extension GenerateCommandOptions {
    var size: CGSize {
        CGSize(width: width, height: height)
    }
}
