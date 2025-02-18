//
//  PlainButton.swift
//  Wallpapers
//
//  Created by 高子蒙 on 2023/9/5.
//

import SwiftUI

struct PlainButton: View {
  var text: String

  var font: Font = .title
  var padding: [CGFloat] = [15, 10]

  var action: () -> Void

  var body: some View {
    ZStack {
      Color.red
      Button(action: { action() }) {
        Text(text)
          .plain(padding: padding, font: font)
      }
      .background(.ultraThickMaterial)
//    .background(BlurEffectView())
    }
  }
}

struct PlainButton_Previews: PreviewProvider {
  static var previews: some View {
    HStack {
      PlainButton(text: "Set Desktop Background", action: {})
    }.frame(width: 200, height: 200)
  }
}
