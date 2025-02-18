//
//  ChicagoListView.swift
//  Wallpapers
//
//  Created by 高子蒙 on 2023/9/18.
//

import Kingfisher
import SwiftUI

struct ChicagoListView: View {
  @State var result: ChicagoResponse.Result?

  var images: [Image] {
    guard let result = result else { return [] }
    return result.data
      .map { $0.thumbnail?.lqip }
      .map {
        guard let data = Data(base64Encoded: $0!) else { return Image("Animals") }
        guard let nsImage = NSImage(data: data) else { return Image("Animals") }
        return Image(nsImage: nsImage)
      }
  }

  func base64Path(base64String: String) -> String {
    if let range = base64String.range(of: "base64,") {
      let base64String = String(base64String[range.upperBound...])
      return base64String
    } else {
      return base64String
    }
  }

  @ViewBuilder
  func base64Image(base64: String) -> some View {
    let base64 = base64Path(base64String: base64)
    if let data = Data(base64Encoded: base64),
       let nsImage = NSImage(data: data)
    {
      Image(nsImage: nsImage)
        .resizable()
        .scaledToFit()
        .frame(maxWidth: .infinity)
    } else {
      Text(base64)
    }
  }

  var body: some View {
    ScrollView {
//      Text("\(result.pagination.total)")
      Spacer()
      ForEach(result?.data ?? [], id: \.id) { data in
//        KFImage.url(URL(string: ChicagoAPI.displayImageUrl(id: data.imageId ?? ""))).placeholder { _ in
//          base64Image(base64: data.thumbnail?.lqip ?? "")
//        }
      }
      Spacer()
//      Text("\(result.config)")
    }.onAppear {
      Task {
        do {
          result = try await ChicagoAPI.artworks()
        }
      }
    }
  }
}

struct Image64: View {
  let base64String = "data:image/gif;base64,R0lGODlhBgAFAPQAADg3ODg4OD49PD89PEZEQ0xKSU1MS1BPTlFPTllXVmpoZmxqaGxqam9ta3FubnJwbnl2dXl3d4WCgZGPjZOQjpSRj5WSkZ2amaOgnquoprCtq7q3tAAAAAAAAAAAAAAAACH5BAAAAAAALAAAAAAGAAUAAAUYIHYIxNBsU7IUjyNBVJUBhoQUChNEmnWFADs="

  var base64: String {
    if let range = base64String.range(of: "base64,") {
      let base64String = String(base64String[range.upperBound...])
      return base64String
    } else {
      return base64String
    }
  }

  var body: some View {
    ScrollView {}
  }
}

struct ChicagoListView_Previews: PreviewProvider {
  static var previews: some View {
    ChicagoListView().frame(maxWidth: .infinity, maxHeight: .infinity)
  }
}

struct Image64_Previews: PreviewProvider {
  static var previews: some View {
    Image64().frame(maxWidth: .infinity, maxHeight: .infinity)
  }
}
