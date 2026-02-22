//
//  AppVolumeControl
//  MacDial
//
//  Created by Daniel Costa
//
//  License: MIT
//

import AppKit

class AppVolumeControl: DeviceControl {
    private func limitVolume(_ vol: Int) -> Int {
        return min(max(vol, app.minVolume), app.maxVolume)
    }
    
    
    private let app: ControllableAppVolumeInstance.Type
    
    init(
        _ app: ControllableAppVolume,
    ) {
        self.app = app.instance
    }
    
    func buttonPress(_ dial: Dial) {
    }

    func buttonRelease(_ dial: Dial) {
    }

    func rotationChanged(_ dial: Dial, _ rotation: RotationState) -> Bool {
        let changeIncrements: [WheelSensitivity: Int] = [
            .low: 1,
            .medium: 5,
            .high: 10,
            .custom: max(1, Int(round(Double(UserSettings.customSensitivity / 20)) * 2))
        ]
        var currentVolume = limitVolume(app.soundVolume)
        
        var changeIncrement = changeIncrements[rotation.sensitivity] ?? 1
        
        // spotify returns the actual value one too small for some reason (100 -> 100 | 99 -> 98 ... 1 -> 0)
        // except on intervals of 20, idk why (0 -> 0 | 20 -> 20 | 40 -> 40 | 60 -> 60 | 80 -> 80 | 100 -> 100)
        // this works around it enough to make it usable
        var incrementOffset = 0
        if (app.type == .spotify) {
            incrementOffset += 1
            
            changeIncrement += 1
        }
        
        switch rotation {
            case .stationary:
                return false
            case .clockwise:
                currentVolume += ((changeIncrement + incrementOffset) <= 1 && currentVolume == 0)
                ? 2 // prevent getting stuck on 1
                : (changeIncrement + incrementOffset)
            case .counterclockwise:
                currentVolume -= (changeIncrement - incrementOffset)
        }
        
        currentVolume = limitVolume(currentVolume)
        app.soundVolume = currentVolume
        
        log(tag:"\(app.name) Volume", "set to: \(currentVolume)")
                    
        if (UserSettings.showOSD) {
            OSD.show(
                currentVolume > app.minVolume ? OSD.images.volume : OSD.images.mute,
                UInt32((Double(currentVolume) / Double(app.maxVolume)) * 100)
            )
        }
        
        if (currentVolume <= app.minVolume || currentVolume >= app.maxVolume) {
            dial.isHittingBounds = true
        }

        return true
    }
}

