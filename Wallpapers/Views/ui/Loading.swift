//
//  SwiftUIView.swift
//  Wallpapers
//
//  Created by 高子蒙 on 2023/8/26.
//

import SwiftUI

struct Loading<Content: View>: View {
  var colors: [Color] = [.red, .orange, .yellow, .green, .cyan, .blue, .purple, .red]
  var radius: CGFloat = 20
  var duration: Double = 1
  let content: () -> Content

  @State var isAnimation = false

  var body: some View {
    content()
      .overlay {
        RoundedRectangle(cornerRadius: radius)
          .stroke(
            AngularGradient(
              gradient: Gradient(colors: colors),
              center: .center,
              startAngle: isAnimation ? .degrees(360) : .degrees(0),
              endAngle: isAnimation ? .degrees(720) : .degrees(360)
            ), lineWidth: 5
          )
      }
      .onAppear {
        withAnimation(.linear(duration: duration).repeatForever(autoreverses: false)) {
          self.isAnimation = true
        }
      }
  }
}

struct Loading_Previews: PreviewProvider {
  static var previews: some View {
    Loading(radius: 15, duration: 3) {
      Button {
        
      } label: {
        Text("CCC")
          
      }.plain()
        .foregroundColor(.blue)
//      Image("Rembrandt")
//        .resizable()
//        .scaledToFill()
        .frame(width: 200, height: 50)
//        .cornerRadius(50)
//        .clipped()
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
  }
}
