//
//  LaunchAtLogin
//  MacDial
//
//  Created by Daniel Costa
//
//  Original source: https://github.com/sindresorhus/LaunchAtLogin-Modern/blob/main/Sources/LaunchAtLogin/LaunchAtLogin.swift
//
//  License: MIT
//

import Foundation
import ServiceManagement

public class LaunchAtLogin: NSObject {
    /**
    Check whether setting launch at login is available for the current macOS version.
    */
    @objc dynamic public var isAvailable: Bool {
        get {
            if #available(macOS 13.0, *) {
                return true
            } else {
                return false
            }
        }
    }
    
    /**
    Toggle “launch at login” for your app or check whether it's enabled.
    */
    public static var isEnabled: Bool {
        get {
            if #available(macOS 13.0, *) {
                return SMAppService.mainApp.status == .enabled
            }
            else {
                return false
            }
        }
        set {
            if #available(macOS 13.0, *) {
                do {
                    if newValue {
                        if SMAppService.mainApp.status == .enabled {
                            try? SMAppService.mainApp.unregister()
                        }
                        
                        try SMAppService.mainApp.register()
                    } else {
                        try SMAppService.mainApp.unregister()
                    }
                } catch {
                    print("Failed to \(newValue ? "enable" : "disable") launch at login: \(error.localizedDescription)")
                }
            }
        }
    }

    /**
    Whether the app was launched at login.

    - Important: This property must only be checked in `NSApplicationDelegate#applicationDidFinishLaunching`.
    */
    public static var wasLaunchedAtLogin: Bool {
        let event = NSAppleEventManager.shared().currentAppleEvent
        return event?.eventID == kAEOpenApplication
            && event?.paramDescriptor(forKeyword: keyAEPropData)?.enumCodeValue == keyAELaunchedAsLogInItem
    }
}
