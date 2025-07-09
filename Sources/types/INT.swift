public class INT: Type{
    var min: Int?
    var max: Int?

    public init(min: Int? = nil, max: Int? = nil) {
        self.min = min
        self.max = max
    }

    public func cast(value: String) throws -> Any {
        if let val = Int(value) {
           if let min = min, val < min {
                throw InvalidValue(value, "should be at least \(min)")
            }
            if let max = max, val > max {
                throw InvalidValue(value, "should be at most \(max)")
            }
            return val  
        }else{
            throw InvalidValue(value, "should be an integer")
        }
    }
}