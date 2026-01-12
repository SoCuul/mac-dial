//
//  Misc
//  MacDial
//
//  Created by Daniel Costa
//
//  License: MIT
//

import Foundation

func ExecuteAppleScript(_ source: String) -> NSAppleEventDescriptor? {
    if let script = NSAppleScript(source: source) {
        var error: NSDictionary?
        
        let output = script.executeAndReturnError(&error)
        
        if let error = error {
            print("AppleScript Error: \(error)")
        }
        
        return output
    }
    
    return nil
}
