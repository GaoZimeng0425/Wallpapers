//
//  File.swift
//  Wallpapers
//
//  Created by 高子蒙 on 2023/8/26.
//
import SwiftUI

struct BlurEffectView: NSViewRepresentable {
  var intensity: NSVisualEffectView.Material = .fullScreenUI
  
  func makeNSView(context: Context) -> NSVisualEffectView {
    let visualEffectView = NSVisualEffectView()
    
    visualEffectView.state = .active
    visualEffectView.blendingMode = .behindWindow
    visualEffectView.material = intensity
    visualEffectView.wantsLayer = true
    
    return visualEffectView
  }
  
  func updateNSView(_ nsView: NSVisualEffectView, context: Context) {
    nsView.material = intensity
  }
}

struct BlurEffect_Preview: PreviewProvider {
  static var previews: some View {
    HStack {
      Button {
      } label: {
         Text("ultraThinMaterial")
      }.plain().padding(20)
        .background( .ultraThinMaterial )
        .clipShape(RoundedRectangle(cornerRadius: 15))
    }.frame(width: 200, height: 200)
    
  }
}
