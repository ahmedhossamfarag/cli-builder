public class OneOf: Type{
    let choices: [String]

    public init(choices: [String]) {
        self.choices = choices
    }

    public func cast(value: String) throws -> Any {
        if choices.contains(value) {
            return value
        }else{
            throw InvalidValue(value, "should be one of \(choices)")
        }
    }
}