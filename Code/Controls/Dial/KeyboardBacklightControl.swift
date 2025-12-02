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

class DialKeyboardBacklightControl: DeviceControl {
    let changeIncrements: [WheelSensitivity: Float] = [
        .low: 0.005,
        .medium: 0.01,
        .high: 0.0625 // Keyboard backlight key up/down amount
    ]

    func buttonPress(_ dial: Dial) {
    }

    func buttonRelease(_ dial: Dial) {
    }

    func rotationChanged(_ dial: Dial, _ rotation: RotationState) -> Bool {
        var currentBrightness = Brightness.keyboardBacklight
        
        switch rotation {
            case .stationary:
                return false
            case .clockwise:
                currentBrightness += changeIncrements[rotation.sensitivity] ?? 0
            case .counterclockwise:
                currentBrightness -= changeIncrements[rotation.sensitivity] ?? 0
        }
        
        Brightness.keyboardBacklight = currentBrightness
        currentBrightness = Brightness.keyboardBacklight
        
        log(tag:"Keyboard Backlight", "\(currentBrightness)")
        
        if (dial.showOSD) {
            OSD.show(
                currentBrightness > 0 ? OSD.images.keylight : OSD.images.nokeylight,
                UInt32(currentBrightness * 100)
            )
        }
        
        if (currentBrightness <= 0 || currentBrightness >= 1) {
            dial.isHittingBounds = true
        }

        return true
    }
}
