//
//  LocalPictrueListView.swift
//  Wallpapers
//
//  Created by 高子蒙 on 2023/9/10.
//

import Kingfisher
import QuickLook
import QuickLookThumbnailing
import SwiftUI

struct LocalPictureListView: View {
  fileprivate func OpenButton() -> some View {
    Button(action: {
      DownloadService.openDownloadPictureDirectory()
    }) {
      HStack {
        Image(systemName: "opticaldiscdrive")
          .IconStyle()
        Text("Open Directory")
          .font(.system(size: 12))
      }
      .padding(.vertical, 10)
      .frame(maxWidth: .infinity)
      .contentShape(Rectangle())
    }
    .buttonStyle(.plain)
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
      }
      .frame(maxWidth: .infinity)
    }
  }
}

extension URL {
  func snapshotPreview() -> NSImage {
    if let preview = QLThumbnailImageCreate(
      kCFAllocatorDefault,
      self as CFURL,
      CGSize(width: 64, height: 64),
      nil
    )?.takeRetainedValue() {
      return NSImage(cgImage: preview, size: .zero)
    }
    return NSWorkspace.shared.icon(forFile: path)
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
//      KFImage.url(url).resizable().scaledToFit()
//        .cornerRadius(!hover ? 5 : 0)
//        .clipped()
//        .frame(width: !hover ? 50 : frame[0], height: !hover ? 50 : frame[1], alignment: !hover ? .bottomTrailing : .center)
//        .zIndex(10)
//        .clipped()
//        .shadow(color: Color.black.opacity(0.4), radius: !hover ? 2 : 0)
//        .onHover { isHover in
//          withAnimation(.linear(duration: 0.2)) { hover = isHover }
//        }
//      KFImage.url(url)
//        .resizable()
//        .frame(width: frame[0], height: frame[1])
//        .scaledToFill()
//        .clipped()
      ThumbnailingView(url: url, width: frame[0], height: frame[1]) { nsImage in
        Image(nsImage: nsImage)
          .resizable()
          .frame(width: frame[0], height: frame[1])
          .aspectRatio(contentMode: .fill)
          .clipped()
      }
    }
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
  }
}

struct ThumbnailingView<Content>: View where Content: View {
  var url: URL?
  var width: CGFloat?
  var height: CGFloat?
  @ViewBuilder var content: (NSImage) -> Content
  @State private var previewVisible: Bool = false
  @State private var image: NSImage?

  func snapshotPreview() async -> NSImage {
    guard let url else { return NSImage() }

    let size = CGSize(width: width ?? 64, height: height ?? 64)
    let scale = NSScreen.main?.backingScaleFactor ?? 2.0
    let request = QLThumbnailGenerator.Request(fileAt: url, size: size, scale: scale, representationTypes: .thumbnail)

    do {
      let thumbnail = try await QLThumbnailGenerator.shared.generateBestRepresentation(for: request)
      let thumbnailSize = NSSize(width: thumbnail.cgImage.width, height: thumbnail.cgImage.height)
      return NSImage(cgImage: thumbnail.cgImage, size: thumbnailSize)
    } catch {
      return NSWorkspace.shared.icon(forFile: url.path)
    }
  }

  var body: some View {
    if image != nil {
      content(image!)
    } else {
      ProgressView()
        .onAppear {
          Task {
            self.image = await snapshotPreview()
          }
        }
    }
  }
}

struct LocalPictrueListView_Previews: PreviewProvider {
  static var previews: some View {
    LocalPictureListView().frame(height: 1000)
  }
}
