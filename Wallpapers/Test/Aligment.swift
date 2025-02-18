//
//  aligment.swift
//  Wallpapers
//
//  Created by 高子蒙 on 2023/9/12.
//

import SwiftUI

struct aligment: View {
  var body: some View {
    HStack {
      Text("🌧")
        .alignmentGuide(VerticalAlignment.center) { _ in 8 }
        .border(.gray)
      Text("Rain & Thunderstorms")
        .border(.gray)
      Text("⛈")
        .alignmentGuide(VerticalAlignment.center) { _ in 8 }
        .border(.gray)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
  }
}

struct aligment_Previews: PreviewProvider {
  static var previews: some View {
    aligment()
  }
}
