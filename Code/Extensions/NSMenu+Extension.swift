//
//  NSMenu+Extension
//  MacDial
//
//  Created by Daniel Costa
//
//  License: MIT
//

import AppKit

extension NSMenu {
    func allOnItems() -> [NSMenuItem] {
        var result: [NSMenuItem] = []

        for item in items {
            if item.state == .on {
                result.append(item)
            }

            if let submenu = item.submenu {
                result.append(contentsOf: submenu.allOnItems())
            }
        }

        return result
    }
}
