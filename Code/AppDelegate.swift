//
//  AppDelegate
//  MacDial
//
//  Created by Alex Babaev
//
//  Based on Andreas Karlsson sources
//  https://github.com/andreasjhkarlsson/mac-dial
//
//  License: MIT
//

import AppKit

private let debugLogging: Bool = true

#if DEBUG
let debugBuild = true

func log(tag: String, _ message: @autoclosure () -> String) {
    guard debugLogging else { return }

    print("\(Date()) [\(tag)] \(message())")
}
#else
let debugBuild = false

func log(tag: String, _ message: @autoclosure () -> String) {
}
#endif

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    @IBOutlet private var controller: AppController!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        AppController.shared = controller
        
        // Terminate other instances of app running
        let ownPID = ProcessInfo.processInfo.processIdentifier
        let runningApps = NSRunningApplication.runningApplications(withBundleIdentifier: Bundle.main.bundleIdentifier!)
        
        for app in runningApps {
            if app.processIdentifier != ownPID {
                app.terminate()
            }
        }
        
        // Request accessibility permissions
        controller.requestPermissions()
        
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        controller.terminate()
    }
}
