//
//  Scroll.swift
//  Wallpapers
//
//  Created by 高子蒙 on 2023/9/10.
//

import SwiftUI

struct InfinityScroll<Content: View>: View {
  @State var scrollViewSize: CGSize = .zero
  let offsetY = 60.0
  let spaceName = "scroll"
  var action: ((_ offsetY: CGFloat) -> Void)?
  var onScrollChange: ((_ scrollY: CGFloat) -> Void)?
  let content: (_ geometry: GeometryProxy) -> Content

  var body: some View {
    GeometryReader { geo in
      ScrollView(showsIndicators: false) {
        ChildSizeReader(size: $scrollViewSize) {
          content(geo)
            .background(
              GeometryReader { proxy in
                Color.clear.preference(
                  key: ViewOffsetKey.self,
                  value: -1 * proxy.frame(in: .named(spaceName)).origin.y
                )
              }
            )
            .onPreferenceChange(
              ViewOffsetKey.self,
              perform: { value in
                if scrollViewSize.height <= geo.size.height { return }
                if value >= scrollViewSize.height - geo.size.height - offsetY {
                  action?(value)
                }
              }
            )
        }
      }
    }
    .coordinateSpace(name: spaceName)
  }
}

struct ViewOffsetKey: PreferenceKey {
  typealias Value = CGFloat
  static var defaultValue = CGFloat.zero
  static func reduce(value: inout Value, nextValue: () -> Value) {
    value += nextValue()
  }
}

struct ChildSizeReader<Content: View>: View {
  @Binding var size: CGSize
  let content: () -> Content

  var body: some View {
    ZStack {
      content().background(
        GeometryReader { proxy in
          Color.clear.preference(
            key: SizePreferenceKey.self,
            value: proxy.size
          )
        }
      )
    }
    .onPreferenceChange(SizePreferenceKey.self) { preferences in
      self.size = preferences
    }
  }
}

struct SizePreferenceKey: PreferenceKey {
  typealias Value = CGSize
  static var defaultValue: Value = .zero

  static func reduce(value _: inout Value, nextValue: () -> Value) {
    _ = nextValue()
  }
}

struct InfinityScroll_Previews: PreviewProvider {
  static var previews: some View {
    InfinityScroll { _ in
      VStack {
        ForEach(0 ..< 100) { i in
          Text("\(i)")
        }
      }
    }
  }
}
