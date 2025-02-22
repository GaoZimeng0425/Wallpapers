//
//  Constants.swift
//  Wallpapers
//
//  Created by 高子蒙 on 2023/8/30.
//

import SwiftUI

struct Constants {
  static var scale: CGFloat {
    guard let ns = NSScreen.main else { return 3 / 4 }
    return CGFloat(ns.frame.height / ns.frame.width)
  }
}

extension View {
  func hoverPoint() -> some View {
    self.onHover(perform: { hover in
      hover ? NSCursor.pointingHand.push() : NSCursor.pop()
    })
  }
}

extension View {
  func printSizeInfo(_ label: String = "") -> some View {
    background(
      GeometryReader { proxy in
        Color.clear
          .task(id: proxy.size) { }
      }
    )
  }
}

extension Image {
  func IconStyle() -> some View {
    self.resizable()
      .scaledToFit()
      .frame(width: 16, height: 16).clipped()
  }
}

extension NSWindow.StyleMask {
  static var defaultWindow: NSWindow.StyleMask {
    var styleMask: NSWindow.StyleMask = .init()
    styleMask.formUnion(.titled)
    styleMask.formUnion(.fullSizeContentView)
    return styleMask
  }
}
extension Image {
  func logo(size: CGFloat? = 20, padding: CGFloat = 0) -> some View {
    self.resizable()
      .scaledToFit()
      .frame(height: size).clipped()
      .padding(padding)
  }
}

extension Int {
  func bytesToMegabytes() -> String {
    String(format: "%.2f", Double(self) / (1024 * 1024)) + " MB"
  }
}

var gradient: LinearGradient {
  .linearGradient(
    Gradient(colors: [.black.opacity(0.8), .black.opacity(0)]),
    startPoint: .bottom,
    endPoint: .center
  )
}

extension Button {
  func plain() -> some View {
    self.buttonStyle(.borderless)
  }
}

extension Color {
  init(hex: String) {
    var hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

    if hexString.hasPrefix("#") {
      hexString.remove(at: hexString.startIndex)
    }

    var rgbValue: UInt64 = 0
    Scanner(string: hexString).scanHexInt64(&rgbValue)

    let red = Double((rgbValue & 0xFF0000) >> 16) / 255.0
    let green = Double((rgbValue & 0x00FF00) >> 8) / 255.0
    let blue = Double(rgbValue & 0x0000FF) / 255.0

    self.init(red: red, green: green, blue: blue)
  }
}

enum HttpStatus: Int {
  case ok = 200
  case badRequest = 400
  case unauthorized = 401
  case forbidden = 403
  case notFound = 404
  case error = 500
  case serviceUnavailable = 503
}

extension HttpStatus: CustomStringConvertible {
  var description: String {
    switch self {
      case .ok:
        return "200 - OK: Everything worked as expected"
      case .badRequest:
        return "400 - Bad Request: The request was unacceptable, often due to missing a required parameter"
      case .unauthorized:
        return "401 - Unauthorized: Invalid Access Token"
      case .forbidden:
        return "403 - Forbidden: Missing permissions to perform request"
      case .notFound:
        return "404 - Not Found: The requested resource doesn’t exist"
      case .error, .serviceUnavailable:
        return "500, 503 - Something went wrong on our end"
    }
  }
}
