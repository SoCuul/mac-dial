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
    private let changeIncrements: [WheelSensitivity: Float] = [
        .low: 0.005,
        .medium: 0.01,
        .high: 0.0625 // Brightness key up/down amount
    ]

    func buttonPress(_ dial: Dial) {
    }

    func buttonRelease(_ dial: Dial) {
    }

    func rotationChanged(_ dial: Dial, _ rotation: RotationState) -> Bool {
        var currentBrightness = Brightness.display
        
        switch rotation {
            case .stationary:
                return false
            case .clockwise:
                currentBrightness += changeIncrements[rotation.sensitivity] ?? 0
            case .counterclockwise:
                currentBrightness -= changeIncrements[rotation.sensitivity] ?? 0
        }
        
        Brightness.display = currentBrightness
        currentBrightness = Brightness.display
        
        log(tag:"Display Brightness", "\(currentBrightness)")
        
        if (dial.showOSD) {
            OSD.show(OSD.images.brightness, UInt32(currentBrightness * 100))
        }
        
        if (currentBrightness <= 0 || currentBrightness >= 1) {
            dial.isHittingBounds = true
        }

        return true
    }
}
