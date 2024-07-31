//
//  Download.swift
//  Wallpapers
//
//  Created by 高子蒙 on 2023/8/31.
//

import CoreServices
import Foundation
import SwiftUI

struct DownloadService {
  enum MyError: Error {
    case invalidInput
    case networkError
  }

  static func openDownloadPrctrueDirectroy() {
    guard let path = DownloadService.appPicturesDirectory else { return }
    NSWorkspace.shared.open(path)
  }

  func isImage(path: URL) -> Bool {
    // 获取文件头
    let data = try? Data(contentsOf: path)
    guard let data = data else {
      return false
    }

    // 判断文件头
    let firstByte = data[0]
    switch firstByte {
      case 0xff: return true
      case 0x89: return true
      case 0x47: return true
      case 0x4d: return true
      case 0x42: return true
      case 0x52: return true
      default: return false
    }
  }

  static func sortedUrls(urls: [URL]) -> [URL] {
    return urls.sorted {
      let creationDate1 = try? $0.resourceValues(forKeys: [.creationDateKey]).creationDate
      let creationDate2 = try? $1.resourceValues(forKeys: [.creationDateKey]).creationDate
      return creationDate1 ?? Date.distantPast > creationDate2 ?? Date.distantPast
    }
  }

  static var downloadPrctrueDirectroy: [URL] {
    guard let directory = DownloadService.appPicturesDirectory else { return [] }
    do {
      let pictureURLs = try FileManager.default.contentsOfDirectory(at: directory, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)

//      let pictureURLs = pictureURLs.filter { url -> Bool in
//        url.pathExtension.lowercased() == "jpg" || url.pathExtension.lowercased() == "jpeg" || url.pathExtension.lowercased() == "png"
//      }
      return sortedUrls(urls: pictureURLs)
    } catch {
      debugPrint(error)
      return []
    }
  }

  static let downloadsDirectory = FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask).first!

  static var appPicturesDirectory: URL? {
    guard let picturesDirectory = FileManager.default.urls(for: .picturesDirectory, in: .userDomainMask).first else {
      print("Failed to get pictures directory.")
      return nil
    }

    return picturesDirectory.appendingPathComponent("Nemo Wallpapers")
  }

  static func fileExists(path: URL) -> Bool {
    debugPrint(path.absoluteString, path.relativeString, path.absoluteURL)
    return FileManager.default.fileExists(atPath: path.absoluteString)
  }

  static func createFolderInPicturesDirectory() {
    guard let appPicturesDirectory = appPicturesDirectory else { return }
    debugPrint("----------------------")
    debugPrint("fileExists: \(fileExists(path: appPicturesDirectory))")
    debugPrint("----------------------")
    if fileExists(path: appPicturesDirectory) { return }

    do {
      // 创建文件夹
      try FileManager.default.createDirectory(at: appPicturesDirectory, withIntermediateDirectories: true, attributes: nil)
      print("Folder created successfully.")
    } catch {
      print("Failed to create folder: \(error)")
    }
  }

  static func appendingPathComponent(name: String) async -> URL {
    guard let path = appPicturesDirectory else { return downloadsDirectory }
    return path.appendingPathComponent(name)
  }

  static func saveImageToDownloads(data: Data?, name: String) async throws -> URL {
    if data == nil {
      throw MyError.invalidInput
    }
    let fileURL = await appendingPathComponent(name: name)

    do {
      try data!.write(to: fileURL)
    } catch {
      print("Error saving image: \(error)")
    }
    return fileURL
  }
}
