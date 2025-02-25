//
//  WallpapersApp.swift
//  Wallpapers
//
//  Created by 高子蒙 on 2023/8/26.
//

import SwiftUI

@main
struct WallpapersApp: App {
  @StateObject var store = Store.shared
  @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
  @State private var searchText = ""

  // https://zhuanlan.zhihu.com/p/626490225
  init() {
    DownloadService.createFolderInPicturesDirectory()
//    NSApplication.shared.presentationOptions = [.hideMenuBar, .hideDock]
//    NSApplication.shared.setAccessibilityCloseButton(.none)
//    NSApplication.shared.setAccessibilityMinimizeButton(.none)
//    NSApplication.shared.setAccessibilityZoomButton(.none)
  }

  var body: some Scene {
//    WindowGroup {
//      ContentView()
//        .searchable(text: self.$searchText)
//        .onChange(of: self.searchText) { newValue in
//          print("Search text changed to \(newValue)")
//        }
//        .toolbar {
//          ToolbarItem {
//            Spacer()
//          }
//          ToolbarItem(placement: .primaryAction) {
//            Image(systemName: "square.and.arrow.down.fill")
//              .onTapGesture {
//                Appearance.toggleThemeAppleScript()
//              }
//          }
//        }
//        .frame(minHeight: 400)
//        .frame(width: 600)
//        .frame(maxHeight: .infinity)
//        .background(BlurEffectView())
//        .environmentObject(self.store)
//        .onAppear {
//          self.appDelegate.store = self.store
//        }
//    }
//    MenuBarExtra("Utility App", systemImage: "scribble.variable") {
//      ContentView().environmentObject(store)
//    }
//    MenuBarExtra("asdf") {
//      VStack {
//        Button("Show Fixed Window") {
//          if let window = NSApp.windows.first(where: { $0.title == "Fixed Menu" }) {
//            window.setIsVisible(false)
//            window.makeKeyAndOrderFront(nil) // 如果窗口已存在，则激活
//          } else {
//            // 创建并显示一个新窗口
//            let fixedWindow = NSWindow(
//              contentRect: NSRect(x: 0, y: 0, width: 360, height: 720),
////              styleMask: [.titled, .closable, .resizable],
//              styleMask: [.borderless, .nonactivatingPanel],
//              backing: .buffered,
//              defer: false
//            )
//            fixedWindow.hasShadow = true
//            fixedWindow.level = .floating
////            fixedWindow.title = "Fixed Menu"
////            fixedWindow.center()
//            fixedWindow.contentView = NSHostingView(rootView: ContentView().environmentObject(store))
//            fixedWindow.collectionBehavior.insert(.fullScreenAuxiliary) // Allows the pannel to appear in a fullscreen space
//            fixedWindow.collectionBehavior.insert(.canJoinAllSpaces)
//            fixedWindow.titleVisibility = .hidden
//            fixedWindow.titlebarAppearsTransparent = false
//            fixedWindow.isMovableByWindowBackground = true
//            fixedWindow.isReleasedWhenClosed = false
//            fixedWindow.isOpaque = false
////            fixedWindow.backgroundColor = .clear
//            fixedWindow.makeKeyAndOrderFront(fixedWindow.self)
//          }
//        }
//      }
//      ContentView()
//        .frame(width: 360, height: 720)
//        .environmentObject(store)
//    }.menuBarExtraStyle(.window)
    Settings {
      SettingsView()
        .frame(width: 600)
        .environmentObject(self.store)
    }
  }
}

class AppDelegate: NSObject, NSApplicationDelegate {
  static var shared: AppDelegate!
  var store: Store = .shared

  var popover: NSPopover!
  var statusBarItem: NSStatusItem!

  func generatePopover() {
    let popover = NSPopover()
    popover.behavior = .transient
    popover.animates = true
    popover.appearance = NSAppearance(named: .vibrantLight)
    popover.contentSize = NSSize(width: 360, height: 720)
    popover.contentViewController = NSViewController()
    popover.contentViewController?.view = NSHostingView(rootView: ContentView().environmentObject(store))
//    popover.contentViewController?.view.window?.center()
    self.popover = popover
  }

  @objc func togglePopover(_ sender: AnyObject?) {
    guard let button = statusBarItem.button else {
      return
    }

    if popover.isShown {
      popover.performClose(sender)
    } else {
      popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
      //      popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
      popover.contentViewController?.view.window?.makeKey()
    }
  }

  func applicationDidFinishLaunching(_: Notification) {
    if let window = NSApplication.shared.windows.first {
      window.standardWindowButton(.zoomButton)?.isEnabled = false
    }
    generatePopover()
    // Set the menu for the status bar item

    statusBarItem = NSStatusBar.system.statusItem(withLength: CGFloat(NSStatusItem.variableLength))
    guard let button = statusBarItem.button else {
      return
    }

    button.image = NSImage(systemSymbolName: "scribble.variable", accessibilityDescription: nil)
    button.action = #selector(togglePopover(_:))
  }

  func applicationDidResignActive() {
    NSApplication.shared.hide(self)
  }

  func windowShouldClose(_: NSWindow) -> Bool {
    print("aaclose")
    NSApp.hide(nil)
    return false
  }

  func applicationWillTerminate(_: Notification) {
    print("application terminate")
    // Insert code here to tear down your application
  }
}
