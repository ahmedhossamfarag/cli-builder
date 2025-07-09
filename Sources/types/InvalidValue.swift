public class InvalidValue: Error {
    let message: String
    let value: String
    public init(_ value: String, _ message: String) {
        self.value = value
        self.message = message
    }
}