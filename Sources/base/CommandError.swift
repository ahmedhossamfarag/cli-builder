class CommandError: Error{
    let message: String

    init(_ message: String){
        self.message = message
    }

    class FailedTogetArguments: CommandError{
        init(of: String){
            super.init("Failed to get arguments of \(of)")
        }
    }

    class FailedTogetFlags: CommandError{
        init(of: String){
            super.init("Failed to get flags of \(of)")
        }
    }

    class FailedTogetOptions: CommandError{
        init(of: String){
            super.init("Failed to get options of \(of)")
        }
    }

    class TooFewArguments: CommandError{
        init(should: Int, got: Int){
            super.init("Too few arguments, should be \(should) but got \(got)")
        }
    }

    class UnsetOption: CommandError{
        init(name: String){
            super.init("Option \(name) must have a value")
        }
    }

    class UnknownOption: CommandError{
        init(name: String){
            super.init("Unknown option \(name)")
        }
    }

    class UnknownCommand: CommandError{
        init(name: String){
            super.init("Unknown command \(name)")
        }
    }

    class InvalidCast: CommandError{
        init(argument: String, type: String, message: String){
            super.init("Failed to cast \(argument) to \(type), \(message)")
        }
    }
}