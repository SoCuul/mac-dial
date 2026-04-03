//
//  ButtonClickControl
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

class ButtonClickControl: DeviceControl {
    private let eventDownType: CGEventType
    private let eventUpType: CGEventType
    private let mouseButton: CGMouseButton
    private var lastButtonState: ButtonState?

    init(eventDownType: CGEventType, eventUpType: CGEventType, mouseButton: CGMouseButton) {
        self.eventDownType = eventDownType
        self.eventUpType = eventUpType
        self.mouseButton = mouseButton
    }

    func buttonPress(_ dial: Dial) {
        if lastButtonState != .pressed {
            lastButtonState = .pressed
            sendMouse(eventType: eventDownType)
        }
    }

    func buttonRelease(_ dial: Dial) {
        if lastButtonState != .released {
            lastButtonState = .released
            sendMouse(eventType: eventUpType)
        }
    }

    private func sendMouse(eventType: CGEventType) {
        let mousePos = NSEvent.mouseLocation
        let screenHeight = NSScreen.main?.frame.height ?? 0
        let translatedMousePos = NSPoint(x: mousePos.x, y: screenHeight - mousePos.y)
        let event = CGEvent(mouseEventSource: nil, mouseType: eventType, mouseCursorPosition: translatedMousePos, mouseButton: self.mouseButton)
        event?.post(tap: .cghidEventTap)

        log(tag: "Scroll", "sent mouse event: \(eventType.rawValue)")
    }

    func rotationChanged(_ dial: Dial, _ rotation: RotationState) -> Bool {
        return false
    }
}
