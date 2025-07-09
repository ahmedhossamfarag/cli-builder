protocol IsArgument: WithType {
    var name: String? { get set }
    var help: String? { get }
}

@propertyWrapper
struct Argument<T>: IsArgument {
    var value: Any? = nil

    var wrappedValue: T {
        get { return value as! T }
        set { value = newValue }
    }

    let type: Type
    
    var name: String?

    var help: String?
}