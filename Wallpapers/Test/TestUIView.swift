//
//  SwiftUIView.swift
//  Wallpapers
//
//  Created by 高子蒙 on 2023/8/26.
//

import SwiftUI

struct TTTT: View {
  @State var isShowing = true // toggle state
  @State var selection = ""
  @State private var progress: Float = 0.5
  @State var quantity: Int = 0
  var rows: [GridItem] = Array(repeating: .init(.fixed(20)), count: 5)

  var body: some View {
    ScrollView {
      VStack {
        TabView {
          Text("First View")
            .font(.title)
            .tabItem { Text("First") }
            .tag(0)
          Text("Second View")
            .font(.title)
            .tabItem { Text("Second") }
            .tag(1)
        }

        ProgressView(value: progress)
        ProgressView(value: progress)
          .progressViewStyle(CircularProgressViewStyle())

        HStack {
          Image(systemName: "sun.min")
          Slider(value: $progress, in: 0 ... 1, step: 0.2)
          Image(systemName: "sun.max.fill")
        }.padding()

        Stepper(onIncrement: {
          self.quantity += 1
        }, onDecrement: {
          self.quantity -= 1
        }, label: { Text("Quantity \(quantity)") })

        ZStack {
          Text("Hello")
            .padding(10)
            .background(.red)
            .opacity(0.8)
          Text("World")
            .padding(20)
            .background(.yellow)
            .offset(x: 20, y: 20)
        }

        List {
          Section(header: Text("UIKit"), footer: Text("We will miss you")) {
            Text("UITableView")
          }

          Section(header: Text("SwiftUI"), footer: Text("A lot to learn")) {
            Text("List")
          }
        }.listStyle(.sidebar)

        ScrollView(.horizontal) {
          LazyHGrid(rows: rows, alignment: .top) {
            ForEach(0 ... 100, id: \.self) {
              Text("\($0)").background(Color.pink)
            }.listRowInsets(.none)
          }
        }
      }.frame(maxWidth: .infinity, maxHeight: .infinity)
    }
  }
}

struct TestView_Previews: PreviewProvider {
  static var previews: some View {
    TTTT()
  }
}
