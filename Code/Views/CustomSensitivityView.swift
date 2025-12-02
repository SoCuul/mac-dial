//
//  CustomSensitivityViewController
//  MacDial
//
//  Created by Daniel Costa
//
//  License: MIT
//

import Cocoa

protocol CustomSensitivityDelegate {
    func customSensitivityValueDidChange()
}

@MainActor
class CustomSensitivityView: NSViewController {
    @objc dynamic private var _value: Int = 0
    
    @objc dynamic public var value: Int {
        get {
            return _value
        }
        set {
            switch newValue {
                case ..<0:
                    _value = 0
                case 0...100:
                    _value = newValue
                case 101...:
                    _value = 100
                default:
                    break
            }
            
        }
    }
    
    
    // MARK: - @IBAction
    
    @IBAction func minusOne(_ sender: NSButton) {
        value -= 1
    }
    @IBAction func minusTen(_ sender: NSButton) {
        value -= 10
    }
    
    @IBAction func plusOne(_ sender: NSButton) {
        value += 1
    }
    @IBAction func plusTen(_ sender: NSButton) {
        value += 10
    }
}
