//
//  AppleScript
//  MacDial
//
//  Created by Daniel Costa
//
//  License: MIT

import Foundation

private func getValueCode(_ value: Any?) -> String? {
    guard let number = value as? NSNumber else { return nil }
    
    let code = OSType(truncating: number)
    let chars = String(format:"%c%c%c%c",
                       (code >> 24) & 0xff,
                       (code >> 16) & 0xff,
                       (code >> 8) & 0xff,
                       code & 0xff)

    return chars
}

// MARK: - Enum argument commands

class scriptable_setRotationMode: NSScriptCommand {
    override func performDefaultImplementation() -> Any? {

        guard let args = self.evaluatedArguments else { return nil }
        
        log(tag:"Scripting: setRotationMode", "Received args: \(args)")
        
        guard let enumValue = args[""] as? Int64 else { return nil }
        
        if let code = getValueCode(enumValue) {
            switch (code) {
                case "MDRv":
                    AppController.shared.setDialMode(mode: .volume)
                case "MDRb":
                    AppController.shared.setDialMode(mode: .brightness)
                case "MDRk":
                    AppController.shared.setDialMode(mode: .keyboard)
                case "MDRs":
                    AppController.shared.setDialMode(mode: .scrolling)
                case "MDno":
                    AppController.shared.setDialMode(mode: .none)
                default:
                    return nil
            }
        }
        
        return nil
        
    }
}

class scriptable_setButtonMode: NSScriptCommand {
    override func performDefaultImplementation() -> Any? {

        guard let args = self.evaluatedArguments else { return nil }
        
        log(tag:"Scripting: setButtonMode", "Received args: \(args)")
        
        guard let enumValue = args[""] as? Int64 else { return nil }
        
        if let code = getValueCode(enumValue) {
            switch (code) {
                case "MDBp":
                    AppController.shared.setButtonMode(mode: .playback)
                case "MDBl":
                    AppController.shared.setButtonMode(mode: .leftClick)
                case "MDBm":
                    AppController.shared.setButtonMode(mode: .mute)
                case "MDno":
                    AppController.shared.setButtonMode(mode: .none)
                default:
                    return nil
            }
        }
        
        return nil
        
    }
}

class scriptable_setWheelSensitivity: NSScriptCommand {
    override func performDefaultImplementation() -> Any? {

        guard let args = self.evaluatedArguments else { return nil }
        
        log(tag:"Scripting: setWheelSensitivity", "Received args: \(args)")
        
        guard let enumValue = args[""] as? Int64 else { return nil }
        
        if let code = getValueCode(enumValue) {
            switch (code) {
                case "MDSl":
                    AppController.shared.setSensitivity(sensitivity: .low)
                case "MDSm":
                    AppController.shared.setSensitivity(sensitivity: .medium)
                case "MDSh":
                    AppController.shared.setSensitivity(sensitivity: .high)
                case "MDSc":
                    AppController.shared.setSensitivity(sensitivity: .custom)
                default:
                    return nil
            }
        }
        
        return nil
        
    }
}

class scriptable_setWheelDirection: NSScriptCommand {
    override func performDefaultImplementation() -> Any? {

        guard let args = self.evaluatedArguments else { return nil }
        
        log(tag:"Scripting: setWheelDirection", "Received args: \(args)")
        
        guard let enumValue = args[""] as? Int64 else { return nil }
        
        if let code = getValueCode(enumValue) {
            switch (code) {
                case "MDDr":
                    AppController.shared.setDirection(direction: .clockwise)
                case "MDDl":
                    AppController.shared.setDirection(direction: .counterclockwise)
                default:
                    return nil
            }
        }
        
        return nil
        
    }
}

class scriptable_setStatusIcon: NSScriptCommand {
    override func performDefaultImplementation() -> Any? {

        guard let args = self.evaluatedArguments else { return nil }
        
        log(tag:"Scripting: setStatusIcon", "Received args: \(args)")
        
        guard let enumValue = args[""] as? Int64 else { return nil }
        
        if let code = getValueCode(enumValue) {
            switch (code) {
                case "MDMd":
                    AppController.shared.setStatusIcon(icon: .default)
                case "MDMr":
                    AppController.shared.setStatusIcon(icon: .rotation)
                case "MDMb":
                    AppController.shared.setStatusIcon(icon: .button)
                default:
                    return nil
            }
        }
        
        return nil
        
    }
}


// MARK: - Bool argument commands

class scriptable_setHaptics: NSScriptCommand {
    override func performDefaultImplementation() -> Any? {

        guard let args = self.evaluatedArguments else { return nil }
        
        log(tag:"Scripting: setHaptics", "Received args: \(args)")
        
        if let enabled = args[""] as? Bool {
            AppController.shared.setHaptics(enabled: enabled)
        }
        
        return nil
        
    }
}

class scriptable_setKeepDialAwake: NSScriptCommand {
    override func performDefaultImplementation() -> Any? {

        guard let args = self.evaluatedArguments else { return nil }
        
        log(tag:"Scripting: setKeepDialAwake", "Received args: \(args)")
        
        if let enabled = args[""] as? Bool {
            AppController.shared.setKeepDialAwake(enabled: enabled)
        }
        
        return nil
        
    }
}

class scriptable_setShowOsd: NSScriptCommand {
    override func performDefaultImplementation() -> Any? {

        guard let args = self.evaluatedArguments else { return nil }
        
        log(tag:"Scripting: setShowOsd", "Received args: \(args)")
        
        if let enabled = args[""] as? Bool {
            AppController.shared.setShowOSD(enabled: enabled)
        }
        
        return nil
        
    }
}
