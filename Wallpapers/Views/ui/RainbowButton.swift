//
//  SwiftUIView.swift
//  Wallpapers
//
//  Created by 高子蒙 on 2023/8/26.
//

import SwiftUI

struct RotatingBorderButton: View {
  @State var isAnimation = false
  var buttonText: String = "Click"
  var action: (() -> Void)?
  @State private var colors: [Color] = [.red, .orange, .yellow, .green, .cyan, .blue, .purple, .red]

  var body: some View {
    Button(action: { action?() }) {
      Text(buttonText)
        .font(.title3)
        .fontWeight(.semibold)
        .foregroundColor(.black)
    }
    .buttonStyle(.plain)
    .padding(10)
    .background(.white)
    .clipShape(RoundedRectangle(cornerRadius: 15))
    .overlay {
//      Capsule(style: RoundedCornerStyle.circular)
      RoundedRectangle(cornerRadius: 15)
        .stroke(
          AngularGradient(
            gradient: Gradient(colors: colors),
            center: .center,
            startAngle: isAnimation ? .degrees(360) : .degrees(0),
            endAngle: isAnimation ? .degrees(720) : .degrees(360)
          ), lineWidth: 5
        )
    }.onAppear {
      withAnimation(.linear(duration: 5).repeatForever(autoreverses: false)) {
        isAnimation = true
      }
    }
  }
}

struct RotatingBorderButton_Previews: PreviewProvider {
  static var previews: some View {
    HStack {
      RotatingBorderButton()
        .padding(10)
    }
    .frame(width: 200, height: 200)
  }
}
