//
//  AppController
//  MacDial
//
//  Created by Alex Babaev
//
//  Based on Andreas Karlsson sources
//  https://github.com/andreasjhkarlsson/mac-dial
//
//  License: MIT
//

import AppKit

class AppController: NSObject, NSMenuDelegate, CustomSensitivityDelegate {
    // MARK: - @IBOutlet
    @IBOutlet private var statusMenu: NSMenu!
    
    @IBOutlet private var menuAccessibilityPermissions: NSMenuItem!

    @IBOutlet private var menuButtonControlMode: NSMenuItem!
    @IBOutlet private var menuButtonControlModeLeftClick: NSMenuItem!
    @IBOutlet private var menuButtonControlModePlayback: NSMenuItem!
    @IBOutlet private var menuButtonControlModeMute: NSMenuItem!
    @IBOutlet private var menuButtonControlModeNone: NSMenuItem!

    @IBOutlet private var menuDialControlMode: NSMenuItem!
    @IBOutlet private var menuDialControlModeScroll: NSMenuItem!
    @IBOutlet private var menuDialControlModeVolume: NSMenuItem!
    @IBOutlet private var menuDialControlModeBrightness: NSMenuItem!
    @IBOutlet private var menuDialControlModeKeyboard: NSMenuItem!
    @IBOutlet private var menuDialControlModeNone: NSMenuItem!
    
    @IBOutlet private var menuKeyScrollModifiers: NSMenuItem!
    @IBOutlet private var menuKeyScrollModifierShift: NSMenuItem!
    @IBOutlet private var menuKeyScrollModifierCommand: NSMenuItem!
    @IBOutlet private var menuKeyScrollModifierOption: NSMenuItem!
    @IBOutlet private var menuKeyScrollModifierControl: NSMenuItem!

    @IBOutlet private var menuSensitivity: NSMenuItem!
    @IBOutlet private var menuSensitivityLow: NSMenuItem!
    @IBOutlet private var menuSensitivityMedium: NSMenuItem!
    @IBOutlet private var menuSensitivityHigh: NSMenuItem!
    @IBOutlet private var menuSensitivityCustom: NSMenuItem!
    @IBOutlet private var menuSensitivityCustomSubitem: NSMenuItem!
    
    @IBOutlet private var menuWheelDirection: NSMenuItem!
    @IBOutlet private var menuWheelDirectionCW: NSMenuItem!
    @IBOutlet private var menuWheelDirectionCCW: NSMenuItem!

    @IBOutlet private var hapticFeedback: NSMenuItem!
    
    @IBOutlet private var keepDialAwake: NSMenuItem!
    @IBOutlet private var showOSD: NSMenuItem!
    
    @IBOutlet private var menuStatusIcon: NSMenuItem!
    @IBOutlet private var menuStatusIconDefault: NSMenuItem!
    @IBOutlet private var menuStatusIconRotation: NSMenuItem!
    @IBOutlet private var menuStatusIconButton: NSMenuItem!

    @IBOutlet private var menuState: NSMenuItem!
    @IBOutlet private var menuQuit: NSMenuItem!

    private let statusItem: NSStatusItem

    private let settings: UserSettings = .init()

    private var dial: Dial?
    private var dialControl: DeviceControl?
    private var buttonControl: DeviceControl?
    
    private var customSensitivityView: CustomSensitivityView?
    
    // Dynamic menu items
    @objc dynamic var accessibilityPermissionsGranted = false
    
    override init() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        accessibilityPermissionsGranted = AXIsProcessTrusted()
        
        super.init()

