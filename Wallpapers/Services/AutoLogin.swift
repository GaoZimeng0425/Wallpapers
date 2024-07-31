//
//  AutoLogin.swift
//  Wallpapers
//
//  Created by 高子蒙 on 2023/9/8.
//

import AppKit
import ServiceManagement

struct AutoLogin {
  let launcherAppIdentifier = "com.example.MyAppLauncher"
  let mainBundleIdentifier = "com.gaozimeng.Wallpapers"
  func i() {
    SMAppService.loginItem(identifier: launcherAppIdentifier)
  }

  func a() {
    if let appURL = NSWorkspace.shared.urlForApplication(withBundleIdentifier: mainBundleIdentifier) {
      let configuration = NSWorkspace.OpenConfiguration()
      NSWorkspace.shared.openApplication(at: appURL, configuration: configuration) { (app, error) in
        if let error = error {
          print("Failed to launch app: \(error.localizedDescription)")
        } else {
          print("App launched successfully")
        }
      }
    }
  }
}
