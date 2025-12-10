//
//  AccessibilityPopoverView
//  MacDial
//
//  Created by Daniel Costa
//
//  License: MIT
//

import Cocoa
import WebKit

class anotherAccessibilityPopoverViewController: NSViewController {
    var webView: NSView?
    
    // This hack job of a solution from ChatGPT is to get around the fact that searching for private frameworks renders WebKit not importable for some reason

    override func loadView() {
        self.view = NSView(frame: .zero)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Dynamically get WKWebView class
        guard let webViewClass = NSClassFromString("WKWebView") as? NSView.Type else {
            print("WKWebView not available")
            return
        }

        // Instantiate WKWebView
        let dynamicWebView = webViewClass.init(frame: self.view.bounds)
        dynamicWebView.autoresizingMask = [.width, .height]

        self.view.addSubview(dynamicWebView)
        self.webView = dynamicWebView

        // Load local HTML file
        guard let htmlURL = Bundle.main.url(forResource: "index", withExtension: "html") else {
            print("Could not find HTML file in bundle")
            return
        }

        let loadSelector = NSSelectorFromString("loadFileURL:allowingReadAccessToURL:")
        if dynamicWebView.responds(to: loadSelector) {
            _ = dynamicWebView.perform(loadSelector, with: htmlURL, with: htmlURL.deletingLastPathComponent())
        }
    }
}

class AccessibilityPopoverViewController: NSViewController, WKUIDelegate {
    var webView: WKWebView!

    override func loadView() {
        webView = WKWebView(frame: .zero)
        webView.uiDelegate = self
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        if let url = Bundle.main.url(forResource: "AppName", withExtension: "html") {
            let folderURL = url.deletingLastPathComponent()
            webView.loadFileURL(url, allowingReadAccessTo: folderURL)
        }
    }

    override func viewDidLayout() {
        super.viewDidLayout()
        webView.frame = view.bounds
    }
}
