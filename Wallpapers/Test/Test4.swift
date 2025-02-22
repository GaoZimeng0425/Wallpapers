//
//  Test4.swift
//  Wallpapers
//
//  Created by 高子蒙 on 2023/8/29.
//

import SwiftUI

struct Test4: View {
  enum Flavor: String, CaseIterable, Identifiable {
    var id: String { rawValue }
    case vanilla, chocolate, strawberry, raspberry, blueberry, strawberr, cherry
  }

  var gradient: LinearGradient {
    .linearGradient(
      Gradient(colors: [.red.opacity(0.8), .black.opacity(0)]),
      startPoint: .bottom,
      endPoint: .center
    )
  }

  var body: some View {
    List {
      ForEach(Flavor.allCases) {
        Text($0.rawValue)
          .listRowInsets(.init(top: 20, leading: 10, bottom: 20, trailing: 10))
          .foregroundColor(.red)
          .fontWeight(.bold)
      }
      gradient
//      ZStack(alignment: .bottomLeading) {
//        VStack(alignment: .leading) {
//          Text("name")
//            .font(.title)
//            .bold()
//          Text("landmark.park")
//        }
//        .padding()
//      }
//      .foregroundColor(.white)
    }
  }
}

struct Test4_Previews: PreviewProvider {
  static var previews: some View {
    Test4()
  }
}
