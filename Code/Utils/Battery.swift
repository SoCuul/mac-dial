//
//  Battery
//  MacDial
//
//  Created by Daniel Costa
//
//  License: MIT
//

import Foundation
import IOKit.ps

// Identifiers for the Surface Dial
private let _dialVendorId = 0x045E
private let _dialProductId = 0x091B

private typealias CopyPowerSourcesByType = @convention(c) (Int32) -> Unmanaged<CFArray>?

/// Retrieve `IOPSCopyPowerSourcesByType` private IOKit symbol
private let _copyPowerSourcesByType: CopyPowerSourcesByType? = {
    guard let symbol = dlsym(dlopen(nil, RTLD_LAZY), "IOPSCopyPowerSourcesByType")
    else { return nil }
    
    return unsafeBitCast(symbol, to: CopyPowerSourcesByType.self)
}()

func dialBattery() -> Int? {
    guard
        let copy = _copyPowerSourcesByType,
        let sources = copy(0)?.takeRetainedValue() as? [[String: Any]]
            else { return nil }

    return sources.first {
        $0[kIOPSTypeKey] as? String == "Accessory Source"
        && $0["Vendor ID"] as? Int == _dialVendorId
        && $0["Product ID"] as? Int == _dialProductId
    }?[kIOPSCurrentCapacityKey] as? Int
}
