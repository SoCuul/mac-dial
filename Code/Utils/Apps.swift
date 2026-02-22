//
//  Apps
//  MacDial
//
//  Created by Daniel Costa
//
//  License: MIT
//

import Foundation

public protocol ControllableAppInstance {
    static var name: String { get }
    static var type: ControllableAppVolume { get }
}

// MARK: - Volume Control

public protocol ControllableAppVolumeInstance: ControllableAppInstance {
    static var minVolume: Int { get }
    static var maxVolume: Int { get }
    
    static var soundVolume: Int { get set }
}

public enum ControllableAppVolume {
    case spotify
    case applemusic
    case vlc
    
    var instance: any ControllableAppVolumeInstance.Type {
        switch self {
            case .spotify: return SpotifyVolume.self
            case .applemusic: return AppleMusicVolume.self
            case .vlc: return VLCVolume.self
        }
    }
}

private struct AppleMusicVolume: ControllableAppVolumeInstance {
    static let name = "Apple Music"
    static let type = ControllableAppVolume.applemusic
    
    static let minVolume = 0
    static let maxVolume = 100
    
    static var soundVolume: Int {
        get {
            let value = ExecuteAppleScript(
                "tell application \"\(name)\" to get sound volume"
            )?.stringValue
            
            return Int(value ?? "0") ?? 0
        }
        set {
            _ = ExecuteAppleScript("tell application \"\(name)\" to set sound volume to \(newValue)")
        }
    }
}

private struct SpotifyVolume: ControllableAppVolumeInstance {
    static let name = "Spotify"
    static let type = ControllableAppVolume.spotify
    
    static let minVolume = 0
    static let maxVolume = 100
    
    static var soundVolume: Int {
        get {
            let value = ExecuteAppleScript(
                "tell application \"\(name)\" to get sound volume"
            )?.stringValue
            
            return Int(value ?? "0") ?? 0
        }
        set {
            _ = ExecuteAppleScript("tell application \"\(name)\" to set sound volume to \(newValue)")
        }
    }
}

private struct VLCVolume: ControllableAppVolumeInstance {
    static let name = "VLC"
    static let type = ControllableAppVolume.vlc
    
    static let minVolume = 0
    static let maxVolume = 320
    
    static var soundVolume: Int {
        get {
            let value = ExecuteAppleScript(
                "tell application \"\(name)\" to get audio volume"
            )?.stringValue
            
            return Int(value ?? "0") ?? 0
        }
        set {
            _ = ExecuteAppleScript("tell application \"\(name)\" to set audio volume to \(newValue)")
        }
    }
}

