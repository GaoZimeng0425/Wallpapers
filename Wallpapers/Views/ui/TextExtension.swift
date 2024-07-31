//
//  TextExtension.swift
//  Wallpapers
//
//  Created by 高子蒙 on 2023/9/12.
//

import SwiftUI

extension Text {
  func plain(padding: [CGFloat] = [15, 10], font: Font = .title) -> some View {
    self
      .lineLimit(1)
      .font(font)
      .padding(.horizontal, padding[0])
      .padding(.vertical, padding[1])
  }
}

extension Text {
  func markerText(isDarkMode: Bool = true) -> some View {
    self
      .lineLimit(1)
      .font(.system(size: 10))
      .padding(.vertical, 5)
      .padding(.horizontal, 10)
      .background(isDarkMode ? Color.black.opacity(0.6) : Color.white.opacity(0.6))
      .cornerRadius(5)
  }
}
