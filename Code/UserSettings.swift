//
//  UserSettings
//  MacDial
//
//  Created by Alex Babaev
//
//  Based on Andreas Karlsson sources
//  https://github.com/andreasjhkarlsson/mac-dial
//
//  Based on Andreas Karlsson sources
//  https://github.com/andreasjhkarlsson/mac-dial
//
//  License: MIT
//

import Foundation
import AppIntents

extension SettingsValueKey {
    static let rotationMode: SettingsValueKey = "settings.rotationMode"
    static let keyScrollModifiers: SettingsValueKey = "settings.keyScrollModifiers"
    static let buttonMode: SettingsValueKey = "settings.buttonMode"
    static let multiMode: SettingsValueKey = "settings.multiMode"
    static let sensitivity: SettingsValueKey = "settings.sensitivity"
    static let customSensitivity: SettingsValueKey = "settings.customSensitivity"
    static let hapticFeedback: SettingsValueKey = "settings.isHapticFeedbackEnabled"
    static let keepDialAwake: SettingsValueKey = "settings.shouldKeepDialAwake"
    static let showOSD: SettingsValueKey = "settings.isShowOSDEnabled"
    static let wheelDirection: SettingsValueKey = "settings.wheelDirection"
    static let statusIcon: SettingsValueKey = "settings.statusIcon"
}

class UserSettings {
    // MARK: - Data structures
    enum WheelSensitivity: Int, AppEnum {
        case low    = 1
        case medium = 2
        case high   = 3
        case custom = 999
        
        // App Intents
        @available(macOS 13.0, *)
        static var typeDisplayRepresentation: TypeDisplayRepresentation = "scripting.enum.wheelSensitivity"
        
        @available(macOS 13.0, *)
        static var caseDisplayRepresentations: [UserSettings.WheelSensitivity: DisplayRepresentation] = [
            .low: .init(title: "menu.wheelSensitivity.low", image: .init(systemName: "dial.low.fill")),
            .medium: .init(title: "menu.wheelSensitivity.medium", image: .init(systemName: "dial.medium.fill")),
            .high: .init(title: "menu.wheelSensitivity.high", image: .init(systemName: "dial.high.fill")),
            .custom: .init(title: "menu.wheelSensitivity.custom", image: .init(systemName: "slider.horizontal.3")),
        ]
    }
    
    enum WheelDirection: Int, AppEnum {
        case clockwise        = 0
        case counterclockwise = 1
        
        // App Intents
        @available(macOS 13.0, *)
        static var typeDisplayRepresentation: TypeDisplayRepresentation = "scripting.enum.wheelDirection"
        
        @available(macOS 13.0, *)
        static var caseDisplayRepresentations: [UserSettings.WheelDirection: DisplayRepresentation] = [
            .clockwise: .init(title: "menu.wheelDirection.cw", image: .init(systemName: "digitalcrown.horizontal.arrow.clockwise.fill")),
            .counterclockwise: .init(title: "menu.wheelDirection.ccw", image: .init(systemName: "digitalcrown.horizontal.arrow.counterclockwise.fill")),
        ]
    }

    enum RotationOperationMode: Int, AppEnum {
        case none             = 0
        case scrolling        = 1
        case volume           = 2
        case brightness       = 3
        case keyboard         = 4
        case leftRight        = 5
        case upDown           = 6
        case brushSize        = 7
        case plusMinus        = 8
        case appleMusicVolume = 100
        case spotifyVolume    = 101
        case vlcVolume        = 102
        
        // App Intents
        @available(macOS 13.0, *)
        static var typeDisplayRepresentation: TypeDisplayRepresentation = "scripting.enum.rotationMode"

