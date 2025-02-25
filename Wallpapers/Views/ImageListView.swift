//
//  ImageListView.swift
//  Wallpapers
//
//  Created by 高子蒙 on 2023/8/27.
//

import Kingfisher
import SwiftUI
import UnifiedBlurHash

struct ImageListView: View {
  @EnvironmentObject private var store: Store
  @State var percentage: Float = 0.0
  @State var memorySize: Int = 0
  @State var setLoading = false
  @State var currentImage: ImageViewProps? = nil

  let imageInfos: [ImageViewProps]
  var action: (() -> Void)?

  @State private var hoverIndex: Int = -1
  @State private var scrollY: CGFloat = 0

  private func downloadAndsetDesktopImage(url: URL) async {
    do {
      let path = try await ImageService.downloadAsync(url: url, progress: { percentage, memorySize in
        withAnimation(.linear(duration: 0)) {
          self.memorySize = memorySize
          self.percentage = percentage
        }
      })
      wallpaperService.setDesktopImage(url: path)
      try await Task.sleep(nanoseconds: 1_000_000_000)
    } catch {}
  }

  private func onSetDesktopButtonClick(image: ImageViewProps) async {
    guard let path = image.urls.downloadUrl ?? image.urls.displayUrl else { return }
    setLoading = true
    await downloadAndsetDesktopImage(url: path)
    setLoading = false
    percentage = 0
    memorySize = 0
  }

  var gradient = LinearGradient.linearGradient(
    Gradient(colors: [.black.opacity(0.8), .black.opacity(0.65), .black.opacity(0)]),
    startPoint: .bottom,
    endPoint: .top
  )

  @ViewBuilder
  func ImageDownloading() -> some View {
    if let url = currentImage?.urls.displayUrl {
      KFImage.url(url)
        .resizable()
        .scaledToFill()
    } else {
      Text("Setting Desktop Background").padding(.vertical, 10).padding(.horizontal, 15)
    }
  }

  var body: some View {
    InfinityScroll(action: { _ in
      if store.isLoading { return }
      action?()
    }, onScrollChange: { y in
      scrollY = y
    }) { geometry in
      VStack(alignment: .center, spacing: 0) {
        ForEach(Array(imageInfos.enumerated()), id: \.offset) { index, image in
          let opacity = hoverIndex == index ? 1.0 : 0.0
          ImageItemView(info: image, frame: [geometry.size.width, geometry.size.width * Constants.scale])
            .id(index)
            .clipped()
            .contentShape(.rect)
            .onHover { isHovering in
              if isHovering == true {
                hoverIndex = index
              }
            }
            .overlay(alignment: .bottomLeading) {
              VStack(alignment: .leading, spacing: 5) {
                if image.title?.isEmpty == false {
                  Button {
                    if let url = URL(string: image.imageLink ?? "") {
                      NSWorkspace.shared.open(url)
                    }
                  } label: {
                    Text(image.title!)
                      .markerText(isDarkMode: store.isDarkMode)
                      .opacity(0.8)
                  }
                  .frame(maxWidth: 20 * 10, alignment: .leading)
                  .hoverPoint()
                  .buttonStyle(.plain)
                }
                if image.author.isEmpty == false {
                  Button {
                    if let url = URL(string: image.userLink ?? "") {
                      NSWorkspace.shared.open(url)
                    }
                  } label: {
                    Text("By \(image.author)")
                      .bold()
                      .markerText(isDarkMode: store.isDarkMode)
                      .opacity(0.8)
                  }
                  .hoverPoint()
                  .buttonStyle(.plain)
                }
              }
              .offset(x: 20, y: -20)
            }
            .overlay(alignment: .topTrailing) {
              let resolution = image.resolution
              if let title = resolution.string() {
                Text(title).markerText()
                  .foregroundColor(resolution.color())
                  .opacity(opacity)
                  .offset(x: -20, y: 20)
              }
            }
            .overlay(alignment: .center) {
              Button {
                Task {
                  currentImage = image
                  await onSetDesktopButtonClick(image: image)
                  currentImage = nil
                }
              } label: {
                Text("Set Desktop Background")
                  .bold()
                  .plain(padding: [15, 10], font: .system(size: 12))
                  .background(.ultraThinMaterial.opacity(0.8), in: .rect(cornerRadius: 10))
                  .opacity(opacity)
              }
              .hoverPoint()
              .buttonStyle(.plain)
            }
        }
      }
    }.onHover { isHovering in
      if isHovering == false {
        hoverIndex = -1
      }
    }.overlay(alignment: .bottom) {
      if setLoading {
        ZStack {
          gradient
          HStack(alignment: .center, spacing: 20) {
            Loading(radius: 15, duration: 2) {
              ImageDownloading().frame(width: 150, height: 150 * Constants.scale).cornerRadius(15).clipped()
            }.padding(20)
            Spacer()
            if memorySize != 0 {
              Text(memorySize.bytesToMegabytes()).font(.title3).bold()
            }
          }.padding(20)
        }.frame(height: 150, alignment: .center)
      }
    }.overlay(alignment: .bottom) {
      if setLoading {
        ZStack {
          ProgressView(value: percentage, total: 100.0)
        }.padding(10)
      }
    }
  }
}

