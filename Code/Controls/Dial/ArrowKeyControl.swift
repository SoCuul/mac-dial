//
//  ArrowKeyControl
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

class ArrowKeyControl: DeviceControl {
    private let rightTurnKeyCode: Int32
    private let leftTurnKeyCode: Int32
    
    init(
        rightTurnKeyCode: Int32,
        leftTurnKeyCode: Int32,
    ) {
        self.rightTurnKeyCode = rightTurnKeyCode
        self.leftTurnKeyCode = leftTurnKeyCode
    }

    func buttonPress(_ dial: Dial) {
    }

    func buttonRelease(_ dial: Dial) {
    }
    
    private var accumulator: Double = 0
    private var lastSentValue: Double = 0
    private var lastRotationDirection: RotationState = .stationary
    
    // TODO: actually test this chatgpt'd mess of code
    func rotationChanged(_ dial: Dial, _ rotation: RotationState) -> Bool {
        if case .stationary = rotation {
            lastRotationDirection = .stationary
            return false
        }
        
        let step: Double = 1
        let coefficient: Double = 0.2

        // Direction-specific values
        let isClockwise = rotation.isClockwise
        let key = isClockwise ? rightTurnKeyCode : leftTurnKeyCode
        let directionStep = isClockwise ? -step : step   // used for lastSentValue correction
        let shouldResetLastSent =
        (isClockwise && lastRotationDirection.sensitivity.rawValue <= 0.0) ||
        (!isClockwise && lastRotationDirection.sensitivity.rawValue >= 0.0)

        if shouldResetLastSent {
            lastSentValue = accumulator + rotation.sensitivity.rawValue * coefficient + directionStep
        }

        lastRotationDirection = isClockwise ? .clockwise(rotation.sensitivity) : .counterclockwise(rotation.sensitivity)
        accumulator += rotation.sensitivity.rawValue * coefficient

        // Calculate number of clicks to send
        let delta = abs(accumulator - lastSentValue)
        let clicks = floor(delta / step)

        guard clicks >= 1 else {
            return true
        }

        let sentValue = lastSentValue + (isClockwise ? 1 : -1) * (clicks * step)
        lastSentValue = sentValue
        
        var modifiers: NSEvent.ModifierFlags = []
        if UserSettings.keyScrollModifiers.shift { modifiers.insert(.shift) }
        if UserSettings.keyScrollModifiers.command { modifiers.insert(.command) }
        if UserSettings.keyScrollModifiers.option { modifiers.insert(.option) }
        if UserSettings.keyScrollModifiers.control { modifiers.insert(.control) }

        HIDPostAuxKey(
            key: key,
            modifiers: modifiers,
            repeatCount: Int(clicks)
        )

        log(tag: "Media", "sent \(isClockwise ? "↑" : "↓")")
        return true
    }
}