        @available(macOS 13.0, *)
        static var caseDisplayRepresentations: [UserSettings.RotationOperationMode: DisplayRepresentation] = [
            .none: .init(title: "menu.rotationMode.none"),
            .scrolling: .init(title: "menu.rotationMode.scroll",                  image: .init(named: "menuicon-scroll", isTemplate: true)),
            .volume: .init(title: "menu.rotationMode.volume",                     image: .init(named: "menuicon-volume", isTemplate: true)),
            .brightness: .init(title: "menu.rotationMode.brightness",             image: .init(named: "menuicon-brightness", isTemplate: true)),
            .keyboard: .init(title: "menu.rotationMode.keyboard",                 image: .init(named: "menuicon-keyboard", isTemplate: true)),
            .leftRight: .init(title: "menu.rotationMode.leftRight",               image: .init(named: "menuicon-leftright", isTemplate: true)),
            .upDown: .init(title: "menu.rotationMode.upDown",                     image: .init(named: "menuicon-updown", isTemplate: true)),
            .brushSize: .init(title: "menu.rotationMode.brushSize",               image: .init(named: "menuicon-brushsize", isTemplate: true)),
            .plusMinus: .init(title: "menu.rotationMode.plusMinus",               image: .init(named: "menuicon-plusminus", isTemplate: true)),
            .appleMusicVolume: .init(title: "menu.rotationMode.appleMusicVolume", image: .init(named: "menuicon-applemusic", isTemplate: true)),
            .spotifyVolume: .init(title: "menu.rotationMode.spotifyVolume",       image: .init(named: "menuicon-spotify", isTemplate: true)),
            .vlcVolume: .init(title: "menu.rotationMode.vlcVolume",               image: .init(named: "menuicon-vlc", isTemplate: true)),
        ]
    }

    enum ButtonOperationMode: Int, AppEnum {
        case none      = 0
        case leftClick = 1
        case playback  = 2
        case mute      = 3
        
        // App Intents
        @available(macOS 13.0, *)
        static var typeDisplayRepresentation: TypeDisplayRepresentation = "scripting.enum.buttonMode"

        @available(macOS 13.0, *)
        static var caseDisplayRepresentations: [UserSettings.ButtonOperationMode: DisplayRepresentation] = [
            .none: .init(title: "menu.buttonMode.none"),
            .leftClick: .init(title: "menu.buttonMode.leftClick", image: .init(named: "menuicon-leftclick", isTemplate: true)),
            .playback: .init(title: "menu.buttonMode.playback", image: .init(named: "menuicon-playback", isTemplate: true)),
            .mute: .init(title: "menu.buttonMode.mute", image: .init(named: "menuicon-mute", isTemplate: true)),
        ]
    }
    
    enum MultiOperationMode: Int, AppEnum {
        case none      = 0
        case colorPicker = 1
        
        // App Intents
        @available(macOS 13.0, *)
        static var typeDisplayRepresentation: TypeDisplayRepresentation = "scripting.enum.multiMode"

        @available(macOS 13.0, *)
        static var caseDisplayRepresentations: [UserSettings.MultiOperationMode: DisplayRepresentation] = [
            .none: .init(title: "menu.multiMode.none"),
            .colorPicker: .init( title: "menu.multiMode.colorPicker", image: .init(named: "menuicon-colorpicker", isTemplate: true)),
        ]
    }
    
    enum StatusIconMode: Int, AppEnum {
        case `default` = 0
        case rotation  = 1
        case button    = 2
        case multi     = 3
        
        // App Intents
        @available(macOS 13.0, *)
        static var typeDisplayRepresentation: TypeDisplayRepresentation = "scripting.enum.multiMode"

        @available(macOS 13.0, *)
        static var caseDisplayRepresentations: [UserSettings.StatusIconMode: DisplayRepresentation] = [
            .default: .init(title: "menu.statusIcon.default"),
            .rotation: .init(title: "menu.statusIcon.rotation"),
            .button: .init(title: "menu.statusIcon.button"),
            .multi: .init(title: "menu.statusIcon.multi"),
        ]
    }
    
    private typealias KeyScrollModifiersDict = [String: Bool]
    
    // MARK: - Default/fallback values
    private static let defaultkeyScrollModifiers: KeyScrollModifiersDict = [
        "shift":   false,
        "command": false,
        "option":  false,
        "control": false
    ]
    
    // MARK: - Private user defaults
    
    @FromUserDefaults(key: .rotationMode, defaultValue: RotationOperationMode.volume.rawValue)
    static private var rotationModeSetting: Int

    @FromUserDefaults(key: .buttonMode, defaultValue: ButtonOperationMode.playback.rawValue)
    static private var buttonModeSetting: Int
    
    @FromUserDefaults(key: .multiMode, defaultValue: MultiOperationMode.none.rawValue)
    static private var multiModeSetting: Int

    @FromUserDefaults(key: .sensitivity, defaultValue: WheelSensitivity.medium.rawValue)
    static private var sensitivitySetting: Int
    
