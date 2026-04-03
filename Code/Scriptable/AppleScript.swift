//
//  AppleScript
//  MacDial
//
//  Created by Daniel Costa
//
//  License: MIT
//

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

private func getValueCodeString(value: Any?, code: String) -> String {
    return value != nil
        ? "\(value ?? "?") -> \(code)"
        : code
}

// MARK: - Enum argument commands

@MainActor
class scriptable_setRotationMode: NSScriptCommand {
    
    /// ## Applescript Usage
    ///```perl
    ///tell application "MacDial"
    ///    set status icon rotation mode
    ///
    ///    set rotation mode volume
    ///    delay 2
    ///    set rotation mode brightness
    ///    delay 2
    ///    set rotation mode keyboard
    ///    delay 2
    ///    set rotation mode scrolling
    ///    delay 2
    ///    set rotation mode brush size
    ///    delay 2
    ///    set rotation mode left right
    ///    delay 2
    ///    set rotation mode up down
    ///    delay 2
    ///    set rotation mode plus minus
    ///    delay 2
    ///    set rotation mode apple music volume
    ///    delay 2
    ///    set rotation mode spotify volume
    ///    delay 2
    ///    set rotation mode vlc volume
    ///    delay 2
    ///    set rotation mode none
    ///    delay 2
    ///    set rotation mode volume
    ///    delay 2
    ///
    ///    set status icon default
    ///end tell
    ///```
    
    override func performDefaultImplementation() -> Any? {

        guard let args = self.evaluatedArguments else { return nil }
        
        log(tag:"Scripting: setRotationMode", "Received args: \(args)")
        
        guard let enumValue = args[""] as? Int64 else { return nil }
        
        if let code = getValueCode(enumValue) {
            log(tag:"Scripting: setRotationMode", "Enum code: \(getValueCodeString(value: args.values.first, code: code))")
            
            switch (code) {
                case "RMvo":
                    AppController.shared.setRotationMode(mode: .volume)
                case "RMbr":
                    AppController.shared.setRotationMode(mode: .brightness)
                case "RMkb":
                    AppController.shared.setRotationMode(mode: .keyboard)
                case "RMsr":
                    AppController.shared.setRotationMode(mode: .scrolling)
                case "RMbs":
                    AppController.shared.setRotationMode(mode: .brushSize)
                case "RMlr":
                    AppController.shared.setRotationMode(mode: .leftRight)
                case "RMud":
                    AppController.shared.setRotationMode(mode: .upDown)
                case "RMpm":
                    AppController.shared.setRotationMode(mode: .plusMinus)
                case "RMam":
                    AppController.shared.setRotationMode(mode: .appleMusicVolume)
                case "RMsp":
                    AppController.shared.setRotationMode(mode: .spotifyVolume)
                case "RMvl":
                    AppController.shared.setRotationMode(mode: .vlcVolume)
                case "MDno":
                    AppController.shared.setRotationMode(mode: .none)
                default:
                    return nil
            }
        }
        
        return nil
        
    }
}

@MainActor
class scriptable_setButtonMode: NSScriptCommand {
    
    /// ## Applescript Usage
    ///```perl
    ///tell application "MacDial"
    ///    set status icon button mode
    ///
    ///    set button mode playback
    ///    delay 2
    ///    set button mode mute
    ///    delay 2
    ///    set button mode left click
    ///    delay 2
    ///    set button mode none
    ///    delay 2
    ///    set button mode mute
    ///    delay 2
    ///
    ///    set status icon default
    ///end tell
    ///```
    
