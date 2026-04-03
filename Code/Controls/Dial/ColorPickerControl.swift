//
//  ColorPickerControl
//  MacDial
//
//  Created by Daniel Costa
//
//  License: MIT
//

import AppKit
import AXSwift

fileprivate enum SliderAction {
    case increment, decrement
}

fileprivate let windowKeywords = [ "color", "colour", "couleur", "farbe", "colore", "kleur", "kolor", "färg", "farge", "farve", "цвет", "色", "カラ", "颜色", "رنگ", "لون", "צבע", "cor" ]

// Accessibility functions
private func getPickerWindow() -> UIElement? {
    if let application = NSWorkspace.shared.frontmostApplication {
        let uiApp = Application(application)!
        let appWindows = try! uiApp.windows()
        
        // Get color picker window
        return try! appWindows?.first(where: {
            let title: String? = try! $0.attribute(.title)
            if (title == nil) { return false }
            
            return try $0.subrole() == .floatingWindow
            && windowKeywords.contains(where: { title!.contains($0) })
        })
    }
    
    return nil
}

private func getChildren(uiElement: UIElement, role: Role) -> [UIElement] {
    if let axChildren: [AXUIElement] = try! uiElement.attribute(.children) {
        let children = axChildren.map({ UIElement($0) })
        
        return children.filter({ try! $0.role() == role })
    }
    
    return []
}

private func getSliders() -> [UIElement] {
    if let window = getPickerWindow() {
        try! window.setAttribute(.focused, value: true)
        
        let allSplitGroups = getChildren(uiElement: window, role: .splitGroup)
                                         
        if let splitGroup = allSplitGroups.first {
            return getChildren(uiElement: splitGroup, role: .slider)
        }
    }
    
    return []
}

class ColorPickerControl: DeviceControl {
    private var sliderCount: Int
    private var currentSlider: Int
    
    private func moveSlider(_ index: Int, action: SliderAction?, dial: Dial?) -> Bool {
        let sliders = getSliders()
        
        // Check if slider count has changed
        if self.sliderCount != sliders.count {
            self.windowSetup()
        }
        
        if sliders.count > index {
            
            let slider = sliders[index]
            
            // Highlight affected slider
            if let window = getPickerWindow() {
                try! window.setAttribute(.focused, value: true)
            }
            try! slider.setAttribute(.focused, value: true)
            
            // Adjust slider
            switch action {
                case .increment:
                    try! slider.performAction(.increment)
                case .decrement:
                    try! slider.performAction(.decrement)
                default:
                    return false
            }
            
            let updatedValue = try! (slider.attribute(.value) ?? 0.5 as NSNumber).floatValue
            if (updatedValue <= 0 || updatedValue >= 1) {
                dial?.isHittingBounds = true
            }
            
            return true
            
        }
        
        return false
    }
    
    private func windowSetup(sliderIndex: Int = 0) {
        self.sliderCount = getSliders().count
        self.currentSlider = self.sliderCount > 0 ? sliderIndex % self.sliderCount : 0
        
        // Mark slider as focused
        _ = moveSlider(self.currentSlider, action: .none, dial: .none)
    }
    
    init() {
        self.sliderCount = 0
        self.currentSlider = 0
        
        self.windowSetup()
    }
    
    func buttonPress(_ dial: Dial) {
        self.windowSetup(sliderIndex: currentSlider + 1)
        
        if sliderCount > 1 {
            dial.sendHaptic(pattern: .rumble)
        }
    }

    func buttonRelease(_ dial: Dial) {
    }

    func rotationChanged(_ dial: Dial, _ rotation: RotationState) -> Bool {
        var action: SliderAction?
                
        switch rotation {
            case .stationary:
                action = nil
            case .clockwise:
                action = .increment
            case .counterclockwise:
                action = .decrement
        }
        
        return moveSlider(currentSlider, action: action, dial: dial)
    }
}
