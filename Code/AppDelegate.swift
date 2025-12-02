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
func log(tag: String, _ message: @autoclosure () -> String) {
    guard debugLogging else { return }

    print("\(Date()) [\(tag)] \(message())")
}
#else
func log(tag: String, _ message: @autoclosure () -> String) {
}
#endif

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    @IBOutlet private var controller: AppController!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        AppController.shared = controller
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        controller.terminate()
    }
}
