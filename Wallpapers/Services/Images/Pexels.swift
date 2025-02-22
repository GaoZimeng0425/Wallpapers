//
//  Pexels.swift
//  Wallpapers
//
//  Created by 高子蒙 on 2023/9/8.
//

import Alamofire

public enum PexelsAPI {
  enum Response {
    struct Image: Codable {
      let id: Int
      let width, height: Int?
      let url: String?
      let photographer: String?
      let photographerUrl: String?
      let photographerId: Int?
      let avgColor: String?
      let src: Src
    }

    struct Src: Codable {
      let original, large2X, large, medium: String?
      let small, portrait, landscape, tiny: String?
    }

    struct Result: Codable {
      let page: Int
      let per_page: Int
      let photos: [Image]
    }
  }

  private static let baseURL = "https://api.pexels.com/v1/"
  private static let headers = HTTPHeaders([
    HTTPHeader(name: "Accept", value: "application/json"),
    HTTPHeader(name: "Content-Type", value: "application/json"),
    HTTPHeader(name: "Authorization", value: Secret.pexels.apiKey)
  ])
  private static let server = Network(baseURL: baseURL, headers: headers)

  static func curated(page: Int = 1) async throws -> Response.Result {
    let parameters: [String: Any] = [
      "per_page": 5,
      "page": page
    ]
    do {
      let result: Response.Result = try await server.get(path: "/curated", parameters: parameters)
      return result
    } catch {
      throw error
    }
  }
}
