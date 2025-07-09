import Runtime
import Foundation

/**
 * cli-builder is a command line interface builder for swift. It helps you define a cli interface with a simple and intuitive api.
 *
 * Usage:
 *  define a command
 *  
 *  - `name` is the name of the command. It is used as the first argument in the cli.
 *  - `help` is a help message for the command.
 * 
 *  ```swift
 *  struct Repeat: Command{
 *      @Argument
 *      var message: String
 *  }
 *  ```
 *
 **/

public protocol Command{
    var name: String { get }
    var help: String? { get }

    mutating func run() throws
}

extension Command{
    var name: String { 
        let typeName = String(describing: type(of: self))
        let regex = try! Regex("([a-z])([A-Z])")

        return typeName.replacing(regex) { (match: Regex.Match) in
            let first = match[1]
            let second = match[2]
            return "\(first.value!)-\(second.value!)"
        }.lowercased() 
    }

    var help: String? { return nil }

    func getArguments() throws -> [(PropertyInfo, IsArgument)]{
        do{
            let info = try typeInfo(of: type(of: self))
            var args = [(PropertyInfo, IsArgument)]()
            for prop in info.properties {
                if prop.type.self is IsArgument.Type {
                    if var arg = try prop.get(from: self) as? IsArgument {
                        if arg.name == nil {
                            arg.name = prop.name.suffix(from: 1)
                        }
                        args.append((prop, arg))
                    }
                }
            }
            return args
        }catch{
            throw CommandError.FailedTogetArguments(of: String(describing: type(of: self)))
        }
    }

    func getFlags(unique: Bool = false) throws -> [String: (PropertyInfo, IsFlag)]{
        do{
            let info = try typeInfo(of: type(of: self))
            var flags = [String: (PropertyInfo, IsFlag)]()
            for prop in info.properties {
                if prop.type.self is IsFlag.Type {
                    if var flag = try prop.get(from: self) as? IsFlag {
                        if flag.name == nil {
                            flag.name = prop.name.suffix(from: 1)
                        }
                        flags["--" + flag.name!] = (prop, flag)
                        if flag.short != nil && !unique {
                            flags["-" + flag.short!] = (prop, flag)
                        }
                    }
                }
            }
            return flags
        }catch{
            throw CommandError.FailedTogetFlags(of: String(describing: type(of: self)))
        }
    }

    func getOptions(unique: Bool = false) throws -> [String: (PropertyInfo, IsOption)]{
        do{
            let info = try typeInfo(of: type(of: self))
            var options = [String: (PropertyInfo, IsOption)]()
            for prop in info.properties {
                if prop.type.self is IsOption.Type {
                    if var option = try prop.get(from: self) as? IsOption {
                        if option.name == nil {
                            option.name = prop.name.suffix(from: 1)
                        }
                        options["--" + option.name!] = (prop, option)
                        if option.short != nil && !unique {
                            options["-" + option.short!] = (prop, option)
                        }
                    }
                }
            }
            return options
        }catch{
            throw CommandError.FailedTogetOptions(of: String(describing: type(of: self)))
        }
    }

    mutating func parse(_ patterns: [String]) throws{
        if patterns.count == 1, patterns[0] == "--help" || patterns[0] == "-h" {
            try printHelp()
            return
        }

        let args = try getArguments()
        var opts = try getOptions()
        var flags = try getFlags()

        if patterns.count < args.count {
            throw CommandError.TooFewArguments(should: args.count, got: patterns.count)
        }
        for i in 0 ..< args.count {
            var arg = args[i].1
            arg.value = try arg.cast(value: patterns[i])
            let prop = args[i].0
            try prop.set(value: arg, on: &self)
        }

        var i = args.count
        while i < patterns.count {
            if let flag = flags[patterns[i]] {
                var (prop, flag) = flag
                flag.value = true
                try prop.set(value: flag, on: &self)
                flags.removeValue(forKey: patterns[i])
                i += 1
            }else if let option = opts[patterns[i]] {
                if (i + 1) >= patterns.count {
                    throw CommandError.UnsetOption(name: patterns[i])
                }
                var (prop, option) = option
                if(option.multiple){
                    if option.value == nil {
                        option.value = [Any]()
                    }
                    option.value = [Any](option.value as! [Any] + [try option.cast(value: patterns[i + 1])])
                    opts.updateValue((prop, option), forKey: patterns[i])
                }else{
                    option.value = try option.cast(value: patterns[i + 1])
                }
                try prop.set(value: option, on: &self)
                if !option.multiple {
                    opts.removeValue(forKey: patterns[i])
                }
                i += 2
            }else{
                throw CommandError.UnknownOption(name: patterns[i])
            }
        }

        try run()
    }

    func printHelp() throws{
        let args = try getArguments()
        let opts = try getOptions(unique: true)
        let flags = try getFlags(unique: true)
        print("\(name) \(args.map{$0.1.name!.uppercased()}.joined(separator: " "))")
        if let help = help {
            print()
            print(help)
        }
        print();
        if !args.isEmpty{
            print("Arguments:")
            for arg in args {
                print("  \(arg.1.name!.uppercased()) \t \(arg.1.help ?? "")")
            }
        }
        if !opts.isEmpty{
            print()
            print("Options:")
            for opt in opts {
                print("  --\(opt.1.1.name!), \(opt.1.1.short != nil ? "-" + opt.1.1.short! : "") \t \(opt.1.1.help ?? "")")
            }
        }
        if !flags.isEmpty{
            print()
            print("Flags:")
            for flag in flags {
                print("  \(flag.1.1.name!), \(flag.1.1.short != nil ? "-" + flag.1.1.short! : "") \t \(flag.1.1.help ?? "")")
            }
        }
    }
}

extension String{
    func suffix(from start: Int) -> String {
        let start = index(startIndex, offsetBy: start)
        return String(self.suffix(from: start))
    }
}