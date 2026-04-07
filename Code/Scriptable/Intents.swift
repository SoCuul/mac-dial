//
//  Intents
//  MacDial
//
//  Created by Daniel Costa
//
//  License: MIT
//

import Foundation
import AppIntents

// MARK: - Enum argument actions

@available(macOS 13, *)
struct SetRotationModeIntent: AppIntent {
    static let title: LocalizedStringResource = "scripting.setRotationMode"
    static let description: IntentDescription = "scripting.setRotationMode.description"
    
    @Parameter(title: "scripting.setRotationMode.arg")
    var rotationMode: UserSettings.RotationOperationMode
    
    static var parameterSummary: some ParameterSummary {
        Summary("Set Rotation Mode to \(\.$rotationMode)")
    }

    @MainActor
    func perform() async throws -> some IntentResult {
        AppController.shared.setRotationMode(mode: rotationMode)
        
        return .result()
    }
}

@available(macOS 13, *)
struct SetButtonModeIntent: AppIntent {
    static let title: LocalizedStringResource = "scripting.setButtonMode"
    static let description: IntentDescription = "scripting.setButtonMode.description"
    
    @Parameter(title: "scripting.setButtonMode.arg")
    var buttonMode: UserSettings.ButtonOperationMode
    
    static var parameterSummary: some ParameterSummary {
        Summary("Set Button Mode to \(\.$buttonMode)")
    }

    @MainActor
    func perform() async throws -> some IntentResult {
        AppController.shared.setButtonMode(mode: buttonMode)
        
        return .result()
    }
}

@available(macOS 13, *)
struct SetMultiModeIntent: AppIntent {
    static let title: LocalizedStringResource = "scripting.setMultiMode"
    static let description: IntentDescription = "scripting.setMultiMode.description"
    
    @Parameter(title: "scripting.setMultiMode.arg")
    var multiMode: UserSettings.MultiOperationMode
    
    static var parameterSummary: some ParameterSummary {
        Summary("Set Multi Mode to \(\.$multiMode)")
    }

    @MainActor
    func perform() async throws -> some IntentResult {
        AppController.shared.setMultiMode(mode: multiMode)
        
        return .result()
    }
}

@available(macOS 13, *)
struct SetWheelSensitivityIntent: AppIntent {
    static let title: LocalizedStringResource = "scripting.setWheelSensitivity"
    static let description: IntentDescription = "scripting.setWheelSensitivity.description"
    
    @Parameter(title: "scripting.setWheelSensitivity.arg")
    var wheelSensitivity: UserSettings.WheelSensitivity
    
    static var parameterSummary: some ParameterSummary {
        Summary("Set Wheel Sensitivity to \(\.$wheelSensitivity)")
    }

    @MainActor
    func perform() async throws -> some IntentResult {
        AppController.shared.setSensitivity(sensitivity: wheelSensitivity)
        
        return .result()
    }
}

@available(macOS 13, *)
struct SetWheelDirectionIntent: AppIntent {
    static let title: LocalizedStringResource = "scripting.setWheelDirection"
    static let description: IntentDescription = "scripting.setWheelDirection.description"
    
    @Parameter(title: "scripting.setWheelDirection.arg")
    var wheelDirection: UserSettings.WheelDirection
    
    static var parameterSummary: some ParameterSummary {
        Summary("Set Wheel Direction to \(\.$wheelDirection)")
    }

    @MainActor
    func perform() async throws -> some IntentResult {
        AppController.shared.setDirection(direction: wheelDirection)
        
        return .result()
    }
}

@available(macOS 13, *)
struct SetStatusIconIntent: AppIntent {
    static let title: LocalizedStringResource = "scripting.setStatusIcon"
    static let description: IntentDescription = "scripting.setStatusIcon.description"
    
    @Parameter(title: "scripting.setStatusIcon.arg")
    var statusIcon: UserSettings.StatusIconMode
    
    static var parameterSummary: some ParameterSummary {
        Summary("Set Status Icon to \(\.$statusIcon)")
    }

    @MainActor
    func perform() async throws -> some IntentResult {
        AppController.shared.setStatusIcon(icon: statusIcon)
        
        return .result()
    }
}

// MARK: - Integer argument actions

@available(macOS 13, *)
struct SetCustomSensitivityIntent: AppIntent {
    static let title: LocalizedStringResource = "scripting.setCustomSensitivity"
    static let description: IntentDescription = "scripting.setCustomSensitivity.description"
    
    @Parameter(title: "scripting.setCustomSensitivity.arg")
    var customSensitivity: Int
    
    static var parameterSummary: some ParameterSummary {
        Summary("Set Custom Sensitivity to \(\.$customSensitivity)")
    }

    @MainActor
    func perform() async throws -> some IntentResult {
        AppController.shared.setCustomSensitivity(value: customSensitivity)
        
        return .result()
    }
}

// MARK: - Bool argument commands

@available(macOS 13, *)
struct SetHapticsIntent: AppIntent {
    static let title: LocalizedStringResource = "scripting.setHaptics"
    static let description: IntentDescription = "scripting.setHaptics.description"
    
    @Parameter(title: "scripting.enabled")
    var value: Bool
    
    static var parameterSummary: some ParameterSummary {
        Summary("Set Haptics \(\.$value)")
    }

    @MainActor
    func perform() async throws -> some IntentResult {
        AppController.shared.setHaptics(enabled: value)
        
        return .result()
    }
}

@available(macOS 13, *)
struct SetKeepDialAwakeIntent: AppIntent {
    static let title: LocalizedStringResource = "scripting.setKeepDialAwake"
    static let description: IntentDescription = "scripting.setKeepDialAwake.description"
    
    @Parameter(title: "scripting.enabled")
    var value: Bool
    
    static var parameterSummary: some ParameterSummary {
        Summary("Set Keep Dial Awake \(\.$value)")
    }

    @MainActor
    func perform() async throws -> some IntentResult {
        AppController.shared.setKeepDialAwake(enabled: value)
        
        return .result()
    }
}

@available(macOS 13, *)
struct SetShowOsdIntent: AppIntent {
    static let title: LocalizedStringResource = "scripting.setShowOsd"
    static let description: IntentDescription = "scripting.setShowOsd.description"
    
    @Parameter(title: "scripting.enabled")
    var value: Bool
    
    static var parameterSummary: some ParameterSummary {
        Summary("Set Show OSD \(\.$value)")
    }

    @MainActor
    func perform() async throws -> some IntentResult {
        AppController.shared.setShowOSD(enabled: value)
        
        return .result()
    }
}

// MARK: - Bool argument commands

@available(macOS 13, *)
struct SetKeyScrollModifiersIntent: AppIntent {
    static let title: LocalizedStringResource = "scripting.setKeyScrollModifiers"
    static let description: IntentDescription = "scripting.setKeyScrollModifiers.description"
    
    @Parameter(title: "scripting.setKeyScrollModifiers.argShift")
    var shift: Bool
    
    @Parameter(title: "scripting.setKeyScrollModifiers.argCommand")
    var command: Bool
    
    @Parameter(title: "scripting.setKeyScrollModifiers.argOption")
    var option: Bool
    
    @Parameter(title: "scripting.setKeyScrollModifiers.argControl")
    var control: Bool

    @MainActor
    func perform() async throws -> some IntentResult {
        AppController.shared.setKeyScrollModifiers(shift: shift, command: command, option: option, control: control)
        
        return .result()
    }
}
