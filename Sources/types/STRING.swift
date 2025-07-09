public class STRING: Type{
    let min: Int?
    let max: Int?
    let regex: String?

    public init(min: Int? = nil, max: Int? = nil, regex: String? = nil) {
        self.min = min
        self.max = max
        self.regex = regex
    }

    public func cast(value: String) throws -> Any {
        if let min = min, value.count < min {
            throw InvalidValue(value, "should be at least \(min) characters long")
        }
        if let max = max, value.count > max {
            throw InvalidValue(value, "should be at most \(max) characters long")
        }
        if let regex = regex , value.wholeMatch(of: try Regex(regex)) == nil {
            throw InvalidValue(value, "should match /\(regex)/")
        }
        return value
    }
}
