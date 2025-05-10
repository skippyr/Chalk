import Rainbow
import AppKit

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
        \(":".yellow.bold)\("<>".red.bold)\("::".yellow.bold) \("Usage:".magenta.bold) chalk [\("OPTIONS".cyan.underline)]...
        Displays the terminal 8-bits ANSI colors, useful for debugging.

        \("❡ AVAILABLE OPTIONS".magenta.bold)
            \("-h".cyan), \("--help".cyan)        shows the software help instructions.
            \("-v".cyan), \("--version".cyan)     shows the software version.
            \("-l".cyan), \("--license".cyan)     shows the software license.
            \("-g".cyan), \("--repository".cyan)  opens the software repository.
            \("-m".cyan), \("--email".cyan)       drafts an e-mail to the developer.
        """
    )
}

func openUrl(_ url: String) {
    NSWorkspace.shared.open(URL(string: url)!)
}

func writeVersion() {
    print("""
    \("chalk".magenta.bold) v1.0.1 (macOS)
    Available at: \("https://github.com/skippyr/Chalk".cyan.underline).

    Licensed under the BSD-3-Clause License.
    Copyright © 2023 Sherman Rofeman <\("skippyr.developer@icloud.com".cyan.underline)>.
    """)
}

func writeLicense() {
    print("""
    BSD 3-Clause License

    Copyright (c) 2025, Sherman Rofeman <skippyr.developer@icloud.com>

    Redistribution and use in source and binary forms, with or without
    modification, are permitted provided that the following conditions are met:

    1. Redistributions of source code must retain the above copyright notice, this
    list of conditions and the following disclaimer.

    2. Redistributions in binary form must reproduce the above copyright notice,
    this list of conditions and the following disclaimer in the documentation
    and/or other materials provided with the distribution.

    3. Neither the name of the copyright holder nor the names of its
    contributors may be used to endorse or promote products derived from
    this software without specific prior written permission.

    THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
    AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
    IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
    DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
    FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
    DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
    SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
    CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
    OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
    OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
    
    """)
}

func openRepository() {
    openUrl("https://github.com/skippyr/Chalk")
}

func draftEmailToDeveloper() {
    openUrl("mailto:skippyr.developer@icloud.com")
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
    case "-l", "--license":
        writeLicense()
        exit(0)
    case "-g", "--repository":
        openRepository()
        exit(0)
    case "-m", "--email":
        draftEmailToDeveloper()
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
