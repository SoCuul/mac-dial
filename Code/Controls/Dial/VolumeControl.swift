//
//  VolumeControl
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

class DialVolumeControl: DeviceControl {
    let changeIncrements: [WheelSensitivity: Float] = [
        .low: 0.005,
        .medium: 0.01,
        .high: 0.0625 // Key volume key up/down amount
    ]

    func buttonPress(_ dial: Dial) {
    }

    func buttonRelease(_ dial: Dial) {
    }

    func rotationChanged(_ dial: Dial, _ rotation: RotationState) -> Bool {
        guard var currentVolume = Sound.volume() else { return false }
        
        switch rotation {
            case .stationary:
                return false
            case .clockwise:
                currentVolume += changeIncrements[rotation.sensitivity] ?? 0
            case .counterclockwise:
                currentVolume -= changeIncrements[rotation.sensitivity] ?? 0
        }
        
        Sound.setVolume(currentVolume)
        
        log(tag:"Volume", "\(currentVolume)")
        
        if (dial.showOSD) {
            OSD.show(
                currentVolume > 0 ? OSD.images.volume : OSD.images.mute,
                UInt32(currentVolume * 100)
            )
        }
        
        if (currentVolume <= 0 || currentVolume >= 1) {
            dial.isHittingBounds = true
        }

        return true
    }
}