    override func performDefaultImplementation() -> Any? {

        guard let args = self.evaluatedArguments else { return nil }
        
        log(tag:"Scripting: setButtonMode", "Received args: \(args)")
        
        guard let enumValue = args[""] as? Int64 else { return nil }
        
        if let code = getValueCode(enumValue) {
            log(tag:"Scripting: setButtonMode", "Enum code: \(getValueCodeString(value: args.values.first, code: code))")
            
            switch (code) {
                case "BMpl":
                    AppController.shared.setButtonMode(mode: .playback)
                case "BMlc":
                    AppController.shared.setButtonMode(mode: .leftClick)
                case "BMmu":
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

@MainActor
class scriptable_setWheelSensitivity: NSScriptCommand {
    
    /// ## Applescript Usage
    ///```perl
    ///tell application "MacDial"
    ///    set wheel sensitivity low
    ///    delay 5
    ///    set wheel sensitivity medium
    ///    delay 5
    ///    set wheel sensitivity high
    ///    delay 5
    ///    set wheel sensitivity custom
    ///    delay 5
    ///    set wheel sensitivity medium
    ///end tell
    ///```
    
    override func performDefaultImplementation() -> Any? {

        guard let args = self.evaluatedArguments else { return nil }
        
        log(tag:"Scripting: setWheelSensitivity", "Received args: \(args)")
        
        guard let enumValue = args[""] as? Int64 else { return nil }
        
        if let code = getValueCode(enumValue) {
            log(tag:"Scripting: setWheelSensitivity", "Enum code: \(getValueCodeString(value: args.values.first, code: code))")
            
            switch (code) {
                case "WSlo":
                    AppController.shared.setSensitivity(sensitivity: .low)
                case "WSmd":
                    AppController.shared.setSensitivity(sensitivity: .medium)
                case "WShi":
                    AppController.shared.setSensitivity(sensitivity: .high)
                case "WScu":
                    AppController.shared.setSensitivity(sensitivity: .custom)
                default:
                    return nil
            }
        }
        
        return nil
        
    }
}

@MainActor
class scriptable_setWheelDirection: NSScriptCommand {
    
    /// ## Applescript Usage
    ///```perl
    ///tell application "MacDial"
    ///    set wheel direction counterclockwise
    ///    delay 5
    ///    set wheel direction clockwise
    ///end tell
    ///```
    ///
    override func performDefaultImplementation() -> Any? {

        guard let args = self.evaluatedArguments else { return nil }
        
        log(tag:"Scripting: setWheelDirection", "Received args: \(args)")
        
        guard let enumValue = args[""] as? Int64 else { return nil }
        
        if let code = getValueCode(enumValue) {
            log(tag:"Scripting: setWheelDirection", "Enum code: \(getValueCodeString(value: args.values.first, code: code))")
            
            switch (code) {
                case "WDcl":
                    AppController.shared.setDirection(direction: .clockwise)
                case "WDco":
                    AppController.shared.setDirection(direction: .counterclockwise)
                default:
                    return nil
            }
        }
        
        return nil
        
    }
}

@MainActor
class scriptable_setStatusIcon: NSScriptCommand {
    
    /// ## Applescript Usage
    ///```perl
    ///tell application "MacDial"
    ///    set status icon rotation mode
    ///    delay 2
    ///    set status icon button mode
    ///    delay 2
    ///    set status icon default
    ///end tell
    ///```
    
    override func performDefaultImplementation() -> Any? {

        guard let args = self.evaluatedArguments else { return nil }
        
        log(tag:"Scripting: setStatusIcon", "Received args: \(args)")
        
        guard let enumValue = args[""] as? Int64 else { return nil }
        
        if let code = getValueCode(enumValue) {
            log(tag:"Scripting: setStatusIcon", "Enum code: \(getValueCodeString(value: args.values.first, code: code))")
            
            switch (code) {
                case "SIde":
                    AppController.shared.setStatusIcon(icon: .default)
                case "SIrm":
                    AppController.shared.setStatusIcon(icon: .rotation)
                case "SIbm":
                    AppController.shared.setStatusIcon(icon: .button)
                default:
                    return nil
            }
        }
        
        return nil
        
    }
}

// MARK: - Integer argument commands

@MainActor
class scriptable_setCustomSensitivity: NSScriptCommand {
    
    /// ## Applescript Usage
    ///```perl
    ///tell application "MacDial"
    ///    set custom sensitivity 1000
    ///    delay 5
    ///    set custom sensitivity 500
    ///end tell
    ///```
    
    override func performDefaultImplementation() -> Any? {

        guard let args = self.evaluatedArguments else { return nil }
        
        log(tag:"Scripting: setCustomSensitivity", "Received args: \(args)")
        
        if let value = args[""] as? Int {
            AppController.shared.customSensitivity?.value = value
        }
        
        return nil
        
    }
}

// MARK: - Bool argument commands

@MainActor
class scriptable_setHaptics: NSScriptCommand {
    
    /// ## Applescript Usage
    ///```perl
    ///tell application "MacDial"
    ///    set haptics false
    ///    delay 5
    ///    set haptics true
    ///end tell
    ///```
    
    override func performDefaultImplementation() -> Any? {

        guard let args = self.evaluatedArguments else { return nil }
        
        log(tag:"Scripting: setHaptics", "Received args: \(args)")
        
        if let enabled = args[""] as? Bool {
            AppController.shared.setHaptics(enabled: enabled)
        }
        
        return nil
        
    }
}

@MainActor
class scriptable_setKeepDialAwake: NSScriptCommand {
    
    /// ## Applescript Usage
    ///```perl
    ///tell application "MacDial"
    ///    set keep dial awake false
    ///    delay 5
    ///    set keep dial awake true
    ///end tell
    ///```
    
    override func performDefaultImplementation() -> Any? {

        guard let args = self.evaluatedArguments else { return nil }
        
        log(tag:"Scripting: setKeepDialAwake", "Received args: \(args)")
        
        if let enabled = args[""] as? Bool {
            AppController.shared.setKeepDialAwake(enabled: enabled)
        }
        
        return nil
        
    }
}

@MainActor
class scriptable_setShowOsd: NSScriptCommand {
    
    /// ## Applescript Usage
    ///```perl
    ///tell application "MacDial"
    ///    set show osd false
    ///    delay 5
    ///    set show osd true
    ///end tell
    ///```
    
    override func performDefaultImplementation() -> Any? {

        guard let args = self.evaluatedArguments else { return nil }
        
        log(tag:"Scripting: setShowOsd", "Received args: \(args)")
        
        if let enabled = args[""] as? Bool {
            AppController.shared.setShowOSD(enabled: enabled)
        }
        
        return nil
        
    }
}

// MARK: - Multiple boolean argument commands
@MainActor
class scriptable_setKeyScrollModifiers: NSScriptCommand {
    
    /// ## Applescript Usage
    ///```perl
    ///tell application "MacDial"
    ///    set rotation mode scrolling
    ///
    ///    set key scroll modifiers with shift without command, option and control
    ///    delay 5
    ///    set key scroll modifiers with command without shift, option and control
    ///    delay 5
    ///    set key scroll modifiers with option without shift, command and control
    ///    delay 5
    ///    set key scroll modifiers with control without shift, command and option
    ///    delay 5
    ///    set key scroll modifiers without shift, command, option and control
    ///    delay 5
    ///    set key scroll modifiers with shift, command, option and control
    ///    delay 5
    ///    set key scroll modifiers without shift, command, option and control
    ///    delay 5
    ///
    ///    set rotation mode volume
    ///end tell
    ///```
    
    override func performDefaultImplementation() -> Any? {

        guard let args = self.evaluatedArguments else { return nil }
        
        log(tag:"Scripting: setKeyScrollModifiers", "Received args: \(args)")
        
        var modifiers: [String: Bool] = [:]
        
        // Iterate over AppleScript returned arguments
        for (key, value) in args {
            if let b = value as? Bool {
                modifiers[key] = b
            }
        }
        
        AppController.shared.setKeyScrollModifiers(
            shift: modifiers["shift"],
            command: modifiers["command"],
            option: modifiers["option"],
            control: modifiers["control"]
        )
        
        return [
            "shift": UserSettings.keyScrollModifiers.shift,
            "command": UserSettings.keyScrollModifiers.command,
            "option": UserSettings.keyScrollModifiers.option,
            "control": UserSettings.keyScrollModifiers.control
        ]
        
    }
}
