//
//  Met.swift
//  Wallpapers
//
//  Created by 高子蒙 on 2023/9/22.
//

import Alamofire
import Foundation

enum Met {
  struct Search: Codable {
    let total: Int
    let objectIDs: [Int]
  }

  // MARK: - Result

  struct Result: Codable {
    let objectID: Int
    let isHighlight: Bool?
    let accessionNumber, accessionYear: String?
    let isPublicDomain: Bool?
    let primaryImage, primaryImageSmall: String?
//    let additionalImages: []?
    let constituents: [Constituent]?
    let department, objectName, title, culture: String?
    let period, dynasty, reign, portfolio: String?
    let artistRole, artistPrefix, artistDisplayName, artistDisplayBio: String?
    let artistSuffix, artistAlphaSort, artistNationality, artistBeginDate: String?
    let artistEndDate, artistGender: String?
    let artistWikidataUrl: String?
    let artistUlanUrl: String?
    let objectDate: String?
    let objectBeginDate, objectEndDate: Int?
    let medium, dimensions: String?
    let creditLine, geographyType, city, state: String?
    let county, country, region, subregion: String?
    let locale, locus, excavation, river: String?
    let classification, rightsAndReproduction, linkResource, metadataDate: String?
    let repository: String?
    let objectUrl: String?
    let isTimelineWork: Bool?
    let galleryNumber: String?
  }

  // MARK: - Constituent

  struct Constituent: Codable {
    let constituentId: Int?
    let role, name: String?
    let constituentUlanUrl: String?
    let constituentWikidataUrl: String?
    let gender: String?
  }
}

// https://metmuseum.github.io/#search

enum MetAPI {
  private static var searchResult: Met.Search {
    let result: Met.Search = load("met.json")
    return result
  }

  private static let baseURL = "https://collectionapi.metmuseum.org/public/collection/v1"
  private static let headers = HTTPHeaders([])
  private static let server = Network(baseURL: baseURL, headers: headers)

  static func objects() async throws -> Met.Search {
    let parameters: [String: Any] = [
      "departmentIds": 11,
    ]

    do {
      let result: Met.Search = try await server.get(path: "/search", parameters: parameters)
      return result
    } catch {
      throw error
    }
  }

  static func images(page: Int) async throws -> [Met.Result] {
    let IDS = searchResult.objectIDs
    let limit = 5
    let start = max((page - 1) * limit, 0)
    if IDS.count < start { return [] }
    let end = min(page * limit, IDS.count - 1)
    return try await images(ids: Array(IDS[start ..< end]))
  }

  static func images(ids: [Int]) async throws -> [Met.Result] {
    var images: [Met.Result] = []
    await withTaskGroup(of: [Met.Result].self) { group in
      for id in ids {
        group.addTask {
          do {
            let result = try await object(id: id)
            return [result]
          } catch {
            return []
          }
        }
      }
      for await result in group {
        images = images + result
      }
    }
    return images
  }

  static func object(id: Int) async throws -> Met.Result {
    do {
      let result: Met.Result = try await server.get(path: "/objects/\(id)")
      return result
    } catch {
      throw error
    }
  }

  static func search(page: Int = 1) async throws -> Met.Search {
    let parameters: [String: Any] = [
      "q": "Painting",
      "hasImages": true,
      "departmentId": 11,
      "medium": "Paintings",
      "dateBegin": 1600,
      "dateEnd": 1900,
    ]

    do {
      let result: Met.Search = try await server.get(path: "/search", parameters: parameters)
      return result
    } catch {
      throw error
    }
  }
}
