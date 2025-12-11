//
//  KeyboardBacklightControl
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

class RotationKeyboardBacklightControl: DeviceControl {
    func buttonPress(_ dial: Dial) {
    }

    func buttonRelease(_ dial: Dial) {
    }

    func rotationChanged(_ dial: Dial, _ rotation: RotationState) -> Bool {
        // .high = Keyboard backlight key up/down amount
        let changeIncrements: [WheelSensitivity: Float] = [
            .low: 0.005,
            .medium: 0.01,
            .high: 0.0625,
            .custom: Float(UserSettings.customSensitivity) / 5000
        ]
        
        let previousLevel = Brightness.keyboardBacklight
        
        var newLevel = previousLevel
        
        switch rotation {
            case .stationary:
                return false
            case .clockwise:
                newLevel += changeIncrements[rotation.sensitivity] ?? 0
            case .counterclockwise:
                newLevel -= changeIncrements[rotation.sensitivity] ?? 0
        }
        
        Brightness.keyboardBacklight = newLevel
        
        // Reflect current display brightness (changed or not)
        let updatedLevel = Brightness.keyboardBacklight
        
        log(tag:"Keyboard Backlight", "\(updatedLevel)")
        
        if (UserSettings.showOSD) {
            OSD.show(
                updatedLevel > 0 ? OSD.images.keylight : OSD.images.nokeylight,
                UInt32(updatedLevel * 100)
            )
        }
        
        if (updatedLevel <= 0 || updatedLevel >= 1) {
            dial.isHittingBounds = true
        }

        return true
    }
}
