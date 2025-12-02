//
//  PlaybackControl
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

class ButtonPlaybackControl: DeviceControl {
    func buttonPress(_ dial: Dial) {
        startedPressingAt = Date.timeIntervalSinceReferenceDate
    }
    
    private var numberOfClicks: Int = 0
    private var startedPressingAt: TimeInterval = Date.timeIntervalSinceReferenceDate

    func buttonRelease(_ dial: Dial) {
        if ((Date.timeIntervalSinceReferenceDate - startedPressingAt) >= 0.35) {
            log(tag: "Media", "button held for extended period, discarding input")
            
            numberOfClicks = 0
            
            return
        }
        startedPressingAt = 0
        
        let currentNumberOfClicks = numberOfClicks + 1
        numberOfClicks = currentNumberOfClicks
        log(tag: "Media", "counting clicks: \(numberOfClicks)")

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) { [self] in
            guard currentNumberOfClicks == numberOfClicks else { return }

            switch numberOfClicks {
                case 1:
                    MRMediaRemoteSendCommand(MRMediaRemoteCommandTogglePlayPause, nil)
    
                    log(tag: "Media", "sent Play/Pause")
                case 2:
                    MRMediaRemoteSendCommand(MRMediaRemoteCommandNextTrack, nil)
                    
                    log(tag: "Media", "sent Play Next")
                case 3 ... 1000:
                    MRMediaRemoteSendCommand(MRMediaRemoteCommandPreviousTrack, nil)
    
                    log(tag: "Media", "sent Play Previous")
                default:
                    break
            }

            numberOfClicks = 0
        }
    }

    func rotationChanged(_ dial: Dial, _ rotation: RotationState) -> Bool {
        false
    }
}
