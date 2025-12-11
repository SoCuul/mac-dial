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

func keycodeToDisplayString(_ keycode: Int32) -> String? {
    if let s = specialSymbols[keycode] { return s }

    guard
        let source = TISCopyCurrentKeyboardInputSource()?.takeRetainedValue(),
        let layout = TISGetInputSourceProperty(source, kTISPropertyUnicodeKeyLayoutData)
    else { return nil }

    let data = unsafeBitCast(layout, to: CFData.self)
    let ptr = unsafeBitCast(CFDataGetBytePtr(data), to: UnsafePointer<UCKeyboardLayout>.self)

    var dead: UInt32 = 0
    var chars = [UniChar](repeating: 0, count: 4)
    var len = 0

    let status = UCKeyTranslate(
        ptr,
        UInt16(keycode),
        UInt16(kUCKeyActionDisplay),
        0,
        UInt32(LMGetKbdType()),
        OptionBits(kUCKeyTranslateNoDeadKeysBit),
        &dead,
        chars.count,
        &len,
        &chars
    )

    return status == noErr && len > 0
        ? String(utf16CodeUnits: chars, count: len)
        : nil
}
