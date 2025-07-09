protocol IsFlag: WithValue{
    var name: String? { get set }
    var short: String? { get }
    var help: String? { get }
}

@propertyWrapper
struct Flag: IsFlag {
    var value: Any? = false

    var wrappedValue: Bool {
        get { return value as? Bool ?? false }
        set { value = newValue }
    }

    var name: String?

    var short: String?

    var help: String?
}