//
//  NSButton+Extension
//  MacDial
//
//  Created by Daniel Costa
//
//  License: MIT
//

import AppKit

extension NSButton {
    func resizeToFitText(padding: CGFloat = 40) {
        guard let font = self.font else { return }

        // Measure text width accurately
        let attributes: [NSAttributedString.Key: Any] = [.font: font]
        let textSize = (self.title as NSString).size(withAttributes: attributes)

        let newWidth = ceil(textSize.width) + padding
        let delta = newWidth - self.frame.width

        self.frame = NSRect(
            x: self.frame.origin.x - delta / 2, // keep center
            y: self.frame.origin.y,
            width: newWidth,
            height: self.frame.height // keep original height
        )
    }
}
