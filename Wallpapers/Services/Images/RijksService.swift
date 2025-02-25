//
//  RijksService.swift
//  Wallpapers
//
//  Created by 高子蒙 on 2023/9/11.
//

import Alamofire

/// https://data.rijksmuseum.nl/object-metadata/api/ ///

struct RijksResult: Codable {
  let elapsedMilliseconds, count: Int
  let artObjects: [ArtObject]
}

// MARK: - ArtObject

struct ArtObject: Codable {
  let links: Links
  let id, objectNumber, title: String
  let hasImage: Bool
  let principalOrFirstMaker, longTitle: String
  let showImage, permitDownload: Bool
  let webImage, headerImage: ImageType
  let productionPlaces: [String]
}

// MARK: - Image

struct ImageType: Codable {
  let guid: String?
  let offsetPercentageX, offsetPercentageY, width, height: Int
  let url: String?
}

// MARK: - Links

struct Links: Codable {
  let linksSelf, web: String

  enum CodingKeys: String, CodingKey {
    case linksSelf = "self"
    case web
  }
}

enum Culture: String {
  case en
  case nl
}

enum Sort: String {
  case relevance // Sort results on relevance.
  case objecttype // Sort results on type.
  case chronologic // Sort results chronologically (oldest first).
  case achronologic // Sort results chronologically (newest first).
  case artist // Sort results on artist (a-z).
  case artistdesc // Sort results on artist (z-a).
}

struct RijksAPI: API {
  private static let key = Secret.rijks.apiKey

  private static let baseURL = "https://www.rijksmuseum.nl/api/\(Culture.en)"
  private static let headers = HTTPHeaders([])
  private static let server = Network(baseURL: baseURL, headers: headers)

  typealias SearchType = RijksResult
  static func search(page: Int = 1, query: String?) async throws -> RijksResult {
    let parameters: [String: Any] = [
      "key": key,
//      "involvedMaker": query ?? "Rembrandt van Rijn",
      //      "involvedMaker": "Johannes Vermeer",
      "ps": 20,
      "p": page,
      //      "f.normalized32Colors.hex": ""
      "imgonly": true,
      "toppieces": true,
      //      "ondisplay": true,
      "s": Sort.objecttype
    ]

    do {
      let result: RijksResult = try await server.get(path: "/collection", parameters: parameters)
      return result
    } catch {
      throw error
    }
  }
}
