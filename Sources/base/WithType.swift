protocol WithType: WithValue{
    var type: Type { get }
}

extension WithType{
    func cast(value: String) throws -> Any {
        do {
            return try type.cast(value: value)
        } catch let error as InvalidValue {
            throw CommandError.InvalidCast(argument: name!, type: String(describing: type), message: error.message)
        }
    }
}