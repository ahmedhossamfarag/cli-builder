struct RepeatCommand: Command{
    @Argument(type: STRING(), help: "pattern to repeat") var command: String
    @Option(type: INT(min: 0), short: "c", help: "number of times to repeat") var count: Int?
    @Flag(short: "v") var verbose: Bool
    @Option(type: INT(min: 0), short: "n", multiple: true, help: "just numbers") var number: [Int]?

    var name: String = "repeat"
    var help: String? = "repeat a command multiple times"

    func run() throws {
        print("repeating \(command) \(count ?? 0) times with verbose: \(verbose), numbers: \(number ?? [])")
    }
}

struct Group: CommandGroup{
    var commands: [Command] = [RepeatCommand()]
}

do{
    var x = Group()
    try x.run()
}catch let error as CommandError{
    print(error.message)
}