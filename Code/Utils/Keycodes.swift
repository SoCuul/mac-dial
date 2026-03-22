//
//  Keycodes
//  MacDial
//
//  Created by Daniel Costa
//
//  License: MIT
//

import Foundation
import Carbon

enum KeyCode: Int32 {
    case leftArrow = 123
    case rightArrow = 124
    case upArrow = 126
    case downArrow = 125
    case leftSquareBracket = 33
    case rightSquareBracket = 30
    case plus = 69
    case minus = 27
}

private let specialSymbols: [Int32: String] = [
    123: "←",
    124: "→",
    125: "↓",
    126: "↑",
    51:  "⌫",
    117: "⌦",
    36:  "⏎",
    48:  "⇥",
    53:  "⎋",
    49:  "␣",

    // modifiers (left + right)
    59:  "⌃", // control L
    62:  "⌃", // control R
    58:  "⌥", // option L
    61:  "⌥", // option R
    55:  "⌘", // command L
    54:  "⌘", // command R
    63:  "fn"
]

func keycodeToDisplayString(_ keyCode: Int32) -> String {
    if let s = specialSymbols[keyCode] { return s }
    
    return String(keyCode)
}

// https://stackoverflow.com/a/55854051
func HIDPostAuxKey(key: Int32, modifiers: CGEventFlags, repeatCount: Int = 1) {
    func doKey(down: Bool) {
        var rawFlags: UInt64 = (down ? 0xa00 : 0xb00);
        rawFlags |= UInt64(modifiers.rawValue)
        let flags = CGEventFlags(rawValue: rawFlags)

        let src = CGEventSource(stateID: .hidSystemState)
        let command = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(key), keyDown: down)
        
        command?.flags = flags

        command?.post(tap: CGEventTapLocation.cghidEventTap)
    }

    for _ in 0 ..< repeatCount {
        doKey(down: true)
        doKey(down: false)
    }
}