struct ImageItemView: View {
  let info: ImageViewProps
  let frame: [CGFloat]

  var bgColor: Color {
    guard let bg = info.color else { return Color.gray }
    return Color(hex: bg)
  }

  func base64Image(base64: String) -> Image {
    if let data = Data(base64Encoded: base64),
       let nsImage = NSImage(data: data)
    {
      return Image(nsImage: nsImage)
    } else {
      return Image("Chicago")
    }
  }

  var body: some View {
    LazyVStack {
      KFImage.url(info.urls.displayUrl)
        .fade(duration: 0.2)
        .placeholder {
          if let base64 = info.base64 {
            base64Image(base64: base64)
              .resizable()
          } else if let blurhash = info.blur_hash {
            Image(blurHash: blurhash)?
              .resizable()
          } else {
            ZStack {
              bgColor.opacity(0.4)
              ProgressView()
                .progressViewStyle(.circular)
            }
          }
        }
        .resizable()
        .scaledToFill()
        .frame(width: frame[0], height: frame[1])
    }
  }
}

let jsonData = """
{
  "total": 133,
  "total_pages": 7,
  "results": [
{
  "id": "eOLpJytrbsQ",
  "created_at": "2014-11-18T14:35:36-05:00",
  "width": 4000,
  "height": 3000,
  "color": "#A7A2A1",
  "blur_hash": "LaLXMa9Fx[D%~q%MtQM|kDRjtRIU",
  "likes": 286,
  "liked_by_user": false,
  "description": "A man drinking a coffee.",
  "user": {
    "id": "Ul0QVz12Goo",
    "username": "ugmonk",
    "name": "Jeff Sheldon",
    "first_name": "Jeff",
    "last_name": "Sheldon",
    "instagram_username": "instantgrammer",
    "twitter_username": "ugmonk",
    "portfolio_url": "http://ugmonk.com/",
    "profile_image": {
      "small": "https://images.unsplash.com/profile-1441298803695-accd94000cac?ixlib=rb-0.3.5&q=80&fm=jpg&crop=faces&cs=tinysrgb&fit=crop&h=32&w=32&s=7cfe3b93750cb0c93e2f7caec08b5a41",
      "medium": "https://images.unsplash.com/profile-1441298803695-accd94000cac?ixlib=rb-0.3.5&q=80&fm=jpg&crop=faces&cs=tinysrgb&fit=crop&h=64&w=64&s=5a9dc749c43ce5bd60870b129a40902f",
      "large": "https://images.unsplash.com/profile-1441298803695-accd94000cac?ixlib=rb-0.3.5&q=80&fm=jpg&crop=faces&cs=tinysrgb&fit=crop&h=128&w=128&s=32085a077889586df88bfbe406692202"
    },
    "links": {
      "self": "https://api.unsplash.com/users/ugmonk",
      "html": "http://unsplash.com/@ugmonk",
      "photos": "https://api.unsplash.com/users/ugmonk/photos",
      "likes": "https://api.unsplash.com/users/ugmonk/likes"
    }
  },
  "current_user_collections": [],
  "urls": {
    "raw": "https://images.unsplash.com/photo-1416339306562-f3d12fefd36f",
    "full": "https://images.unsplash.com/photo-1694682845789-56788fccf4dc?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxlZGl0b3JpYWwtZmVlZHw0fHx8ZW58MHx8fHx8&auto=format&fit=crop&w=800&q=60",
    "regular": "https://images.unsplash.com/photo-1416339306562-f3d12fefd36f?ixlib=rb-0.3.5&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=1080&fit=max&s=92f3e02f63678acc8416d044e189f515",
    "small": "https://images.unsplash.com/photo-1694682845789-56788fccf4dc?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxlZGl0b3JpYWwtZmVlZHw0fHx8ZW58MHx8fHx8&auto=format&fit=crop&w=800&q=60",
    "thumb": "https://images.unsplash.com/photo-1416339306562-f3d12fefd36f?ixlib=rb-0.3.5&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=200&fit=max&s=8aae34cf35df31a592f0bef16e6342ef"
  },
  "links": {
    "self": "https://api.unsplash.com/photos/eOLpJytrbsQ",
    "html": "http://unsplash.com/photos/eOLpJytrbsQ",
    "download": "http://unsplash.com/photos/eOLpJytrbsQ/download"
  }
}
  ]
}
""".data(using: .utf8)!

let decoder = JSONDecoder()
let obj = try! decoder.decode(UnsplashResult.self, from: jsonData)
struct ImageListView_Previews: PreviewProvider {
  static var previews: some View {
    ImageListView(imageInfos: ImageViewProps.adapt(obj))
      .environmentObject(Store.shared)
  }
}
