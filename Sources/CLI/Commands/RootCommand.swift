import Foundation
import ArgumentParser

@main
struct RootCommand: AsyncParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "identicon",
        abstract: "Identicon tool",
        version: "0.1.0",
        subcommands: [GenerateCommand.self]
    )
}
