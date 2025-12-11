//
//  BrightnessControl
//  MacDial
//
//  Created by Daniel Costa
//
//  Based on Alex Babaev sources
//  https://github.com/bealex/mac-dial
//
//  License: MIT
//

import AppKit

class DialBrightnessControl: DeviceControl {
    func buttonPress(_ dial: Dial) {
    }

    func buttonRelease(_ dial: Dial) {
    }

    func rotationChanged(_ dial: Dial, _ rotation: RotationState) -> Bool {
        // .high = Brightness key up/down amount
        let changeIncrements: [WheelSensitivity: Float] = [
            .low: 0.005,
            .medium: 0.01,
            .high: 0.0625,
            .custom: Float(UserSettings.customSensitivity) / 5000
        ]
        
        let previousLevel = Brightness.display
        
        var newLevel = previousLevel
        
        switch rotation {
            case .stationary:
                return false
            case .clockwise:
                newLevel += changeIncrements[rotation.sensitivity] ?? 0
            case .counterclockwise:
                newLevel -= changeIncrements[rotation.sensitivity] ?? 0
        }
        
        Brightness.display = newLevel
        
        // Reflect current display brightness (changed or not)
        let updatedLevel = Brightness.display
        
        log(tag:"Display Brightness", "\(updatedLevel)")
        
        if (UserSettings.showOSD) {
            OSD.show(OSD.images.brightness, UInt32(updatedLevel * 100))
        }
        
        if (updatedLevel <= 0 || updatedLevel >= 1) {
            dial.isHittingBounds = true
        }

        return true
    }
}
