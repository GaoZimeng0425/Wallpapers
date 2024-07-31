//
//  LocalPictrueListView.swift
//  Wallpapers
//
//  Created by 高子蒙 on 2023/9/10.
//

import Kingfisher
import SwiftUI

struct LocalPictrueListView: View {
  fileprivate func OpenButton() -> some View {
    return Button(action: {
      DownloadService.openDownloadPrctrueDirectroy()
    }) {
      HStack {
        Image(systemName: "opticaldiscdrive")
          .IconStyle()
        Text("Open Directory")
          .font(.system(size: 12))
      }
    }.plain()
      .padding(.horizontal, 15)
      .padding(.vertical, 5)
      .overlay(content: {
        RoundedRectangle(cornerRadius: 5).stroke(Color.gray.opacity(0.75), lineWidth: 1)
      })
      .padding(5)
  }

  var body: some View {
    GeometryReader { geo in
      ScrollView(showsIndicators: false) {
        VStack(spacing: 0) {
          OpenButton()
          LazyVStack(spacing: 0) {
            ForEach(DownloadService.downloadPrctrueDirectroy, id: \.absoluteString) { url in
              ImageView(url: url, frame: [geo.size.width, geo.size.width * Constants.scale])
            }
          }
        }
      }.listStyle(.plain).frame(maxWidth: .infinity)
    }
  }
}

struct ImageView: View {
  @State var imageView: KFImage?
  @State var hover = false

  let url: URL
  let frame: [CGFloat]

  var body: some View {
    ZStack(alignment: .bottomTrailing) {
      Rectangle()
        .fill(hover ? Color.black.opacity(0.8) : Color.clear)
        .zIndex(1)
      KFImage.url(url).resizable().scaledToFit()
        .cornerRadius(!hover ? 5 : 0)
        .clipped()
        .frame(width: !hover ? 50 : frame[0], height: !hover ? 50 : frame[1], alignment: !hover ? .bottomTrailing : .center)
        .zIndex(10)
        .clipped()
        .shadow(color: Color.black.opacity(0.4), radius: !hover ? 2 : 0)
        .onHover { isHover in
          withAnimation(.linear(duration: 0.2)) { hover = isHover }
        }
      KFImage.url(url)
        .interpolation(.low)
        .renderingMode(.none)
        .placeholder {
          ProgressView()
        }
        .fade(duration: 0.25)
        .resizable()
        .scaledToFill()
        .frame(width: frame[0], height: frame[1])
        .clipped()
    }
    .frame(width: frame[0], height: frame[1])

    .overlay(alignment: .center) {
      if !hover {
        Button(action: {
          Task {
            wallpaperService.setDesktopImage(url: url)
          }
        }) {
          Text("Set Desktop Background")
            .bold()
            .plain(padding: [15, 10], font: .system(size: 12))
            .background(Color.black.opacity(0.6))
            .cornerRadius(10)
        }.buttonStyle(.borderless)
      }
    }
//    .onAppear {
//      print("appear")
//      imageView = KFImage.url(url)
//    }.onDisappear {
//      print("disappear")
//      imageView = nil
//    }
  }
}

struct LocalPictrueListView_Previews: PreviewProvider {
  static var previews: some View {
    LocalPictrueListView().frame(height: 1000)
  }
}
