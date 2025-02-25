//
//  ImageService.swift
//  Wallpapers
//
//  Created by 高子蒙 on 2023/8/30.
//

import AppKit
import Foundation
import Kingfisher
import SwiftUI

public enum wallpaperService {
  public enum Screen {
    case all
    case main
    case index(Int)
    case nsScreens([NSScreen])

    fileprivate var nsScreens: [NSScreen] {
      switch self {
      case .all:
        return NSScreen.screens
      case .main:
        guard let mainScreen = NSScreen.main else {
          return []
        }

        return [mainScreen]
      case let .index(index):
        guard index < NSScreen.screens.count else {
          return []
        }
        return [NSScreen.screens[index]]
//          return [screen]
      case let .nsScreens(nsScreens):
        return nsScreens
      }
    }
  }

  public enum Scale: String, CaseIterable {
    case auto
    case fill
    case fit
    case stretch
    case center
  }

  public static func options(_: URL, screen _: Screen = .all, scale: Scale = .auto, fillColor: NSColor? = nil) -> [NSWorkspace.DesktopImageOptionKey: Any] {
    var options = [NSWorkspace.DesktopImageOptionKey: Any]()

    switch scale {
    case .auto:
      break
    case .fill:
      options[.imageScaling] = NSImageScaling.scaleProportionallyUpOrDown.rawValue
      options[.allowClipping] = true
    case .fit:
      options[.imageScaling] = NSImageScaling.scaleProportionallyUpOrDown.rawValue
      options[.allowClipping] = false
    case .stretch:
      options[.imageScaling] = NSImageScaling.scaleAxesIndependently.rawValue
      options[.allowClipping] = true
    case .center:
      options[.imageScaling] = NSImageScaling.scaleNone.rawValue
      options[.allowClipping] = false
    }

    options[.fillColor] = fillColor

    return options
  }

  static func setAllDesktopImage(url: URL, screens: [NSScreen]) {
    screens.forEach {
      self.setSingleDesktopImage(url: url, screen: $0)
    }
  }

  static func setSingleDesktopImage(url: URL, screen: NSScreen?) {
    let workspace = NSWorkspace.shared
    guard let screen = screen else { return }
    guard let options = workspace.desktopImageOptions(for: screen) else { return }
    
    do {
      try NSWorkspace.shared.setDesktopImageURL(url, for: NSScreen.main ?? NSScreen.screens.first!, options: options)
    } catch let error as NSError {
      debugPrint("ERROR URL: \(url)")
      debugPrint("ERROR：\(error.localizedDescription)")
    }
  }

  static func setDesktopImage(url: URL, all: Bool? = false) {
    if let all {
      setAllDesktopImage(url: url, screens: NSScreen.screens)
    } else {
      setSingleDesktopImage(url: url, screen: NSScreen.main)
    }
  }
}

enum ImageService {
  static let downloader = ImageDownloader.default
  static var downloads: [KFCrossPlatformImage] = []

  static func cleanCache() {
    let cache = KingfisherManager.shared.cache
    cache.clearDiskCache() // 清除硬盘缓存
    cache.clearMemoryCache() // 清除内存缓存
    cache.cleanExpiredDiskCache() // 清除过期的硬盘缓存
  }

  static func downloadAsync(url: URL?, progress: ((_ percentage: Float, _ totalSize: Int) -> Void)?) async throws -> URL {
    if url == nil {
      throw MyError2.networkError
    }

    return try await withCheckedThrowingContinuation { continuation in
      downloader.downloadImage(with: url!, progressBlock: { receivedSize, totalSize in
        let percentage = (Float(receivedSize) / Float(totalSize)) * 100
        progress?(percentage, Int(totalSize))
        print("Download progress: \(percentage)%")
      }) { result in

        switch result {
        case let .success(value):
          guard let url = value.url else { return }
          let name = url.lastPathComponent
          let exe = url.pathExtension == "" ? "" : ".\(url.pathExtension)"
          Task {
            let url = try await DownloadService.saveImageToDownloads(data: value.originalData, name: "\(name)\(exe)")
            continuation.resume(returning: url)
          }
        case let .failure(error):
          continuation.resume(throwing: error)
        }
      }
    }
  }

  static func download(url: URL?, handle: @escaping (_: URL) -> Void) {
    if url == nil {
      return
    }
    downloader.downloadImage(with: url!) { result in
      switch result {
      // TODO: adjust exetion
      case let .success(value):
        guard let url = value.url else { return }
        let name = url.lastPathComponent
        let exe = url.pathExtension == "" ? "" : ".\(url.pathExtension)"
        debugPrint("ImageService download: 142 ", exe)
        Task {
          let url = try await DownloadService.saveImageToDownloads(data: value.originalData, name: "\(name)\(exe)")
          handle(url)
        }
//          return value
      case let .failure(error):
        debugPrint("func download error: ", error)
      }
    }
  }
}

enum ImageResolution: String {
  case qHD = "540p"
  case HD = "720p"
  case fullHD = "1080p"
  case _2K = "2K"
  case QHD = "1440p"
  case UHD = "2160p"
  case _4K = "4K"
  case _5K = "5K"
  case _8K = "8K"
  case Unknown

  static func getImageResolution(width: Int, height: Int) -> ImageResolution {
    if width >= 7680 && height >= 4320 {
      return ._8K
    } else if width >= 5120 && height >= 2880 {
      return ._5K
    } else if width >= 4096 && height >= 2160 {
      return ._4K
    } else if width >= 3840 && height >= 2160 {
      return .UHD
    } else if width >= 2560 && height >= 1440 {
      return .QHD
    } else if width >= 2040 && height >= 1080 {
      return ._2K
    } else if width >= 1920 && height >= 1080 {
      return .fullHD
    } else if width >= 1280 && height >= 720 {
      return .HD
    } else if width >= 960 && height >= 540 {
      return .qHD
    } else {
      return .Unknown
    }
  }

  func color() -> Color {
    switch self {
    case .fullHD, .HD, .qHD:
      return Color.purple
    case ._2K, .QHD:
      return Color.orange
    case ._4K, ._5K, .UHD:
      return Color.blue
    case ._8K:
      return Color.red
    case .Unknown:
      return Color.brown
    }
  }

  func string() -> String? {
    rawValue
  }
}
