//
//  SwiftUIView.swift
//  Wallpapers
//
//  Created by 高子蒙 on 2023/8/30.
//

import SwiftUI
import AppKit
import Kingfisher

class ViewController: NSViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // 创建一个 UIImageView 实例
    let imageView = NSImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
    
    // 设置图片 URL
    let url = URL(string: "https://example.com/image.jpg")
    
    // 设置图片
    imageView.kf.setImage(with: url)
    
    // 将 UIImageView 添加到视图中
    view.addSubview(imageView)
  }
}
