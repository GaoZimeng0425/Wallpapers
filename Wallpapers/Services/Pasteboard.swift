//
//  Pasteboard.swift
//  Wallpapers
//
//  Created by 高子蒙 on 2023/9/27.
//

import AppKit

struct Pasteboard {
  static func observe () {
//    let pasteboard = NSPasteboard
  }
}

class PasteboardObserver: NSObject {
  @objc dynamic var content: String? // 观察的属性
  
  func read() -> String{
    let pasteboard = NSPasteboard.general
    if let string = pasteboard.string(forType: .string) {
      print(string)  // 输出粘贴板中的文本
      return string
    }
    if let data = pasteboard.data(forType: .fileURL) {
      print("Data content: \(data)")
    }
    if let plist = pasteboard.propertyList(forType: .color) as? [String: Any] {
      print("Property list content: \(plist)")
    }
    let types = pasteboard.types
    print("Available types: \(types?.first?.rawValue ?? "unknown")")
    
    pasteboard.clearContents()
    return ""
  }
  
  override init() {
    super.init()
    
    // 添加观察者
    NSPasteboard.general.addObserver(self, forKeyPath: "content", options: .new, context: nil)
  }
  
  deinit {
    // 移除观察者
    NSPasteboard.general.removeObserver(self, forKeyPath: "content")
  }
  
  // 观察者的回调方法
  override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
    if keyPath == "content" {
      // 处理内容更改
      if let newValue = change?[.newKey] as? String {
        print("Pasteboard content changed: \(newValue)")
      }
    }
  }
}

