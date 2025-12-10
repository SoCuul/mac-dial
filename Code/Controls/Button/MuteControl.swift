//
//  MuteControl
//  MacDial
//
//  Created by Daniel Costa
//
//  License: MIT
//

import AppKit

class ButtonMuteControl: DeviceControl {
    func buttonPress(_ dial: Dial) {
        startedPressingAt = Date.timeIntervalSinceReferenceDate
    }
    
    private var startedPressingAt: TimeInterval = Date.timeIntervalSinceReferenceDate

    func buttonRelease(_ dial: Dial) {
        if ((Date.timeIntervalSinceReferenceDate - startedPressingAt) >= 0.35) {
            log(tag: "Mute", "button held for extended period, discarding input")
            
            return
        }
        startedPressingAt = 0
        
        guard var isMuted = Sound.isMuted() else { return }
        isMuted = !isMuted
        
        Sound.mute(isMuted)
        
        log(tag:"Mute", "\(isMuted)")
        
        if (UserSettings.showOSD) {
            if let currentVolume = Sound.volume() {
                OSD.show(
                    isMuted ? OSD.images.mute : OSD.images.volume,
                    UInt32(isMuted ? 0 : (currentVolume * 100))
                )
            }
        }
    }

    func rotationChanged(_ dial: Dial, _ rotation: RotationState) -> Bool {
        false
    }
}
