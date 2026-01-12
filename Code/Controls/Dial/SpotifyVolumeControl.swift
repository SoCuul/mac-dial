//
//  SpotifyControl
//  MacDial
//
//  Created by Daniel Costa
//
//  License: MIT
//

import AppKit

class SpotifyVolumeControl: DeviceControl {
    func buttonPress(_ dial: Dial) {
    }

    func buttonRelease(_ dial: Dial) {
    }

    func rotationChanged(_ dial: Dial, _ rotation: RotationState) -> Bool {
        let changeIncrements: [WheelSensitivity: Int] = [
            .low: 2,
            .medium: 5,
            .high: 10,
            .custom: max(2, Int(round(Double(UserSettings.customSensitivity / 20)) * 2)) // increments < 2 cause AppleScript rounding issues when getting/setting volume
        ]
        
        var currentVolume = Spotify.soundVolume
                
        switch rotation {
            case .stationary:
                return false
            case .clockwise:
                currentVolume += (changeIncrements[rotation.sensitivity] ?? 0) + 1
            case .counterclockwise:
                currentVolume -= (changeIncrements[rotation.sensitivity] ?? 0) - 1
        }
        
        currentVolume = max(currentVolume, 0)
        
        Spotify.soundVolume = currentVolume
        
        log(tag:"Spotify Volume", "set to: \(currentVolume)")
                    
        if (UserSettings.showOSD) {
            OSD.show(
                currentVolume > 0 ? OSD.images.volume : OSD.images.mute,
                UInt32(currentVolume)
            )
        }
        
        if (currentVolume <= 0 || currentVolume >= 100) {
            dial.isHittingBounds = true
        }

        return true
    }
}
