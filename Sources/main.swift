import Rainbow
import Foundation

extension String {
    func atCenter(width: Int) -> Self {
        String(repeating: " ", count: (max(0, width - count)) / 2) + self
    }
    
    var isOption: Bool {
        count == 2 && self[startIndex] == "-" && self[index(startIndex, offsetBy: 1)].isLetter || starts(with: "--")
    }
}

func writeError(_ message: String) {
    if let data = "chalk: \(message)\n".data(using: .utf8) {
        try? FileHandle.standardError.write(contentsOf: data)
    }
}

func getTerminalWidth() -> Int? {
    var winsize = winsize()
    if ioctl(STDOUT_FILENO, TIOCGWINSZ, &winsize) == 0 {
        return Int(winsize.ws_col)
    }
    return nil
}

func printColorPreview(_ color: Int) {
    print("\("\(String(format: "%-3d", color))".onBit8(UInt8(color)))\(" ChK ".bit8(UInt8(color)))", terminator: "")
}

func printStandardColors() {
    print("Standard".bold)
    for color in 0...15 {
        printColorPreview(color)
        if color == 7 || color == 15 {
            print()
        }
    }
}

func printCubeGradient(from initialColor: Int, width: Int) {
    func createTitle(consideringInitialColor initialColor: Int) -> String {
        "Cube Gradient \(initialColor) – \(initialColor + 35)"
    }
    
    let firstTitle = createTitle(consideringInitialColor: initialColor)
    let secondTitle = createTitle(consideringInitialColor: initialColor + 36)
    print("\(firstTitle.bold)\(String(repeating: " ", count: max(0, 51 - firstTitle.count)))\(secondTitle.bold)")
    for lineOffset in 0...5 {
        var baseColor = initialColor + lineOffset * 6
        for color in baseColor...baseColor + 5 {
            printColorPreview(color)
        }
        baseColor += 36
        print("   ", terminator: "")
        for color in baseColor...baseColor + 5 {
            printColorPreview(color)
        }
        print()
    }
}

func printGrayscale() {
    print("Grayscale".bold)
    for color in 232...255 {
        printColorPreview(color)
        if color == 243 || color == 255 {
            print()
        }
    }
}

func writeHelp() {
    print(
        """
        Usage: chalk [OPTIONS]...
        Displays the terminal 8-bits colors, useful for debugging.
        
        AVAILABLE OPTIONS
            -h, --help     shows the software help instructions.
            -v, --version  shows the software version.
        """
    )
}

func writeVersion() {
    print("chalk 1.0.0 (https://gitlab.com/skippyr/Chalk)")
}

if isatty(STDOUT_FILENO) == 0 {
    writeError("the terminal output stream can not be redirected.")
    exit(1)
}
let minimumTerminalWidth = 99
guard let terminalWidth = getTerminalWidth() else {
    writeError("can not get the terminal dimensions.")
    exit(1)
}
if terminalWidth < minimumTerminalWidth {
    writeError("the terminal width must be at least \(minimumTerminalWidth) columns.")
    exit(1)
}

for argument in CommandLine.arguments.dropFirst() {
    switch argument {
    case "-h", "--help":
        writeHelp()
        exit(0)
    case "-v", "--version":
        writeVersion()
        exit(0)
    default:
        if argument.isOption {
            writeError("invalid option \"\(argument)\" provided.")
            exit(1)
        }
    }
}

printStandardColors()
print()
printCubeGradient(from: 16, width: terminalWidth)
print()
printCubeGradient(from: 88, width: terminalWidth)
print()
printCubeGradient(from: 160, width: terminalWidth)
print()
printGrayscale()