    @FromUserDefaults(key: .customSensitivity, defaultValue: 500)
    static private var customSensitivitySetting: Int

    @FromUserDefaults(key: .hapticFeedback, defaultValue: true)
    static private var isHapticFeedbackEnabledSetting: Bool
    
    @FromUserDefaults(key: .showOSD, defaultValue: true)
    static private var isShowOSDEnabledSetting: Bool
    
    @FromUserDefaults(key: .keepDialAwake, defaultValue: true)
    static private var shouldKeepDialAwakeSetting: Bool

    @FromUserDefaults(key: .wheelDirection, defaultValue: WheelDirection.clockwise.rawValue)
    static private var wheelDirectionSetting: Int
    
    @FromUserDefaults(key: .statusIcon, defaultValue: StatusIconMode.default.rawValue)
    static private var statusIconSetting: Int
    
    @FromUserDefaults(key: .keyScrollModifiers, defaultValue: defaultkeyScrollModifiers)
    static private var keyScrollModifiersSetting: KeyScrollModifiersDict
    
    
    // MARK: - Public computed variables

    static var rotationMode: RotationOperationMode {
        get { RotationOperationMode(rawValue: UserSettings.rotationModeSetting) ?? .volume }
        set { UserSettings.rotationModeSetting = newValue.rawValue }
    }

    static var buttonMode: ButtonOperationMode {
        get { ButtonOperationMode(rawValue: UserSettings.buttonModeSetting) ?? .playback }
        set { UserSettings.buttonModeSetting = newValue.rawValue }
    }
    
    static var multiMode: MultiOperationMode {
        get { MultiOperationMode(rawValue: UserSettings.multiModeSetting) ?? .none }
        set { UserSettings.multiModeSetting = newValue.rawValue }
    }
    
    static var sensitivity: WheelSensitivity {
        get { WheelSensitivity(rawValue: UserSettings.sensitivitySetting) ?? .medium }
        set { UserSettings.sensitivitySetting = newValue.rawValue }
    }
    
    static var wheelDirection: WheelDirection {
        get {
            UserSettings.WheelDirection(rawValue: UserSettings.wheelDirectionSetting) ?? .clockwise
        }
        set { UserSettings.wheelDirectionSetting = newValue.rawValue }
    }
    
    static var statusIcon: StatusIconMode {
        get { UserSettings.StatusIconMode(rawValue: UserSettings.statusIconSetting) ?? .default }
        set { UserSettings.statusIconSetting = newValue.rawValue }
    }
    
    static var customSensitivity: Int {
        get { UserSettings.customSensitivitySetting }
        set {
            switch newValue {
                case ..<1:
                    UserSettings.customSensitivitySetting = 1
                case 1...1000:
                    UserSettings.customSensitivitySetting = newValue
                case 1001...:
                    UserSettings.customSensitivitySetting = 1000
                default:
                    break
            }
        }
    }

    static var hapticsEnabled: Bool {
        get { UserSettings.isHapticFeedbackEnabledSetting }
        set { UserSettings.isHapticFeedbackEnabledSetting = newValue }
    }
    
    static var keepDialAwake: Bool {
        get { UserSettings.shouldKeepDialAwakeSetting }
        set { UserSettings.shouldKeepDialAwakeSetting = newValue }
    }
    
    static var showOSD: Bool {
        get { UserSettings.isShowOSDEnabledSetting }
        set { UserSettings.isShowOSDEnabledSetting = newValue }
    }
    
    enum keyScrollModifiers {
        static var shift: Bool {
            get {
                keyScrollModifiersSetting["shift"] ?? false
            }
            set {
                keyScrollModifiersSetting["shift"] = newValue
            }
        }
        
        static var command: Bool {
            get {
                keyScrollModifiersSetting["command"] ?? false
            }
            set {
                keyScrollModifiersSetting["command"] = newValue
            }
        }
        
        static var option: Bool {
            get {
                keyScrollModifiersSetting["option"] ?? false
            }
            set {
                keyScrollModifiersSetting["option"] = newValue
            }
        }
        
        static var control: Bool {
            get {
                keyScrollModifiersSetting["control"] ?? false
            }
            set {
                keyScrollModifiersSetting["control"] = newValue
            }
        }
    }
}

