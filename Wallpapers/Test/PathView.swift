//
//  PathView.swift
//  Wallpapers
//
//  Created by 高子蒙 on 2023/8/27.
//

import SwiftUI

struct PathView: View {
  var body: some View {
    Path { path in
      let width: CGFloat = 100.0
      let height = width
      path.move(
        to: CGPoint(
          x: width * 0.95,
          y: height * 0.20
        )
      )

//      path.addLine(
//        to: CGPoint( x: width * 0, y: height * 0 )
//      )
//      path.addLine(
//        to: CGPoint( x: width * 1, y: height * 0 )
//      )
//      path.addLine(
//        to: CGPoint( x: width * 1, y: height * 1 )
//      )
//      path.addLine(
//        to: CGPoint( x: width * 0, y: height * 1 )
//      )
//      path.addLine(
//        to: CGPoint( x: width * 0, y: height * 0 )
//      )
      path.addLines(
        [
          CGPoint(x: width, y: height),
          CGPoint(x: 0, y: height),
          CGPoint(x: width , y: height),
          CGPoint(x: 0, y: 0)
        ]
      )
    }.fill(.red)
  }
}

struct PathView_Previews: PreviewProvider {
  static var previews: some View {
    PathView()
  }
}
