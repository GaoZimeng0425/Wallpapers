//
//  ContentView.swift
//  Wallpapers
//
//  Created by 高子蒙 on 2023/8/26.
//

import SwiftUI

enum MainPages {
  case setting
  case gallery
  case local
  case select
}

struct ContentView: View {
  @EnvironmentObject private var store: Store
  @State private var tabIndex: MainPages = .gallery
  @State var index = 0
  @State var apiLoading = false
  @State var canLoad = true

  private func search() {
    if apiLoading || !canLoad { return }
    apiLoading = true
    Task {
      do {
        let result = try await store.service.service(store.images.index)
        let list = ImageViewProps.adapt(result)
        if list.isEmpty {
          canLoad = false
        }
        store.images.list += list
      } catch {
        apiLoading = false
      }
      store.images.index += 1
      apiLoading = false
    }
  }

  @ViewBuilder
  func getTabView() -> some View {
    ZStack {
      ImageListView(imageInfos: store.images.list, action: search)
        .overlay(alignment: .bottom) {
          if apiLoading {
            ZStack {
              gradient
              ProgressView().padding(15)
            }.frame(height: 100)
          }
        }
        .environmentObject(store)
        .onAppear {
          search()
        }

      switch tabIndex {
      case .select:
        SelectView(service: store.service, onServiceChange: { service in
          if store.service != service { store.service = service }
          ImageService.cleanCache()
          withAnimation(.linear(duration: 0.2)) { tabIndex = .gallery }
        })
        .background(VisualEffectView())
        .zIndex(1000)
        .transition(.moveAndFade)
      case .setting:
        SettingsView()
          .background(VisualEffectView())
          .zIndex(1000)
          .transition(.moveAndFade)
      case .gallery:
        EmptyView()
      case .local:
        LocalPictrueListView()
          .background(VisualEffectView())
          .zIndex(1000)
          .transition(.moveAndFade)
      }
    }
//    .toast(isPresenting: $showToast) {
//       AlertToast(displayMode: .hud, type: .regular, title: "Message Sent!")
//      AlertToast(displayMode: .banner(.pop), type: .regular, title: "Message Sent!")
//    }
  }

  var body: some View {
    VStack(alignment: .center, spacing: 0) {
      Toolbar(tabIndex: $tabIndex)
        .frame(maxWidth: .infinity)
        .environmentObject(store)
      getTabView()
    }
    .onChange(of: store.service) {
      store.resetImage()
      canLoad = true
      search()
    }
    .overlay {
      if store.isLoading {
        ZStack(alignment: .center) {
          Color.black.opacity(0.3)
            .edgesIgnoringSafeArea(.all)
          ProgressView()
            .frame(width: 200, height: 200)
        }
      }
    }
  }
}

extension AnyTransition {
  static var moveAndFade: AnyTransition {
    .asymmetric(
      insertion: .move(edge: .trailing).combined(with: .opacity),
      removal: .move(edge: .trailing).combined(with: .opacity)
//      removal: .scale.combined(with: .opacity)
    )
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView().environmentObject(Store.shared)
  }
}
