//
//  CAMLContainerView
//
//  Created by samsam on 3/13/26
//
//  Modified by Daniel Costa
//
//  Original source: https://github.com/CLARATION/Shasta/blob/main/Shasta/Views/CAMLContainerView.swift
//
//  License: MIT
//

import AppKit
import QuartzCore

class CAMLContainerView: NSView {
    var rootLayer: CALayer?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.wantsLayer = true
        self.clipsToBounds = true
    }
    
    override func layout() {
        super.layout()
        
        guard let root = rootLayer else {
            return
        }
        
        let ls = root.bounds.size
        
        guard
            ls.width > 0,
            ls.height > 0,
            bounds.width > 0,
            bounds.height > 0
        else {
            return
        }
        
        let scale = min(bounds.width / ls.width, bounds.height / ls.height) * 0.9
        
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        root.setAffineTransform(CGAffineTransform(scaleX: scale, y: scale))
        root.position = CGPoint(x: bounds.midX, y: bounds.midY)
        CATransaction.commit()
    }
}
