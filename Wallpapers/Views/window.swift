//
//  YippyWindowController.swift
//  Yippy
//
//  Created by Matthew Davidson on 25/9/19.
//  Copyright © 2019 MatthewDavidson. All rights reserved.
//

import Foundation
import Cocoa
import RxSwift
import RxRelay


final class AppDelegate: NSObject, NSApplicationDelegate {
   lazy var panel: NSPanel = FloatingPanel(
        contentRect: NSRect(x: 0, y: 0, width: 700, height: 320),
        backing: .buffered,
        defer: false
    )

   func applicationDidFinishLaunching(_ aNotification: Notification) {
        // panel.contentView = ...
        panel.makeKeyAndOrderFront(nil)
        panel.center()
   }
}
final class Panel: NSPanel {
    init(contentRect: NSRect, backing: NSWindow.BackingStoreType, defer flag: Bool) {
        super.init(contentRect: contentRect, styleMask: [.titled, .resizable, .closable, .fullSizeContentView], backing: backing, defer: flag)
        
        self.isFloatingPanel = true
        self.level = .floating
        self.collectionBehavior.insert(.fullScreenAuxiliary)
        self.titleVisibility = .hidden
        self.titlebarAppearsTransparent = true
        self.isMovableByWindowBackground = true
        self.isReleasedWhenClosed = false
        self.standardWindowButton(.closeButton)?.isHidden = true
        self.standardWindowButton(.miniaturizeButton)?.isHidden = true
        self.standardWindowButton(.zoomButton)?.isHidden = true
    }
    
    // `canBecomeKey` and `canBecomeMain` are required so that text inputs inside the panel can receive focus
    override var canBecomeKey: Bool {
        return true
    }
    
    override var canBecomeMain: Bool {
        return true
    }
}

class YippyWindowController: NSWindowController {
    
    override func windowDidLoad() {
        super.windowDidLoad()
        
        window?.level = NSWindow.Level(NSWindow.Level.mainMenu.rawValue - 2)
        window?.setAccessibilityIdentifier(Accessibility.identifiers.yippyWindow)
        window?.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
    }
    
    static func createYippyWindowController() -> YippyWindowController {
        let storyboard = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: nil)
        let identifier = NSStoryboard.SceneIdentifier(stringLiteral: "YippyWindowController")
        guard let windowController = storyboard.instantiateController(withIdentifier: identifier) as? YippyWindowController else {
            fatalError("Failed to load YippyWindowController of type YippyWindowController from the Main storyboard.")
        }
        
        return windowController
    }
    
    private var oldApp: NSRunningApplication?
    
    func subscribeTo(toggle: BehaviorRelay<Bool>) -> Disposable {
        return toggle
            .subscribe(onNext: {
                [] in
                if !$0 {
                    self.close()
                    self.oldApp?.activate(options: .activateIgnoringOtherApps)
                }
                else {
                    self.oldApp = NSWorkspace.shared.frontmostApplication
                    self.showWindow(nil)
                    self.window?.makeKey()
                    NSApp.activate(ignoringOtherApps: true)
                }
            })
    }
    
    func subscribeFrameTo(position: Observable<PanelPosition>, screen: Observable<NSScreen>) -> Disposable {
        Observable.combineLatest(position, screen).subscribe(onNext: {
            (position, screen) in
            self.window?.setFrame(position.getFrame(forScreen: screen), display: true)
        })
    }
}