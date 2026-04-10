//
//  UpdaterDelegate
//  MacDial
//
//  Created by Daniel Costa
//
//  License: MIT
//

import Foundation
import Sparkle

final class UpdaterDelegate: NSObject, SPUStandardUserDriverDelegate {
    var supportsGentleScheduledUpdateReminders: Bool { true }
    
    func standardUserDriverShouldHandleShowingScheduledUpdate(_ update: SUAppcastItem, andInImmediateFocus immediateFocus: Bool) -> Bool {
            // If the standard user driver will show the update in immediate focus (e.g. near app launch),
            // then let Sparkle take care of showing the update.
            // Otherwise we will handle showing any other scheduled updates
            return immediateFocus
        }
    
    func standardUserDriverWillHandleShowingUpdate(_ handleShowingUpdate: Bool, forUpdate update: SUAppcastItem, state: SPUUserUpdateState) {
        // We will ignore updates that the user driver will handle showing
        // This includes user initiated (non-scheduled) updates
        guard !handleShowingUpdate else {
            return
        }
        
        DispatchQueue.main.async {
            AppController.shared.updateAvailable = true
        }
    }
    
    func standardUserDriverWillFinishUpdateSession() {
        DispatchQueue.main.async {
            AppController.shared.updateAvailable = false
        }
    }
}
