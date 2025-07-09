/**
 * CommandGroup is a protocol that represents a group of commands.
 *
 * Each command group should implement the commands property to return an array of Command objects.
 * Command groups also conform to the Command protocol, allowing them to be parsed and executed.
 *
 * Example:
 * ```swift
 * struct MyCommandGroup: CommandGroup {
 *     var commands: [Command] = [RepeatCommand(), AnotherCommand()]
 * }
 *
 * var group = MyCommandGroup()
 * do {
 *     try group.run()
 * } catch {
 *     print("Error: \(error)")
 * }
 * ```
 *
 * To execute a specific command, you can run your application with:
 * ```
 * ./yourApp commandName [options]
 * ```
 * 
 * Use `--help` or `-h` to print a help message, listing available commands and their descriptions.
 */


protocol CommandGroup : Command{
    var commands: [Command] { get }
}

extension CommandGroup{
    var name: String { 
        let typeName = String(describing: type(of: self))
        let regex = try! Regex("([a-z])([A-Z])")

        return typeName.replacing(regex) { (match: Regex.Match) in
            let first = match[1]
            let second = match[2]
            return "\(first.value!)-\(second.value!)"
        }
    }

    mutating func parse(_ patterns: [String]) throws {
        if patterns.count == 0 || (patterns.count == 1 && patterns[0] == "--help" || patterns[0] == "-h") {
            try printHelp()
            return
        }
        let commandName = patterns[0]
        let commandPatterns = [String](patterns[1 ..< patterns.count])
        for var command in commands {
            if command.name == commandName {
                try command.parse(commandPatterns)
                return
            }
        }
        throw CommandError.UnknownCommand(name: commandName)
    }

    mutating func run() throws {
        var patterns = CommandLine.arguments
        patterns.removeFirst()
        try parse(patterns)
    }

    func printHelp() throws {
        print(name)
        if let help = help {
            print(help)
        }

        print("Commands:")
        for command in commands {
            print("  \(command.name) \t \(command.help ?? "")")
        }
    }
}