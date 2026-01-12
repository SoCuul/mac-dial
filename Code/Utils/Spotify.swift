//
//  Spotify
//  MacDial
//
//  Created by Daniel Costa
//
//  License: MIT
//

import Foundation

public enum Spotify {
    
    public static var soundVolume: Int {
        get {
            let value = ExecuteAppleScript(
                "tell application \"Spotify\" to get sound volume"
            )?.int32Value ?? 0

            return Int(value)
        }
        set {
            _ = ExecuteAppleScript("tell application \"Spotify\" to set sound volume to \(newValue)")
        }
    }
    
}
