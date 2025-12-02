//
//  Brightness
//  MacDial
//
//  Created by Daniel Costa
//
//  License: MIT
//

private let kbc = KeyboardBrightnessClient()

public enum Brightness {
    
    /// The brightness of the primary display
    public static var display: Float {
        get {
            var brightness: Float = 0.0
            DisplayServicesGetBrightness(CGMainDisplayID(), &brightness)
            
            return brightness
        }
        set {
            DisplayServicesSetBrightness(CGMainDisplayID(), newValue)
        }
    }
    
    /// The brightness of the keyboard backlight
    public static var keyboardBacklight: Float {
        get {
            return kbc.brightness(forKeyboard: 1)
        }
        set {
            kbc.setBrightness(newValue, forKeyboard: 1)
        }
    }
    
}
