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

class RotationArrowKeyControl: DeviceControl {
    private let rightTurnKeyCode: Int32
    private let leftTurnKeyCode: Int32
    
    init(
        rightTurnKeyCode: KeyCode,
        leftTurnKeyCode: KeyCode,
    ) {
        self.rightTurnKeyCode = rightTurnKeyCode.rawValue
        self.leftTurnKeyCode = leftTurnKeyCode.rawValue
    }

    func buttonPress(_ dial: Dial) {
    }

    func buttonRelease(_ dial: Dial) {
    }
    
    private var accumulator: Double = 0
    private var lastSentValue: Double = 0
    private var lastRotationDirection: RotationState = .stationary
    
    func rotationChanged(_ dial: Dial, _ rotation: RotationState) -> Bool {
        if case .stationary = rotation {
            lastRotationDirection = .stationary
            return false
        }

        let step: Double = 1
        let coefficient: Double = 0.2

        let sensitivityValue = rotation.customSensitivity
        ? Double(UserSettings.customSensitivity) / 50.0
            : Double(rotation.sensitivity.rawValue)

        let key = rotation.isClockwise ? rightTurnKeyCode : leftTurnKeyCode

        accumulator += sensitivityValue * coefficient

        let totalSteps = Int(accumulator / step)
        guard totalSteps != 0 else { return false }

        var modifiers: CGEventFlags = []
        if UserSettings.keyScrollModifiers.shift { modifiers.insert(.maskShift) }
        if UserSettings.keyScrollModifiers.command { modifiers.insert(.maskCommand) }
        if UserSettings.keyScrollModifiers.option { modifiers.insert(.maskAlternate) }
        if UserSettings.keyScrollModifiers.control { modifiers.insert(.maskControl) }

        HIDPostAuxKey(
            key: key,
            modifiers: modifiers,
            repeatCount: abs(totalSteps)
        )

        log(tag: "Key", "sent \(keycodeToDisplayString(key)) x\(abs(totalSteps))")

        accumulator -= Double(totalSteps) * step

        lastRotationDirection = rotation.isClockwise
            ? .clockwise(rotation.sensitivity)
            : .counterclockwise(rotation.sensitivity)

        return true
    }

}
