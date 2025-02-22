//
//  unsplash.swift
//  Wallpapers
//
//  Created by 高子蒙 on 2023/8/30.
//

import Alamofire

struct Location: Codable {
  let name, city, country: String?
  let position: Position?
}

// MARK: - Position

struct Position: Codable {
  let latitude, longitude: Double?
}

struct Random: Codable {
  let id: String
  let created_at: String
  let height, width: Int
  let color, blur_hash: String?
  let current_user_collections: [UserCollections]
  let user: User
  let urls: ImageURL?
  let description: String?
  let likes: Int
  let location: Location?
}

struct ImageURL: Codable {
  let raw, full, regular, small, thumb: String
}

struct User: Codable {
  let id, username, name: String
  let portfolio_url, bio, location: String?
}

struct UserCollections: Codable {
  let id: Int
  let title, published_at, updated_at: String
  let cover_photo, user: String?
}

struct PhotosRespose: Codable {
  let id: String
  let created_at: String
  let height, width: Int
  let color, blur_hash: String?
  let current_user_collections: [UserCollections]
  let user: User
  let urls: ImageURL?
  let description: String?
  let likes: Int
}

struct UnsplashResult: Codable {
  let total, total_pages: Int
  let results: [PhotosRespose]
}

struct Download: Codable {
  let url: String
}

private let DefaultParameters: [String: Any] = [
  "per_page": 5,
  "page": 1,
  "order_by": "latest"
]

protocol API {
  associatedtype SearchType
  static func search(page: Int, query: String?) async throws -> SearchType
}

struct UnsplashAPI: API {
  private static let baseURL = "https://api.unsplash.com/"
  private static let headers = HTTPHeaders([
    HTTPHeader(name: "Accept-Version", value: "v1"),
    HTTPHeader(name: "Authorization", value: "Client-ID \(Secret.unsplash.accessKey)"),
  ])

  private static func mergeParameters(parameters: inout [String: Any]) {
    parameters.merge(DefaultParameters, uniquingKeysWith: { k1, _ in k1 })
  }

  private static let server = Network(baseURL: baseURL, headers: UnsplashAPI.headers)

  static func topics(page: Int = 1) async throws -> [PhotosRespose] {
    var parameters: [String: Any] = ["ids": "", "page": page, "order_by": "featured"] // featured, latest, oldest, position
    mergeParameters(parameters: &parameters)

    do {
      let result: [PhotosRespose] = try await server.get(path: "/topics", parameters: parameters)
      return result
    } catch {
      throw error
    }
  }

  typealias SearchType = UnsplashResult
  static func search(page: Int = 1, query: String?) async throws -> UnsplashResult {
    var parameters: [String: Any] = ["query": query ?? "universe", "page": page, "order_by": "relevant"]
    parameters.merge(DefaultParameters, uniquingKeysWith: { k1, _ in k1 })

    do {
      let result: UnsplashResult = try await Self.server.get(path: "/search/photos", parameters: parameters)
      return result
    } catch {
      throw error
    }
  }

  static func photos(page: Int = 1) async throws -> [PhotosRespose] {
    var parameters: [String: Any] = ["query": "Universe", "page": page, "order_by": "popular"] // latest, oldest, popular
    parameters.merge(DefaultParameters, uniquingKeysWith: { k1, _ in k1 })

    do {
      let result: [PhotosRespose] = try await server.get(path: "/photos", parameters: parameters)
      return result
    } catch {
      throw error
    }
  }

  static func random(page: Int = 1) async throws -> [Random] {
    let parameters: [String: Any] = [
      "collections": "",
      "topics": "",
      "username": "",
      "orientation": "landscape", // landscape, portrait, squarish
      "content_filter": "low", // low, high
//      "query": "universe",
      "count": "5" // 1 - 30
    ]

    do {
      let result: [Random] = try await server.get(path: "/photos/random", parameters: parameters)
      return result
    } catch {
      throw error
    }
  }
  
  static func collections(page: Int) async throws -> [Random] {
    var parameters: [String: Any] = ["id": "16398438", "page": page, "per_page": 5, "orientation": "portrait"] // landscape, portrait, squarish
    parameters.merge(DefaultParameters, uniquingKeysWith: { k1, _ in k1 })
    do {
      let result: [Random] = try await server.get(path: "/collections/16398438/photos", parameters: parameters)
      return result
    } catch {
      throw error
    }
    
  }

  static func download(id: String) async throws -> Download {
    let dataTask = AF.request("\(baseURL)/photos/\(id)/download", method: .get, headers: headers).serializingDecodable(
      Download.self
    )
    //    let response = await dataTask.response // Returns full DataResponse<TestResponse, AFError>
    let result = await dataTask.result // Returns Result<TestResponse, AFError>
    switch result {
      case .success(let data):
        return data
      case .failure(let error):
        throw error
    }
  }
}
