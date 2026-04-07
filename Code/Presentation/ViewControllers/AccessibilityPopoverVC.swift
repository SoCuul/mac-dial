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
    @IBOutlet var headerTitle: NSTextField!
    @IBOutlet var webViewContainer: NSView!
    @IBOutlet var settingsButton: NSButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        headerTitle.stringValue = String(format: NSLocalizedString("accessibilityDialogPopover.header", comment: ""))
        headerTitle.adjustFontSizeToFit(maxFontSize: 20)
        
        settingsButton.title = String(format: NSLocalizedString("accessibilityDialogPopover.settingsButton", comment: ""))
        settingsButton.resizeToFitText()
        
        // Force WebKit.framework to load
        _ = NSClassFromString("WKWebViewConfiguration")
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        
        self.setupWebView()
    }
    
    @IBAction func buttonClicked(_ sender: NSButton) {
        if let url = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility") {
            NSWorkspace.shared.open(url)
        }
    }
    
    // MARK: Web view
    private func setupWebView() {
        
        /// This hack job of a solution from ChatGPT is to get around the fact that searching for private frameworks results in build errors when importing WebKit
        
        // Dynamically get WKWebView class
        guard let webViewClass = NSClassFromString("WKWebView") as? NSView.Type else {
            print("WKWebView not available")
            return
        }

        // Instantiate WKWebView
        let dynamicWebView = webViewClass.init(frame: self.view.bounds)
        dynamicWebView.frame = webViewContainer?.bounds ?? NSRect(x: 0, y: 0, width: 0, height: 0)
        dynamicWebView.autoresizingMask = [.width, .height]
        dynamicWebView.layer?.cornerRadius = 5.0
        dynamicWebView.needsLayout = true
        dynamicWebView.layoutSubtreeIfNeeded()

        self.webViewContainer?.addSubview(dynamicWebView)

        // Load local HTML file
        guard let htmlURL = Bundle.main.url(forResource: "AccessibilityPopover", withExtension: "html") else {
            print("Could not find HTML file in bundle")
            return
        }

        let loadSelector = NSSelectorFromString("loadFileURL:allowingReadAccessToURL:")
        if dynamicWebView.responds(to: loadSelector) {
            _ = dynamicWebView.perform(
                loadSelector,
                with: htmlURL,
                with: htmlURL.deletingLastPathComponent()
            )
        }
        
    }
}