        dial = Dial(connectionHandler: connected, disconnectionHandler: disconnected)
    }
    
    static var shared: AppController!
    
    // MARK: - Nib & menu delegate setup

    override func awakeFromNib() {
        super.awakeFromNib()
        
        statusItem.menu = statusMenu
        
        // Localization
        
        menuAccessibilityPermissions.title = NSLocalizedString("menu.accessibilityPermissions", comment: "")
        menuAccessibilityPermissions.toolTip = NSLocalizedString("menu.tooltip.accessibilityPermissions", comment: "")

        menuButtonControlMode.title = NSLocalizedString("menu.buttonMode", comment: "")
        menuButtonControlModeLeftClick.title = NSLocalizedString("menu.buttonMode.leftClick", comment: "")
        menuButtonControlModePlayback.title = NSLocalizedString("menu.buttonMode.playback", comment: "")
        menuButtonControlModeMute.title = NSLocalizedString("menu.buttonMode.mute", comment: "")
        menuButtonControlModeNone.title = NSLocalizedString("menu.buttonMode.none", comment: "")

        menuDialControlMode.title = NSLocalizedString("menu.dialMode", comment: "")
        menuDialControlModeScroll.title = NSLocalizedString("menu.dialMode.scroll", comment: "")
        menuDialControlModeVolume.title = NSLocalizedString("menu.dialMode.music", comment: "")
        menuDialControlModeBrightness.title = NSLocalizedString("menu.dialMode.brightness", comment: "")
        menuDialControlModeKeyboard.title = NSLocalizedString("menu.dialMode.keyboard", comment: "")
        menuDialControlModeNone.title = NSLocalizedString("menu.dialMode.none", comment: "")
        
        menuKeyScrollModifiers.title = NSLocalizedString("menu.keyScrollModifiers", comment: "")
        menuKeyScrollModifiers.toolTip = NSLocalizedString("menu.tooltip.keyScrollModifiers", comment: "")

        menuSensitivity.title = NSLocalizedString("menu.rotationSensitivity", comment: "")
        menuSensitivityLow.title = NSLocalizedString("menu.rotationSensitivity.low", comment: "")
        menuSensitivityMedium.title = NSLocalizedString("menu.rotationSensitivity.medium", comment: "")
        menuSensitivityHigh.title = NSLocalizedString("menu.rotationSensitivity.high", comment: "")
        menuSensitivityCustom.title = NSLocalizedString("menu.rotationSensitivity.custom", comment: "")

        menuWheelDirection.title = NSLocalizedString("menu.direction", comment: "")
        menuWheelDirectionCW.title = NSLocalizedString("menu.direction.cw", comment: "")
        menuWheelDirectionCCW.title = NSLocalizedString("menu.direction.ccw", comment: "")

        hapticFeedback.title = NSLocalizedString("menu.hapticFeedback", comment: "")
        hapticFeedback.toolTip = NSLocalizedString("menu.tooltip.hapticFeedback", comment: "")
        
        keepDialAwake.title = NSLocalizedString("menu.keepDialAwake", comment: "")
        keepDialAwake.toolTip = NSLocalizedString("menu.tooltip.keepDialAwake", comment: "")
        
        showOSD.title = NSLocalizedString("menu.showOSD", comment: "")
        showOSD.toolTip = NSLocalizedString("menu.tooltip.showOSD", comment: "")
        
        menuStatusIcon.title = NSLocalizedString("menu.statusIcon", comment: "")
        menuStatusIconDefault.title = NSLocalizedString("menu.statusIcon.default", comment: "")
        menuStatusIconRotation.title = NSLocalizedString("menu.statusIcon.rotation", comment: "")
        menuStatusIconRotation.toolTip = NSLocalizedString("menu.tooltip.statusIcon.rotation", comment: "")
        menuStatusIconButton.title = NSLocalizedString("menu.statusIcon.button", comment: "")
        menuStatusIconButton.toolTip = NSLocalizedString("menu.tooltip.statusIcon.button", comment: "")
        
        menuQuit.title = NSLocalizedString("menu.quit", comment: "")
        
        // Custom sensitivity view
        self.customSensitivityView = CustomSensitivityView()
        menuSensitivityCustomSubitem.view = self.customSensitivityView?.view
        
        // Menu state init
        setDialMode(mode: UserSettings.dialMode)
        setButtonMode(mode: UserSettings.buttonMode)
        setSensitivity(sensitivity: UserSettings.sensitivity)
        setDirection(direction: UserSettings.wheelDirection)
        setHaptics(enabled: UserSettings.isHapticFeedbackEnabled)
        setKeepDialAwake(enabled: UserSettings.shouldKeepDialAwake)
        setShowOSD(enabled: UserSettings.isShowOSDEnabled)
        setStatusIcon(icon: UserSettings.statusIcon)
        
        // Menu key scroll modifiers
        menuKeyScrollModifierShift.stateBool = UserSettings.keyScrollModifiers.shift
        menuKeyScrollModifierCommand.stateBool = UserSettings.keyScrollModifiers.command
        menuKeyScrollModifierOption.stateBool = UserSettings.keyScrollModifiers.option
        menuKeyScrollModifierControl.stateBool = UserSettings.keyScrollModifiers.control
        
        // TODO: REENABLE THIS DO NOT LEAVE IT DISABLED
        //requestPermissions()
    }
    
    func menuWillOpen(_ menu: NSMenu) {
        menuStatusIconRotation.image = selectedRotationModeItem?.image
        menuStatusIconButton.image = selectedButtonModeItem?.image
        
        // Check if accessibility permissions are granted
        accessibilityPermissionsGranted = AXIsProcessTrusted()
    }
    

    
    // MARK: - @IBAction
    
    @IBAction
    private func accessibilityPermissionsSelect(item: NSMenuItem) {
        requestPermissions()
    }
    
    @IBAction
    private func dialModeSelect(item: NSMenuItem) {
        menuDialControlModeScroll.state = .off
        menuDialControlModeVolume.state = .off
        menuDialControlModeBrightness.state = .off
        menuDialControlModeKeyboard.state = .off
        menuDialControlModeNone.state = .off
        
        item.state = .on
        
        menuDialControlMode.image = item.image
        
        switch item.identifier {
            case menuDialControlModeVolume.identifier:
                dialControl = DialVolumeControl()
                UserSettings.dialMode = .volume
                menuKeyScrollModifiers.visible = false
            case menuDialControlModeBrightness.identifier:
                dialControl = DialBrightnessControl()
                UserSettings.dialMode = .brightness
                menuKeyScrollModifiers.visible = false
            case menuDialControlModeKeyboard.identifier:
                dialControl = DialKeyboardBacklightControl()
                UserSettings.dialMode = .keyboard
                menuKeyScrollModifiers.visible = false
            case menuDialControlModeScroll.identifier:
                dialControl = DialScrollControl()
                UserSettings.dialMode = .scrolling
                menuKeyScrollModifiers.visible = true
            case menuDialControlModeNone.identifier:
                dialControl = NoneControl()
                UserSettings.dialMode = .none
                menuKeyScrollModifiers.visible = false
            default:
                break
        }
        
        dial?.controls = (dialControl.map { [ $0 ] } ?? []) + (buttonControl.map { [ $0 ] } ?? [])

        updateMenuBarTooltip()
        if (UserSettings.statusIcon == .rotation) {
            statusIconSelect(item: menuStatusIconRotation)
        }
    }
    
    @IBAction
    private func buttonModeSelect(item: NSMenuItem) {
        menuButtonControlModeLeftClick.state = .off
        menuButtonControlModePlayback.state = .off
        menuButtonControlModeMute.state = .off
        menuButtonControlModeNone.state = .off
        
        item.state = .on
        menuButtonControlMode.image = item.image
        
        switch item.identifier {
            case menuButtonControlModeLeftClick.identifier:
                buttonControl = ClickControl(eventDownType: .leftMouseDown, eventUpType: .leftMouseUp)
                UserSettings.buttonMode = .leftClick
            case menuButtonControlModePlayback.identifier:
                buttonControl = ButtonPlaybackControl()
                UserSettings.buttonMode = .playback
            case menuButtonControlModeMute.identifier:
                buttonControl = ButtonMuteControl()
                UserSettings.buttonMode = .mute
            case menuButtonControlModeNone.identifier:
                buttonControl = NoneControl()
                UserSettings.buttonMode = .none
            default:
                break
        }
        
        dial?.controls = (dialControl.map { [ $0 ] } ?? []) + (buttonControl.map { [ $0 ] } ?? [])
        
        updateMenuBarTooltip()
        if (UserSettings.statusIcon == .button) {
            statusIconSelect(item: menuStatusIconButton)
        }
    }
    
    @IBAction
    private func keyScrollModifierSelect(item: NSMenuItem) {
        switch item.identifier {
            case menuKeyScrollModifierShift.identifier:
                UserSettings.keyScrollModifiers.shift = !UserSettings.keyScrollModifiers.shift
                item.stateBool = UserSettings.keyScrollModifiers.shift
                
            case menuKeyScrollModifierCommand.identifier:
                UserSettings.keyScrollModifiers.command = !UserSettings.keyScrollModifiers.command
                item.stateBool = UserSettings.keyScrollModifiers.command
                
            case menuKeyScrollModifierOption.identifier:
                UserSettings.keyScrollModifiers.option = !UserSettings.keyScrollModifiers.option
                item.stateBool = UserSettings.keyScrollModifiers.option
                
            case menuKeyScrollModifierControl.identifier:
                UserSettings.keyScrollModifiers.control = !UserSettings.keyScrollModifiers.control
                item.stateBool = UserSettings.keyScrollModifiers.control
                
            default:
                break
        }
    }
    
    // Menu Separator //
    
    @IBAction
    private func sensitivitySelect(item: NSMenuItem) {
        menuSensitivityLow.state = .off
        menuSensitivityMedium.state = .off
        menuSensitivityHigh.state = .off
        menuSensitivityCustom.state = .off
        
        switch item.identifier {
            case menuSensitivityLow.identifier:
                item.state = .on
                dial?.wheelSensitivity = .low
                UserSettings.sensitivity = .low
            case menuSensitivityMedium.identifier:
                item.state = .on
                dial?.wheelSensitivity = .medium
                UserSettings.sensitivity = .medium
            case menuSensitivityHigh.identifier:
                item.state = .on
                dial?.wheelSensitivity = .high
                UserSettings.sensitivity = .high
            case menuSensitivityCustom.identifier:
                item.state = .on
                dial?.wheelSensitivity = .custom
                UserSettings.sensitivity = .custom
            default:
                break
        }
    }
    
    @IBAction
    private func directionSelect(item: NSMenuItem) {
        menuWheelDirectionCW.state = .off
        menuWheelDirectionCCW.state = .off
        
        switch item.identifier {
            case menuWheelDirectionCW.identifier:
                menuWheelDirectionCW.state = .on
                dial?.wheelDirection = .clockwise
                UserSettings.wheelDirection = .clockwise
            case menuWheelDirectionCCW.identifier:
                menuWheelDirectionCCW.state = .on
                dial?.wheelDirection = .counterclockwise
                UserSettings.wheelDirection = .counterclockwise
            default:
                break
        }
    }
    
    @IBAction
    private func hapticFeedbackSelect(_: NSMenuItem) {
        updateHapticFeedbackSetting(enabled: !UserSettings.isHapticFeedbackEnabled)
    }
    
    // Menu Separator //
    
    @IBAction
    private func keepDialAwakeSelect(_: NSMenuItem) {
        updateKeepDialAwakeSetting(enabled: !UserSettings.shouldKeepDialAwake)
    }
    
    @IBAction
    private func showOSDSelect(_: NSMenuItem) {
        updateShowOSDSetting(enabled: !UserSettings.isShowOSDEnabled)
    }
    
    @IBAction
    private func statusIconSelect(item: NSMenuItem) {
        menuStatusIconDefault.state = .off
        menuStatusIconRotation.state = .off
        menuStatusIconButton.state = .off
        
        switch item.identifier {
            case menuStatusIconDefault.identifier:
                menuStatusIconDefault.state = .on
                UserSettings.statusIcon = .default
                updateMenuBarItemImage(from: menuStatusIconDefault)
            case menuStatusIconRotation.identifier:
                menuStatusIconRotation.state = .on
                UserSettings.statusIcon = .rotation
                updateMenuBarItemImage(from: selectedRotationModeItem)
            case menuStatusIconButton.identifier:
                menuStatusIconButton.state = .on
                UserSettings.statusIcon = .button
                updateMenuBarItemImage(from: selectedButtonModeItem)
            default:
                break
        }
    }
    
    // Menu Separator //
    
    @IBAction
    private func quitTap(_ item: NSMenuItem) {
        NSApplication.shared.terminate(self)
    }
    
    
    // MARK: - Custom sensitivity delegate
    
    func customSensitivityValueDidChange() {
        
    }

    
    // MARK: - Public setters
    
    public func setDialMode(mode: UserSettings.DialOperationMode) {
        switch mode {
            case .none:
                dialModeSelect(item: menuDialControlModeNone)
            case .scrolling:
                dialModeSelect(item: menuDialControlModeScroll)
            case .volume:
                dialModeSelect(item: menuDialControlModeVolume)
            case .brightness:
                dialModeSelect(item: menuDialControlModeBrightness)
            case .keyboard:
                dialModeSelect(item: menuDialControlModeKeyboard)
        }
    }
    
    public func setButtonMode(mode: UserSettings.ButtonOperationMode) {
        switch mode {
            case .none:
                buttonModeSelect(item: menuButtonControlModeNone)
            case .leftClick:
                buttonModeSelect(item: menuButtonControlModeLeftClick)
            case .playback:
                buttonModeSelect(item: menuButtonControlModePlayback)
            case .mute:
                buttonModeSelect(item: menuButtonControlModeMute)
        }
    }
    
    public func setSensitivity(sensitivity: UserSettings.WheelSensitivity) {
        switch sensitivity {
            case .low:
                sensitivitySelect(item: menuSensitivityLow)
            case .medium:
                sensitivitySelect(item: menuSensitivityMedium)
            case .high:
                sensitivitySelect(item: menuSensitivityHigh)
            case .custom:
                sensitivitySelect(item: menuSensitivityCustom)
        }
    }
    
    public func setDirection(direction: UserSettings.WheelDirection) {
        switch direction {
            case .clockwise:
                directionSelect(item: menuWheelDirectionCW)
            case .counterclockwise:
                directionSelect(item: menuWheelDirectionCCW)
        }
    }
    
    public func setHaptics(enabled: Bool) {
        updateHapticFeedbackSetting(enabled: enabled)
    }
    
    public func setKeepDialAwake(enabled: Bool) {
        updateKeepDialAwakeSetting(enabled: enabled)
    }
    
    public func setShowOSD(enabled: Bool) {
        updateShowOSDSetting(enabled: enabled)
    }
    
    public func setStatusIcon(icon: UserSettings.StatusIconMode) {
        switch icon {
            case .default:
                statusIconSelect(item: menuStatusIconDefault)
            case .rotation:
                statusIconSelect(item: menuStatusIconRotation)
            case .button:
                statusIconSelect(item: menuStatusIconButton)
        }
    }
    
    
    // MARK: - Computed values
    
    private var selectedRotationModeItem: NSMenuItem? {
        get {
            menuDialControlMode?.submenu?.allOnItems()[0]
        }
    }
    
    private var selectedButtonModeItem: NSMenuItem? {
        get {
            menuButtonControlMode?.submenu?.allOnItems()[0]
        }
    }
    
    
    // MARK: - Helper
    
    private func updateHapticFeedbackSetting(enabled: Bool) {
        UserSettings.isHapticFeedbackEnabled = enabled
        dial?.isHapticFeedbackEnabled = enabled
        hapticFeedback.state = enabled ? .on : .off
    }
    
    private func updateKeepDialAwakeSetting(enabled: Bool) {
        UserSettings.shouldKeepDialAwake = enabled
        dial?.shouldKeepDialAwake = enabled
        keepDialAwake.state = enabled ? .on : .off
        
        // Trigger empty haptic when updating menu option
        dial?.sendKeepAlive()
    }
    
    private func updateShowOSDSetting(enabled: Bool) {
        UserSettings.isShowOSDEnabled = enabled
        dial?.showOSD = enabled
        showOSD.state = enabled ? .on : .off
    }
    
    private func updateMenuBarItemImage(from: NSMenuItem?) {
        guard let from else { return }
        
        // TODO: it seems that when a rotation/button mode is selected to show in menu bar icon, it shrinks the icon slighly in the menu item dropdown where its selected and in the menu bar itself
        
        let selectedImage = from.image ?? NSImage(named: "menuicon-dial")
        statusItem.button?.image = selectedImage
        statusItem.button?.image?.size = .init(width: 16, height: 16)
        statusItem.button?.imagePosition = .imageLeft
        updateMenuBarTooltip()
    }
    
    private func updateMenuBarTooltip() {
        statusItem.button?.toolTip = "Rotation Mode: \(selectedRotationModeItem?.title ?? "Unknown")\nButton Mode: \(selectedButtonModeItem?.title ?? "Unknown")"
    }
    
    
    
    // MARK: - Lifecycle
    
    func terminate() {
        dial = nil
    }

    private func connected(_ serialNumber: String) {
        menuState.title = String(format: NSLocalizedString("dial.connected", comment: ""), serialNumber)
    }

    private func disconnected() {
        menuState.title = NSLocalizedString("dial.disconnected", comment: "")
    }
    
    
    
    // MARK: - Accessibility permissions
    
    private func requestPermissions() {
        // More information on this behaviour: https://stackoverflow.com/questions/29006379/accessibility-permissions-reset-after-application-update
        if !AXIsProcessTrusted() {
            let iconConfig = NSImage.SymbolConfiguration().applying(.init(hierarchicalColor: .systemBlue))
            
            let alertDelegate = AccessibilityAlertDelegate()
            
            let alert = NSAlert()
            alert.delegate = alertDelegate
            alert.showsHelp = true
            alert.messageText = NSLocalizedString("dialog.accessibilityTitle", comment: "")
            alert.alertStyle = NSAlert.Style.informational
            alert.icon = NSImage(systemSymbolName:"accessibility", accessibilityDescription: "Accessibility")?.withSymbolConfiguration(iconConfig)
            alert.informativeText = NSLocalizedString("dialog.accessibilityDescription", comment: "")
            alert.runModal()
        }
        
        let options : NSDictionary = [kAXTrustedCheckOptionPrompt.takeRetainedValue() as NSString: true]
        
        AXIsProcessTrustedWithOptions(options)
    }
}

class AccessibilityAlertDelegate : NSObject, NSAlertDelegate {
    func alertShowHelp(_ alert: NSAlert) -> Bool {
        // TODO: add a proper page or smtn to show how to remove app from accessibility
        
        if let helpUrl = URL(string: "https://stackoverflow.com/questions/29006379/accessibility-permissions-reset-after-application-update") {
            NSWorkspace().open(helpUrl)
        }
        
        return true
    }
}
