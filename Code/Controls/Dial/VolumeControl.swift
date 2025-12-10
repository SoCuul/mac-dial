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
    func buttonPress(_ dial: Dial) {
    }

    func buttonRelease(_ dial: Dial) {
    }

    func rotationChanged(_ dial: Dial, _ rotation: RotationState) -> Bool {
        // .high = Volume key up/down amount
        let changeIncrements: [WheelSensitivity: Float] = [
            .low: 0.005,
            .medium: 0.01,
            .high: 0.0625,
            .custom: Float(UserSettings.customSensitivity) / 5000
        ]
        
        guard let previousLevel = Sound.volume() else { return false }
        
        var newLevel = previousLevel
                
        switch rotation {
            case .stationary:
                return false
            case .clockwise:
                newLevel += changeIncrements[rotation.sensitivity] ?? 0
            case .counterclockwise:
                newLevel -= changeIncrements[rotation.sensitivity] ?? 0
        }

        // Make sure volume doesn't go under 0 or over 1
        newLevel = ClosedRange(uncheckedBounds: (0, 1))
            .clamp(previousLevel.roundTo(places: 4))
        
        Sound.setVolume(newLevel)
        
        // Reflect current output volume (changed or not)
        if let updatedLevel = Sound.volume() {
            log(tag:"Volume", "\(updatedLevel)")
            
            print("Previous level: \(previousLevel)\nNew level: \(newLevel)\nUpdated Level: \(updatedLevel)\nDoesn't equal: \(updatedLevel != previousLevel)")
            
//            if ((updatedLevel != previousLevel) && UserSettings.showOSD) {
//                OSD.show(
//                    updatedLevel > 0 ? OSD.images.volume : OSD.images.mute,
//                    UInt32(updatedLevel * 100)
//                )
//            }
            
            if (updatedLevel <= 0 || updatedLevel >= 1) {
                dial.isHittingBounds = true
            }
        }

        return true
    }
}
