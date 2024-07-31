//
//  Toolbar.swift
//  Wallpapers
//
//  Created by 高子蒙 on 2023/8/28.
//

import SwiftUI

struct Toolbar: View {
  @EnvironmentObject var store: Store
  @Binding var tabIndex: MainPages

  var action: ((_ index: Int) -> Void)?

  var body: some View {
    HStack {
      HStack {
        Text("Nemo")
          .font(.title2)
          .bold()
          .lineLimit(1)
        Text("Wallpapers")
          .font(.title3)
          .lineLimit(1)
      }

      Spacer()

      Button(action: {
        withAnimation(.linear(duration: 0.2)) {
          tabIndex = .gallery
        }
        self.action?(0)
      }) {
        Image(systemName: "photo")
          .IconStyle()
          .padding(5)
      }
      .buttonStyle(.borderless)
      .background(tabIndex == .gallery ? Color.gray : Color.clear)
      .cornerRadius(5)
      
      
      Button(action: {
        withAnimation(.linear(duration: 0.2)) {
          tabIndex = .select
        }
      }) {
        Image(systemName: "aqi.medium").IconStyle()
          .padding(5)
      }
      .buttonStyle(.borderless)
      .background(tabIndex == .select ? Color.gray : Color.clear)
      .cornerRadius(5)

      Button(action: {
        withAnimation(.linear(duration: 0.2)) {
          tabIndex = .local
        }
        self.action?(0)
      }) {
        Image(systemName: "arrow.down.circle")
          .IconStyle()
          .padding(5)
      }
      .buttonStyle(.borderless)
      .background(tabIndex == .local ? Color.gray : Color.clear)
      .cornerRadius(5)
      
      Button(action: {
        withAnimation(.linear(duration: 0.2)) {
          tabIndex = MainPages.setting
        }
        self.action?(1)
      }) {
        Image(systemName: "gear")
          .IconStyle()
          .padding(5)
      }
      .buttonStyle(.borderless)
      .background(tabIndex == .setting ? Color.gray : Color.clear)
      .cornerRadius(5)
    }
    .padding(.horizontal, 10)
    .padding(.vertical, 10)
  }
}

struct Toolbar_Previews: PreviewProvider {
  static var tabIndex = Binding.constant(MainPages.gallery)
  static var previews: some View {
    Toolbar(tabIndex: tabIndex)
  }
}
