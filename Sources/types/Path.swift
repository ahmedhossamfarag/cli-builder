import Foundation

public class Path: Type{
    var exists: Bool = false

    public init(exists: Bool = false) {
        self.exists = exists
    }

    public func cast(value: String) throws -> Any {
        if let path = URL(string: value) {
            if exists && !FileManager.default.fileExists(atPath: path.path) {
                throw InvalidValue(value, "should exist")
            }
            return path
        }else{
            throw InvalidValue(value, "should be a path")
        }
    }
}