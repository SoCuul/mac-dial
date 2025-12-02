//
//  OSD
//  MacDial
//
//  Created by Daniel Costa
//
//  Adapted from: https://github.com/waydabber/showosd/blob/main/Sources/showosd/main.swift
//
//  License: MIT
//

private let manager = OSDManager.sharedManager() as? OSDManager

public enum OSD {
    
    public enum images: Int64 {
        case brightness          = 1
        case volume              = 3
        case volumedisable       = 22
        case mute                = 4
        case mutedisable         = 21
        case nokeylight          = 12
        case nokeylightdisable   = 14
        case keylight            = 11
        case keylightdisable     = 13
        case nowifi              = 9
        case eject               = 6
        case sleep               = 20
        case link                = 19
        case panel               = 15
    }
    
    public static func show(_ image: images, _ filledAmount: UInt32) {
        if let manager {
            
            var displayCount: UInt32 = 0
            var onlineDisplays = [CGDirectDisplayID](repeating: 0, count: Int(1))
            _ = CGGetOnlineDisplayList(1, &onlineDisplays, &displayCount)
            
            if displayCount > 0 {
                let primary = onlineDisplays[0]
                
                manager.showImage(
                    image.rawValue,
                    onDisplayID: primary,
                    priority: 0x1F4,
                    msecUntilFade: 1500,
                    filledChiclets: filledAmount,
                    totalChiclets: 100,
                    locked: false
                )
            }
            
        }
    }
}
