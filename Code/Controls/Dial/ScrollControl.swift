//
//  ScrollControl
//  MacDial
//
//  Created by Daniel Costa
//
//  Based on Alex Babaev sources
//  https://github.com/bealex/mac-dial
//
//  Based on Andreas Karlsson sources
//  https://github.com/andreasjhkarlsson/mac-dial
//
//  License: MIT
//

import AppKit

class DialScrollControl: DeviceControl {
    // Distance to scroll (in pixels)
    private let changeIncrements: [WheelSensitivity: Int] = [
        .low: 1,
        .medium: 40,
        .high: 80
    ]

    func buttonPress(_ dial: Dial) {
    }

    func buttonRelease(_ dial: Dial) {
    }

    func rotationChanged(_ dial: Dial, _ rotation: RotationState) -> Bool {
        var wheel1: Int
        switch rotation {
            case .stationary:
                return false
            case .clockwise:
                wheel1 = changeIncrements[rotation.sensitivity] ?? 0
            case .counterclockwise:
                wheel1 = (changeIncrements[rotation.sensitivity] ?? 0) * -1
        }

        let event = CGEvent(
            scrollWheelEvent2Source: nil,
            units: .pixel,
            wheelCount: 1,
            wheel1: Int32(wheel1),
            wheel2: 0,
            wheel3: 0
        )
        
        var flags: CGEventFlags = []
        if UserSettings.keyScrollModifiers.shift { flags.insert(.maskShift) }
        if UserSettings.keyScrollModifiers.command { flags.insert(.maskCommand) }
        if UserSettings.keyScrollModifiers.option { flags.insert(.maskAlternate) }
        if UserSettings.keyScrollModifiers.control { flags.insert(.maskControl) }
        
        event?.flags = flags
        event?.post(tap: CGEventTapLocation.cghidEventTap)
        
        log(tag: "Scroll", wheel1 > 0 ? "Up" : "Down")

        return true
    }
}
