//
//  BlurView.swift
//  Folder Finder
//
//  Created by GaoZimeng on 2024/11/26.
//

import SwiftUI

// SwiftUI view for NSVisualEffect
// https://github.com/lukakerr/NSWindowStyles
struct VisualEffectView: NSViewRepresentable {
  var material: NSVisualEffectView.Material = .hudWindow
  var blendingMode: NSVisualEffectView.BlendingMode = .behindWindow

  func makeNSView(context _: Context) -> NSVisualEffectView {
    let view = NSVisualEffectView()
    view.autoresizingMask = [.width, .height]
    view.material = material
    view.blendingMode = blendingMode
    view.state = NSVisualEffectView.State.active
    view.isEmphasized = true
    return view
  }

  func updateNSView(_ visualEffectView: NSVisualEffectView, context _: Context) {
    visualEffectView.material = material
    visualEffectView.blendingMode = blendingMode
  }
}

struct VisualEffectView_Preview: PreviewProvider {
  static var previews: some View {
    HStack {
      VisualEffectView()
      Button {} label: {
        Text("ultraThinMaterial")
      }.plain().padding(20)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 15))
    }.frame(width: 200, height: 200)
  }
}
