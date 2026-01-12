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

@MainActor
class AppController: NSObject, NSMenuDelegate {
    // MARK: - @IBOutlet
    @IBOutlet private var statusMenu: NSMenu!
    
    @IBOutlet private var menuAccessibilityPermissions: NSMenuItem!

    @IBOutlet private var menuRotationControlMode: NSMenuItem!
    @IBOutlet private var menuRotationControlModeVolume: NSMenuItem!
    @IBOutlet private var menuRotationControlModeBrightness: NSMenuItem!
    @IBOutlet private var menuRotationControlModeKeyboard: NSMenuItem!
    @IBOutlet private var menuRotationControlModeScroll: NSMenuItem!
    @IBOutlet private var menuRotationControlModeLeftRight: NSMenuItem!
    @IBOutlet private var menuRotationControlModeUpDown: NSMenuItem!
    @IBOutlet private var menuRotationControlModeSpotifyVolume: NSMenuItem!
    @IBOutlet private var menuRotationControlModeNone: NSMenuItem!
    
    @IBOutlet private var menuButtonControlMode: NSMenuItem!
    @IBOutlet private var menuButtonControlModeLeftClick: NSMenuItem!
    @IBOutlet private var menuButtonControlModePlayback: NSMenuItem!
    @IBOutlet private var menuButtonControlModeMute: NSMenuItem!
    @IBOutlet private var menuButtonControlModeNone: NSMenuItem!

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
    
    // Dynamic menu items
    @objc dynamic private var accessibilityPermissionsGranted = false
    
    override init() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        accessibilityPermissionsGranted = AXIsProcessTrusted()
        
        super.init()

