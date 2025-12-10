//
//  DeviceControl
//  MacDial
//
//  Created by Alex Babaev
//
//  Based on Andreas Karlsson sources
//  https://github.com/andreasjhkarlsson/mac-dial
//
//  License: MIT
//

import Foundation

enum ButtonState: Equatable {
    case pressed
    case released
}

enum RotationState: Equatable {
    case clockwise(WheelSensitivity)
    case counterclockwise(WheelSensitivity)
    case stationary

    var sensitivity: WheelSensitivity {
        switch self {
            case .clockwise(let amount): return amount
            case .counterclockwise(let amount): return amount
            case .stationary: return .medium
        }
    }
    
    var customSensitivity: Int {
        UserSettings.customSensitivity
    }
    
    var isClockwise: Bool {
        if case .clockwise = self { return true }
        return false
    }

    var isCounterclockwise: Bool {
        if case .counterclockwise = self { return true }
        return false
    }
}


protocol DeviceControl: AnyObject {
    func buttonPress(_ dial: Dial)
    func buttonRelease(_ dial: Dial)
    
    func rotationChanged(_ dial: Dial, _ rotation: RotationState) -> Bool
}
