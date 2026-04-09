//
//  AceessibilityPopoverViewController
//  MacDial
//
//  Created by Daniel Costa
//
//  License: MIT
//

import AppKit

@MainActor
class AccessibilityPopoverVC: NSViewController {
    @IBOutlet private weak var headerTitle: NSTextField!
    @IBOutlet private weak var animationContainer: CAMLContainerView!
    @IBOutlet private weak var settingsButton: NSButton!
    
    private var rootLayer: CALayer?
    private var stateController: CAStateController?
    
    private var states: [CAState]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        headerTitle.stringValue = String(format: NSLocalizedString("accessibilityDialogPopover.header", comment: ""))
        headerTitle.adjustFontSizeToFit(maxFontSize: 20)
        
        settingsButton.title = String(format: NSLocalizedString("accessibilityDialogPopover.settingsButton", comment: ""))
        settingsButton.resizeToFitText()
        
        self.setupCAView()
    }
    
    @IBAction func buttonClicked(_ sender: NSButton) {
        if let url = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility") {
            NSWorkspace.shared.open(url)
        }
    }
    
    // MARK: Core Animation view
    private func setupCAView() {
        do {
            let asset = NSDataAsset(name: "Animations/AccessibilityRemove")
            
            let package = try CAPackage.package(
                with: asset?.data,
                type: kCAPackageTypeArchive,
                options: nil
            ) as? CAPackage
            
            rootLayer = package?.rootLayer
            rootLayer?.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            
            states = rootLayer?.value(forKey: "states") as? [CAState]
            stateController = CAStateController(layer: rootLayer)
            
            stateController?.setInitialStatesOfLayer(rootLayer, transitionSpeed: 0.0)
            
            animationContainer.layer?.addSublayer(rootLayer!)
            animationContainer.rootLayer = rootLayer
            
            runAnimation()
        }
        catch {
            print("Failed to load CA view: \(error)")
        }
    }
    
    private func runAnimation() {
        // State 1
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.stateController?.setState(self?.states?[0], ofLayer: self?.rootLayer, transitionSpeed: 1.0)
            
            // State 2
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.7) { [weak self] in
                self?.stateController?.setState(self?.states?[1], ofLayer: self?.rootLayer, transitionSpeed: 1.0)
                
                // State 3
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.7) { [weak self] in
                    self?.stateController?.setState(self?.states?[2], ofLayer: self?.rootLayer, transitionSpeed: 1.0)
                    
                    // State 4
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.85) { [weak self] in
                        self?.stateController?.setState(self?.states?[3], ofLayer: self?.rootLayer, transitionSpeed: 1.0)
                        
                        // Loop
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) { [weak self] in
                            self?.runAnimation()
                        }
                    }
                }
            }
        }
    }
}
