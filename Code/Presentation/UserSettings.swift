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

extension SettingsValueKey {
    static let rotationMode: SettingsValueKey = "settings.rotationMode"
    static let keyScrollModifiers: SettingsValueKey = "settings.keyScrollModifiers"
    static let buttonMode: SettingsValueKey = "settings.buttonMode"
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
    enum WheelSensitivity: Int {
        case low    = 1
        case medium = 2
        case high   = 3
        case custom = 999
    }
    
    enum WheelDirection: Int {
        case clockwise        = 0
        case counterclockwise = 1
    }

    enum RotationOperationMode: Int {
        case none       = 0
        case scrolling  = 1
        case volume     = 2
        case brightness = 3
        case keyboard   = 4
        case leftRight  = 5
        case upDown     = 6
    }

    enum ButtonOperationMode: Int {
        case none      = 0
        case leftClick = 1
        case playback  = 2
        case mute      = 3
    }
    
    enum StatusIconMode: Int {
        case `default` = 0
        case rotation  = 1
        case button    = 2
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
