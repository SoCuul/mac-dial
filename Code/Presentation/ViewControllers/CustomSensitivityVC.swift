//
//  CustomSensitivityViewController
//  MacDial
//
//  Created by Daniel Costa
//
//  License: MIT
//

import Cocoa

@MainActor
class CustomSensitivityVC: NSViewController {
    @IBOutlet var displayText: NSTextField!
    
    @objc dynamic public var value: Int {
        get {
            updateDisplayText()
            
            return UserSettings.customSensitivity
        }
        set {
            willChangeValue(forKey: "value")
            
            UserSettings.customSensitivity = newValue
            
            displayText.stringValue = String(
                format: NSLocalizedString("customSensitivity.display", comment: ""),
                UserSettings.customSensitivity
            )
            
            didChangeValue(forKey: "value")
            
        }
    }
    
    private func updateDisplayText() {
        displayText.stringValue = String(
            format: NSLocalizedString("customSensitivity.display", comment: ""),
            UserSettings.customSensitivity
        )
    }
    
    private func enableCustomSensitivity() {
        AppController.shared.setSensitivity(sensitivity: .custom)
    }
    
    // MARK: - @IBAction
    
    @IBAction func didMoveSlider(_ sender: NSSlider) {
        enableCustomSensitivity()
    }
    
    @IBAction func minusOne(_ sender: NSButton) {
        value -= 1
        
        enableCustomSensitivity()
    }
    @IBAction func minusTen(_ sender: NSButton) {
        value -= 10
        
        enableCustomSensitivity()
    }
    
    @IBAction func plusOne(_ sender: NSButton) {
        value += 1
        
        enableCustomSensitivity()
    }
    @IBAction func plusTen(_ sender: NSButton) {
        value += 10
        
        enableCustomSensitivity()
    }
}