typealias WheelSensitivity = UserSettings.WheelSensitivity
typealias WheelDirection = UserSettings.WheelDirection

struct SettingsValueKey: ExpressibleByStringLiteral {
    var name: String

    init(stringLiteral value: StringLiteralType) {
        name = value
    }
}

@propertyWrapper
struct FromUserDefaults<Value> {
    private let key: String
    private let defaultValue: Value
    private let userDefaults: UserDefaults

    init(key: SettingsValueKey, userDefaults: UserDefaults = UserDefaults.standard, defaultValue: Value) {
        self.key = key.name
        self.defaultValue = defaultValue
        self.userDefaults = userDefaults
    }

    var wrappedValue: Value {
        get {
            userDefaults.object(forKey: key) as? Value ?? defaultValue
        }
        set {
            userDefaults.set(newValue, forKey: key)
        }
    }
}


// MARK: App Intents

//@available(macOS 13, *)
//extension UserSettings.WheelSensitivity: AppEnum {
//    static var typeDisplayRepresentation: TypeDisplayRepresentation = TypeDisplayRepresentation(name: .menuWheelSensitivity)
//
//    static var caseDisplayRepresentations: [UserSettings.WheelSensitivity: DisplayRepresentation] = [
//        .low: DisplayRepresentation(title: .menuWheelSensitivityLow),
//        .medium: DisplayRepresentation(title: .menuWheelSensitivityMedium),
//        .high: DisplayRepresentation(title: .menuWheelSensitivityHigh),
//        .custom: DisplayRepresentation(title: .menuWheelSensitivityCustom),
//    ]
//}
//
//@available(macOS 13, *)
//extension UserSettings.WheelDirection: AppEnum {
//    static var typeDisplayRepresentation: TypeDisplayRepresentation = TypeDisplayRepresentation(name: .menuWheelDirection)
//
//    static var caseDisplayRepresentations: [UserSettings.WheelDirection: DisplayRepresentation] = [
//        .clockwise: DisplayRepresentation(title: .menuWheelDirectionCw),
//        .counterclockwise: DisplayRepresentation(title: .menuWheelDirectionCcw),
//    ]
//}
//
//
//@available(macOS 13, *)
//extension UserSettings.RotationOperationMode: AppEnum {
//    
//}
//
//@available(macOS 13, *)
//extension UserSettings.ButtonOperationMode: AppEnum {
//    static var typeDisplayRepresentation: TypeDisplayRepresentation = "Button Mode"
//
//    static var caseDisplayRepresentations: [UserSettings.ButtonOperationMode: DisplayRepresentation] = [
//        .none: DisplayRepresentation(title: .menuButtonModeNone),
//        .leftClick: DisplayRepresentation(title: .menuButtonModeLeftClick, image: .init(named: "menuicon-leftclick")),
//        .playback: DisplayRepresentation(title: .menuButtonModePlayback,   image: .init(named: "menuicon-playback")),
//        .mute: DisplayRepresentation(title: .menuButtonModeMute,           image: .init(named: "menuicon-mute")),
//    ]
//}
//
//@available(macOS 13, *)
//extension UserSettings.MultiOperationMode: AppEnum {
//    static var typeDisplayRepresentation: TypeDisplayRepresentation = "Multi Mode"
//
//    static var caseDisplayRepresentations: [UserSettings.MultiOperationMode: DisplayRepresentation] = [
//        .none: DisplayRepresentation(title: .menuMultiModeNone),
//        .colorPicker: DisplayRepresentation(title: .menuMultiModeColorPicker, image: .init(named: "menuicon-colorpicker")),
//    ]
//}
//
//@available(macOS 13, *)
//extension UserSettings.StatusIconMode: AppEnum {
//    static var typeDisplayRepresentation: TypeDisplayRepresentation = TypeDisplayRepresentation(name: .menuStatusIcon)
//
//    static var caseDisplayRepresentations: [UserSettings.StatusIconMode: DisplayRepresentation] = [
//        .default: DisplayRepresentation(title: .menuStatusIconDefault),
//        .rotation: DisplayRepresentation(title: .menuStatusIconRotation),
//        .button: DisplayRepresentation(title: .menuStatusIconButton),
//        .multi: DisplayRepresentation(title: .menuStatusIconMulti),
//    ]
//}
//
