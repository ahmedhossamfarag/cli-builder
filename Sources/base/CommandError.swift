enum CommandError: Error{
    case failedTogetArguments(of: String)
    case failedTogetOptions(of: String)
    case failedTogetFlags(of: String)
    case tooFewArguments
    case unsetOption(name: String)
    case unknownOption(name: String)
    case unknownCommand(name: String)
}