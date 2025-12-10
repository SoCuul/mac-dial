//
//  NSTextField+Extension
//  MacDial
//
//  Created by Daniel Costa
//
//  License: MIT
//

import AppKit

extension NSTextField {
    func adjustFontSizeToFit(maxFontSize: CGFloat = 24, minFontSize: CGFloat = 1) {
        guard let currentFont = self.font else { return }
        let text = self.stringValue
        let labelWidth = self.frame.width
        var fontSize = maxFontSize

        while fontSize > minFontSize {
            let font = NSFontManager.shared.convert(currentFont, toSize: fontSize)
            let attributes = [NSAttributedString.Key.font: font]
            let textWidth = (text as NSString).size(withAttributes: attributes).width

            if textWidth <= labelWidth {
                self.font = font
                break
            }
            fontSize -= 1
        }
    }
}
