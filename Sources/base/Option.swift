protocol IsOption: WithType {
    var name: String? { get set }
    var short: String? { get }
    var help: String? { get }
    var multiple: Bool { get }
}

@propertyWrapper
struct Option<T>: IsOption {
    var value: Any? = nil

    var wrappedValue: T? {
        get { return value as? T ?? defult }
        set { value = newValue }
    }

    var type: Type

    var name: String?

    var short: String?

    var multiple: Bool = false

    var defult: T?
    
    var help: String?

}