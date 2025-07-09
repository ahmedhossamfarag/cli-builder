struct RepeatCommand: Command{
    @Argument(type: STRING()) var command: String
    @Option(type: INT(min: 0), short: "c") var count: Int?
    @Flag(short: "v") var verbose: Bool

    var name: String = "repeat"
    var help: String? = "repeat a command multiple times"

    func run() throws {
        print("repeating \(command) \(count ?? 0) times with verbose: \(verbose)")
    }
}

struct Group: CommandGroup{
    var commands: [Command] = [RepeatCommand()]
}

do{
    var x = Group()
    try x.run()
}catch{
    print(error)
}