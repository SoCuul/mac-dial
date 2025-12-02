//
//  NSMenuItem+Extension
//  MacDial
//
//  Created by Daniel Costa
//
//  License: MIT
//

import AppKit

extension NSMenuItem {
    /// Set (and get) the visibility of a menu item.  Hidden menu items (or items with a hidden superitem) do not appear in a menu and do not participate in command key matching.
    var visible: Bool {
        get {
            !self.isHidden
        }
        set {
            self.isHidden = !newValue
        }
    }
    
    /// The state of the menu item, returned as a Bool \
    /// \
    /// A value of `.on` or `.mixed` will return `true` \
    /// A value of `.off` will return `false`
    var stateBool: Bool {
        get {
            self.state == .off ? false : true
        }
        set {
            self.state = newValue ? .on : .off
        }
    }
}
