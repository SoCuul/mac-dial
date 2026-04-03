//
//  Dial
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

class Dial {
    // MARK: - Temporary state
    
    var controls: [DeviceControl] = []
    
    var isHittingBounds: Bool {
        get { device.isHittingBounds }
        set { device.isHittingBounds = newValue }
    }
    
    // MARK: - Device

    private var device: DialDevice!

    init(
        connectionHandler: @escaping (_ serialNumber: String) -> Void,
        disconnectionHandler: @escaping () -> Void
    ) {
        device = DialDevice(
            buttonHandler: processButton,
            rotationHandler: processRotation,
            connectionHandler: connectionHandler,
            disconnectionHandler: disconnectionHandler
        )
    }

    deinit {
        device.disconnect()
    }

    private var lastButtonState: ButtonState = .released

    private func processButton(state: ButtonState) {
        let lastButtonState = lastButtonState
        self.lastButtonState = state

        switch (lastButtonState, state) {
            case (.released, .pressed): controls.forEach { $0.buttonPress(self) }
            case (.pressed, .released): controls.forEach { $0.buttonRelease(self) }
            default: break
        }
    }

    private func processRotation(state: RotationState) -> Bool {
        // Reset haptic bounds
        self.isHittingBounds = false
        
        var result = false
        controls.forEach { result = $0.rotationChanged(self, state) || result }
        return result
    }
    
    public func sendKeepAlive() {
        device.sendKeepAlive()
    }
    
    public func sendHaptic(pattern: DialDevice.DeviceHaptic) {
        device.sendHaptic(pattern: pattern)
    }
}
