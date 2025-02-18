//
//  TestUIView2.swift
//  Wallpapers
//
//  Created by 高子蒙 on 2023/8/27.
//

import SwiftUI

struct TestUIView2: View {
  @State private var colors: [Color] = [.red, .yellow, .blue, .green, .cyan]
  @State private var index = 2

  @State private var offsetY: CGFloat = 0

  @State private var a: [Double] = [0, 360]

  @State private var isAnimation = false
  var body: some View {
    VStack {
      Button(action: {}) {
        Text("Click")
          .font(.title3)
      }
      .buttonStyle(.plain)
      .padding()
      .overlay {
        RoundedRectangle(cornerRadius: 20)
          .trim(from: 0, to: 0.75)
          .stroke(
            AngularGradient(
              gradient: Gradient(colors: colors),
              center: .center,
              startAngle: .degrees(a[0]),
              endAngle: .degrees(a[1])
            ),
            lineWidth: 10
          )
          .cornerRadius(20)
      }.onAppear {
        withAnimation(.linear(duration: 10).repeatForever(autoreverses: false)) {
          a = [180, 360]
        }
      }
      .frame(width: 200, height: 100)

      Circle()
        .trim(from: 0, to: 0.75)
        .stroke(
          AngularGradient(
            gradient: Gradient(colors: colors),
            center: .center,
            startAngle: .degrees(0),
            endAngle: .degrees(360)
          ), lineWidth: 10
        )
        .frame(width: 50, height: 50)
        .rotationEffect(Angle(degrees: isAnimation ? 360 : 0))
        .onAppear {
          withAnimation(.linear(duration: 1).repeatForever(autoreverses: false)) {
            self.isAnimation = true
          }
        }

//      Circle()
//        .frame(width: 100, height: 100)
//        .foregroundColor(colors[index])
//        .offset(y: offsetY)
//        .onAppear {
//          withAnimation(.linear(duration: 1).repeatForever(autoreverses: true)) {
//            self.offsetY = 100
//            index = 4
//          }
//        }

      Circle()
        .fill(Color.pink)
        .scaledToFill()
        .frame(width: 300, height: 150)
        .border(Color(white: 0.75))
        .clipped()
    }
  }
}

struct TestUIView2_Previews: PreviewProvider {
  static var previews: some View {
    VStack {
      TestUIView2()
    }.frame(width: 1000, height: 1000)
  }
}
