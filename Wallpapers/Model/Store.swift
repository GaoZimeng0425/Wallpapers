//
//  File.swift
//  Wallpapers
//
//  Created by 高子蒙 on 2023/8/27.
//

import Combine
import SwiftUI

enum Suplier: String {
  case RijksMuseum = "Rijks Museum"
  case Unsplash
  case Pexels
  case Metropolitan = "The Metropolitan Museum"
  case Chicago = "The Art Institute of Chicago"
  case Civital
  var name: String { rawValue }
  
  var text: Text {
    Text(name)
  }
    
  var image: some View {
    switch self {
      case .Unsplash:
        return Image("Unsplash_Symbol").logo(size: 22, padding: 5)
      case .RijksMuseum:
        return Image("Rijks_museum").logo(size: 12, padding: 5)
      case .Metropolitan:
        return Image("Metropolitan_museum").logo(size: 28, padding: 2)
      case .Chicago:
        return Image("The-Art-Institute-of-Chicago").logo(size: 40)
      case .Civital:
        return Image("Civital").logo(size: 40)
      case .Pexels:
        return Image("Pexels-logo").logo(size: 22, padding: 5)
    }
  }
}

enum ServiceNames: String, CaseIterable {
  case Editorial
  case Rembrandt = "Rembrandt van Rijn"
  case Chicago = "The Art Institute of Chicago"
  case Met
  case Civital
  case Pexels
  case Space
  case Mountain
  case Architecture = "Architecture & Interiors"
  case Food = "Food & Drink"
  case Animals
  case Random
//  case Topic
  case Black_White = "Black & White"
  
  var name: String {
    rawValue
  }
  
  var supplier: Suplier {
    switch self {
      case .Animals, .Architecture, .Black_White, .Food, .Mountain, .Random, .Space, .Editorial:
        return Suplier.Unsplash
      case .Rembrandt:
        return Suplier.RijksMuseum
      case .Chicago:
        return Suplier.Chicago
      case .Civital:
        return Suplier.Civital
      case .Met:
        return Suplier.Metropolitan
      case .Pexels:
        return Suplier.Pexels
    }
  }
  
  var display: Image {
    switch self {
      case .Animals, .Architecture, .Black_White, .Food, .Mountain, .Random, .Rembrandt, .Editorial:
        return Image(name)
      case .Space:
        return Image("Space")
      case .Chicago:
        return Image("Chicago")
      case .Civital:
        return Image("CivitalPreview")
      case .Met:
        return Image("The Metropolitan Museum")
      case .Pexels:
        return Image("pexels")
    }
  }
  
  var service: (_ page: Int) async throws -> Any {
    switch self {
      case .Animals, .Architecture, .Black_White, .Food, .Mountain, .Space:
        return { (page: Int) in try await UnsplashAPI.search(page: page, query: name) }
      case .Rembrandt:
        return { (page: Int) in try await RijksAPI.search(page: page, query: name) }
      case .Editorial:
        return UnsplashAPI.photos
      case .Random:
        return UnsplashAPI.random
      case .Chicago:
//        return ChicagoAPI.artworks
        return ChicagoAPI.search
      case .Civital:
        return CivitalAPI.images
      case .Met:
        return MetAPI.images
      case .Pexels:
        return PexelsAPI.curated
    }
  }
}

struct StoreImages {
  var index: Int
  var list: [ImageViewProps]
}

class Store: ObservableObject {
  static let shared = Store()
  @AppStorage("isDark") private var AppStoreisDarkMode: Bool = NSApplication.shared.effectiveAppearance.name == NSAppearance.Name.darkAqua
  @AppStorage("service") private var AppStoreservice: ServiceNames = ServiceNames.allCases.first!
  
  @Published var totleSize: Int = 20
  @Published var images: StoreImages = .init(index: 1, list: [])
  func resetImage() {
    images = .init(index: 1, list: [])
  }
  
  @Published var service: ServiceNames = .Space {
    didSet {
      AppStoreservice = service
    }
  }
  
  @Published var isLogin = false
  @Published var isLoading: Bool = false
  
  @Published var isDarkMode: Bool = false {
    didSet {
      AppStoreisDarkMode = isDarkMode
      isDarkMode ? Appearance.setDarkAppearance() : Appearance.setLightAppearance()
    }
  }
  
  init() {
    service = AppStoreservice
    isDarkMode = AppStoreisDarkMode
  }
  
  func toggleDark() {
    isDarkMode = !isDarkMode
  }
}

struct Profile {
  var username: String
  var prefersNotifications = true
  var seasonalPhoto = Season.winter
  var goalDate = Date()
  
  static let `default` = Profile(username: "g_kumar")
  
  enum Season: String, CaseIterable, Identifiable {
    case spring = "🌷"
    case summer = "🌞"
    case autumn = "🍂"
    case winter = "☃️"
    
    var id: String { rawValue }
  }
}
