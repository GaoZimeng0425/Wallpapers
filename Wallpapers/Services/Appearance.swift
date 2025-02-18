//
//  Appearance.swift
//  Wallpapers
//
//  Created by 高子蒙 on 2023/8/31.
//

import Carbon
import SwiftUI

enum MyError2: Int, Error {
  case invalidInput = 12
  case networkError = 11
}

let scriptSource = """
tell application "System Events"
    tell appearance preferences
        set dark mode to not dark mode
    end tell
end tell
"""

func runAppleScript(script: String) {
  _ = NSRunningApplication.runningApplications(withBundleIdentifier: "com.apple.systemevents").first

  if let script = NSAppleScript(source: scriptSource) {
    var errorInfo: NSDictionary?
    if let output = script.executeAndReturnError(&errorInfo).stringValue {
      debugPrint("runAppleScript: ", output)
    } else if let error = errorInfo {
      debugPrint("runAppleScript error: \(error)")
    }
  }
}

enum Appearance {
  @AppStorage("isDarkModeEnabled") static var isDarkModeEnabled = false

  static var bgColor: Color {
    isDarkModeEnabled
      ? Color.black
      : Color.white
  }

  static func toggleThemeAppleScript() {
    runAppleScript(script: scriptSource)
  }

  static func setLightAppearance() {
    if let lightAppearance = NSAppearance(named: .aqua) {
      NSApplication.shared.appearance = lightAppearance
    }
  }

  // 设置外观为深色模式
  static func setDarkAppearance() {
    if let darkAppearance = NSAppearance(named: .darkAqua) {
      NSApplication.shared.appearance = darkAppearance
    }
  }

  // 设置外观为自动模式
  static func setAutomaticAppearance() {
    NSApplication.shared.appearance = nil
  }
}