        dial = Dial(connectionHandler: connected, disconnectionHandler: disconnected)
    }
    
    // Public
    static public var shared: AppController!
    
    public var customSensitivity: CustomSensitivityView?
    
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

        menuRotationControlMode.title = NSLocalizedString("menu.rotationMode", comment: "")
        menuRotationControlModeVolume.title = NSLocalizedString("menu.rotationMode.music", comment: "")
        menuRotationControlModeBrightness.title = NSLocalizedString("menu.rotationMode.brightness", comment: "")
        menuRotationControlModeKeyboard.title = NSLocalizedString("menu.rotationMode.keyboard", comment: "")
        menuRotationControlModeScroll.title = NSLocalizedString("menu.rotationMode.scroll", comment: "")
        menuRotationControlModeLeftRight.title = NSLocalizedString("menu.rotationMode.leftRight", comment: "")
        menuRotationControlModeUpDown.title = NSLocalizedString("menu.rotationMode.upDown", comment: "")
        menuRotationControlModeSpotifyVolume.title = NSLocalizedString("menu.rotationMode.spotifyVolume", comment: "")
        menuRotationControlModeNone.title = NSLocalizedString("menu.rotationMode.none", comment: "")
        
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
        
        menuState.title = NSLocalizedString("dial.disconnected", comment: "")
        menuQuit.title = NSLocalizedString("menu.quit", comment: "")
        
        // Custom sensitivity view
        self.customSensitivity = CustomSensitivityView()
        menuSensitivityCustomSubitem.view = self.customSensitivity?.view
        
        // Menu state init
        setRotationMode(mode: UserSettings.rotationMode)
        setButtonMode(mode: UserSettings.buttonMode)
        setSensitivity(sensitivity: UserSettings.sensitivity)
        setDirection(direction: UserSettings.wheelDirection)
        setHaptics(enabled: UserSettings.hapticsEnabled)
        setKeepDialAwake(enabled: UserSettings.keepDialAwake)
        setShowOSD(enabled: UserSettings.showOSD)
        setStatusIcon(icon: UserSettings.statusIcon)
        setKeyScrollModifiers(
            shift: UserSettings.keyScrollModifiers.shift,
            command: UserSettings.keyScrollModifiers.command,
            option: UserSettings.keyScrollModifiers.option,
            control: UserSettings.keyScrollModifiers.control
        )
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
    private func rotationModeSelect(item: NSMenuItem) {
        menuRotationControlModeScroll.state = .off
        menuRotationControlModeVolume.state = .off
        menuRotationControlModeBrightness.state = .off
        menuRotationControlModeKeyboard.state = .off
        menuRotationControlModeLeftRight.state = .off
        menuRotationControlModeUpDown.state = .off
        menuRotationControlModeSpotifyVolume.state = .off
        menuRotationControlModeNone.state = .off
        
        item.state = .on
        
        menuRotationControlMode.image = item.image
        
        switch item.identifier {
            case menuRotationControlModeVolume.identifier:
                dialControl = RotationVolumeControl()
                UserSettings.rotationMode = .volume
                menuKeyScrollModifiers.visible = false
            case menuRotationControlModeBrightness.identifier:
                dialControl = RotationBrightnessControl()
                UserSettings.rotationMode = .brightness
                menuKeyScrollModifiers.visible = false
            case menuRotationControlModeKeyboard.identifier:
                dialControl = RotationKeyboardBacklightControl()
                UserSettings.rotationMode = .keyboard
                menuKeyScrollModifiers.visible = false
                
            case menuRotationControlModeScroll.identifier:
                dialControl = RotationScrollControl()
                UserSettings.rotationMode = .scrolling
                menuKeyScrollModifiers.visible = true
            case menuRotationControlModeLeftRight.identifier:
                dialControl = RotationArrowKeyControl(rightTurnKeyCode: .rightArrow, leftTurnKeyCode: .leftArrow)
                UserSettings.rotationMode = .leftRight
                menuKeyScrollModifiers.visible = true
            case menuRotationControlModeUpDown.identifier:
                dialControl = RotationArrowKeyControl(rightTurnKeyCode: .upArrow, leftTurnKeyCode: .downArrow)
                UserSettings.rotationMode = .upDown
                menuKeyScrollModifiers.visible = true
                
            case menuRotationControlModeSpotifyVolume.identifier:
                dialControl = SpotifyVolumeControl()
                UserSettings.rotationMode = .spotifyVolume
                menuKeyScrollModifiers.visible = false
                
            case menuRotationControlModeNone.identifier:
                dialControl = NoneControl()
                UserSettings.rotationMode = .none
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
                buttonControl = ButtonClickControl(eventDownType: .leftMouseDown, eventUpType: .leftMouseUp)
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
                setKeyScrollModifiers(shift: !UserSettings.keyScrollModifiers.shift, command: nil, option: nil, control: nil)
                
            case menuKeyScrollModifierCommand.identifier:
                setKeyScrollModifiers(shift: nil, command: !UserSettings.keyScrollModifiers.command, option: nil, control: nil)
                
            case menuKeyScrollModifierOption.identifier:
                setKeyScrollModifiers(shift: nil, command: nil, option: !UserSettings.keyScrollModifiers.option, control: nil)
                
            case menuKeyScrollModifierControl.identifier:
                setKeyScrollModifiers(shift: nil, command: nil, option: nil, control: !UserSettings.keyScrollModifiers.control)
                
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
                UserSettings.sensitivity = .low
            case menuSensitivityMedium.identifier:
                item.state = .on
                UserSettings.sensitivity = .medium
            case menuSensitivityHigh.identifier:
                item.state = .on
                UserSettings.sensitivity = .high
            case menuSensitivityCustom.identifier:
                item.state = .on
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
                UserSettings.wheelDirection = .clockwise
            case menuWheelDirectionCCW.identifier:
                menuWheelDirectionCCW.state = .on
                UserSettings.wheelDirection = .counterclockwise
            default:
                break
        }
    }
    
    @IBAction
    private func hapticFeedbackSelect(_: NSMenuItem) {
        updateHapticFeedbackSetting(enabled: !UserSettings.hapticsEnabled)
    }
    
    // Menu Separator //
    
    @IBAction
    private func keepDialAwakeSelect(_: NSMenuItem) {
        updateKeepDialAwakeSetting(enabled: !UserSettings.keepDialAwake)
    }
    
    @IBAction
    private func showOSDSelect(_: NSMenuItem) {
        updateShowOSDSetting(enabled: !UserSettings.showOSD)
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

    
    // MARK: - Public setters
    
    public func setRotationMode(mode: UserSettings.RotationOperationMode) {
        switch mode {
            case .none:
                rotationModeSelect(item: menuRotationControlModeNone)
            case .scrolling:
                rotationModeSelect(item: menuRotationControlModeScroll)
            case .volume:
                rotationModeSelect(item: menuRotationControlModeVolume)
            case .brightness:
                rotationModeSelect(item: menuRotationControlModeBrightness)
            case .keyboard:
                rotationModeSelect(item: menuRotationControlModeKeyboard)
            case .leftRight:
                rotationModeSelect(item: menuRotationControlModeLeftRight)
            case .upDown:
                rotationModeSelect(item: menuRotationControlModeUpDown)
            case .spotifyVolume:
                rotationModeSelect(item: menuRotationControlModeSpotifyVolume)
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
    
    public func setKeyScrollModifiers(shift: Bool?, command: Bool?, option: Bool?, control: Bool?) {
        if let shift {
            UserSettings.keyScrollModifiers.shift = shift
            menuKeyScrollModifierShift.stateBool = shift
        }
        
        if let command {
            UserSettings.keyScrollModifiers.command = command
            menuKeyScrollModifierCommand.stateBool = command
        }
        
        if let option {
            UserSettings.keyScrollModifiers.option = option
            menuKeyScrollModifierOption.stateBool = option
        }
        
        if let control {
            UserSettings.keyScrollModifiers.control = control
            menuKeyScrollModifierControl.stateBool = control
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
            menuRotationControlMode?.submenu?.allOnItems().first
        }
    }
    
    private var selectedButtonModeItem: NSMenuItem? {
        get {
            menuButtonControlMode?.submenu?.allOnItems().first
        }
    }
    
    
    // MARK: - Helper
    
    private func updateHapticFeedbackSetting(enabled: Bool) {
        UserSettings.hapticsEnabled = enabled
        hapticFeedback.state = enabled ? .on : .off
    }
    
    private func updateKeepDialAwakeSetting(enabled: Bool) {
        UserSettings.keepDialAwake = enabled
        keepDialAwake.state = enabled ? .on : .off
        
        // Trigger empty haptic when updating menu option
        dial?.sendKeepAlive()
    }
    
    private func updateShowOSDSetting(enabled: Bool) {
        UserSettings.showOSD = enabled
        showOSD.state = enabled ? .on : .off
    }
    
    private func updateMenuBarItemImage(from: NSMenuItem?) {
        guard let from else { return }
        
        // Copy image data, to not resize original icon shown in NSMenu dropdown
        let selectedImage = NSImage(
            cgImage: (
                from.image?.cgImage(forProposedRect:nil, context:nil, hints:nil)
                ?? NSImage(named: "menuicon-dial")?.cgImage(forProposedRect: nil, context: nil, hints: nil)
            )!,
            size: .init(width: 16, height: 16),
        )
        selectedImage.isTemplate = true
        
        statusItem.button?.image = selectedImage
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
        menuState.title = String(format: NSLocalizedString("dial.connected", comment: ""), debugBuild ? "XXXXXXXXXXXXX" : serialNumber)
    }

    private func disconnected() {
        menuState.title = NSLocalizedString("dial.disconnected", comment: "")
    }
    
    
    
    // MARK: - Accessibility permissions
    
    public func requestPermissions() {
        // More information on this behaviour: https://stackoverflow.com/questions/29006379/accessibility-permissions-reset-after-application-update
        if !AXIsProcessTrusted() {
            let iconConfig = NSImage.SymbolConfiguration().applying(.init(hierarchicalColor: .systemBlue))
            
            let alertDelegate = AccessibilityAlertDelegate()
            
            let alert = NSAlert()
            alert.delegate = alertDelegate
            alert.showsHelp = true
            alert.messageText = NSLocalizedString("accessibilityDialog.title", comment: "")
            alert.alertStyle = NSAlert.Style.informational
            alert.icon = NSImage(systemSymbolName:"accessibility", accessibilityDescription: "Accessibility")?.withSymbolConfiguration(iconConfig)
            alert.informativeText = NSLocalizedString("accessibilityDialog.description", comment: "")
            alert.runModal()
        }
        
        let options : NSDictionary = [kAXTrustedCheckOptionPrompt.takeRetainedValue() as NSString: true]
        
        AXIsProcessTrustedWithOptions(options)
    }
}

class AccessibilityAlertDelegate : NSObject, NSAlertDelegate {
    
    func alertShowHelp(_ alert: NSAlert) -> Bool {
        let window = alert.window

        guard let helpButton = window.contentView?
            .subviews
            .compactMap({ $0 as? NSButton })
            .first(where: { $0.bezelStyle == .helpButton }) else {
            return false
        }

        let popover = NSPopover()
        popover.behavior = .transient
        popover.contentViewController = AccessibilityPopoverView()

        popover.show(relativeTo: helpButton.bounds, of: helpButton, preferredEdge: .maxX)
        
        return true
    }
}
