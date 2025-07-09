public class DOUBLE: Type{
    let min: Double?
    let max: Double?

    public init(min: Double? = nil, max: Double? = nil) {
        self.min = min
        self.max = max
    }

    public func cast(value: String) throws -> Any {
        if let val = Double(value) {
           if let min = min, val < min {
                throw InvalidValue(value, "should be at least \(min)")
            }
            if let max = max, val > max {
                throw InvalidValue(value, "should be at most \(max)")
            }
            return val  
        }else{
            throw InvalidValue(value, "should be a double")
        }
    }
}