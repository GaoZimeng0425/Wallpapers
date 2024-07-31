//
//  FileService.swift
//  Wallpapers
//
//  Created by 高子蒙 on 2023/9/10.
//

import SwiftUI

struct FileService {
  static var shared = FileService()

  func open(path: URL?, withApplication: String?) {
    guard let path = path else { return }
    NSWorkspace.shared.open(path)
  }

  func removeFile(url: URL?) {
    guard let url = url else { return }
    do {
      let fileManager = FileManager.default
      // 检查文件是否存在
      if fileManager.fileExists(atPath: url.absoluteString) {
        try fileManager.removeItem(at: url)
      } else {
        print("文件不存在")
      }
    } catch let error as NSError {
      print("发生错误: \(error)")
    }
  }
}
