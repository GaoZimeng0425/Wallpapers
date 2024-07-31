//
//  Chicago.swift
//  Wallpapers
//
//  Created by 高子蒙 on 2023/9/18.
//

import Alamofire
import AppKit

struct ChicagoResponse {
  // MARK: - Result

  struct Result: Codable {
    let pagination: Pagination?
    let data: [Datum]
    let info: Info
    let config: Config
  }

  // MARK: - Config

  struct Config: Codable {
    let iiifUrl: String?
    let websiteUrl: String?

    enum CodingKeys: String, CodingKey {
      case iiifUrl = "iiif_url"
      case websiteUrl = "website_url"
    }
  }

  // MARK: - Datum

  struct Datum: Codable {
    let id: Int?
    let apiModel: String?
    let apiLink: String?
    let isBoosted: Bool?
    let title: String?
    let altTitles: JSONAny?
    let thumbnail: Thumbnail?
    let mainReferenceNumber: String?
    let hasNotBeenViewedMuch: Bool?
    let boostRank: JSONAny?
    let dateStart, dateEnd: Int?
    let dateDisplay, dateQualifierTitle: String?
    let dateQualifierId: JSONAny?
    let artistDisplay, placeOfOrigin, description, dimensions: String?
    let dimensionsDetail: [DimensionsDetail]?
    let mediumDisplay, inscriptions, creditLine: String?
    let catalogueDisplay: JSONAny?
    let publicationHistory, exhibitionHistory, provenanceText: String?
    let edition: JSONAny?
    let publishingVerificationLevel: String?
    let internalDepartmentId, fiscalYear: Int?
    let fiscalYearDeaccession: JSONAny?
    let isPublicDomain, isZoomable: Bool?
    let maxZoomWindowSize: Int?
    let copyrightNotice: JSONAny?
    let hasMultimediaResources, hasEducationalResources, hasAdvancedImaging: Bool?
    let colorfulness: Double?
    let color: Color?
    let latitude, longitude: Double?
    let latlon: String?
    let isOnView: Bool?
    let onLoanDisplay: String?
    let galleryTitle, galleryId, nomismaId: JSONAny?
    let artworkTypeTitle: String?
    let artworkTypeId: Int?
    let departmentTitle, departmentId: String?
    let artistId: Int?
    let artistTitle: String?
    let altArtistIds: [JSONAny]?
    let artistIds: [Int]?
    let artistTitles, categoryIds, categoryTitles, termTitles: [String]?
    let styleId, styleTitle: String?
    let altStyleIds: [JSONAny]?
    let styleIds, styleTitles: [String]?
    let classificationId, classificationTitle: String?
    let altClassificationIds, classificationIds, classificationTitles: [String]?
    let subjectId: String?
    let altSubjectIds, subjectIds, subjectTitles: [String]?
    let materialId: String?
    let altMaterialIds, materialIds, materialTitles: [String]?
    let techniqueId: String?
    let altTechniqueIds, techniqueIds, techniqueTitles, themeTitles: [String]?
    let imageId: String?
    let altImageIds: [JSONAny]?
    let documentIds, soundIds: [String]?
    let videoIds, textIds, sectionIds, sectionTitles: [JSONAny]?
    let siteIds: [JSONAny]?
    let suggestAutocompleteBoosted: String?
    let suggestAutocompleteAll: [SuggestAutocompleteAll]?
    let sourceUpdatedAt, updatedAt, timestamp: String?

    enum CodingKeys: String, CodingKey {
      case id
      case apiModel = "api_model"
      case apiLink = "api_link"
      case isBoosted = "is_boosted"
      case title
      case altTitles = "alt_titles"
      case thumbnail
      case mainReferenceNumber = "main_reference_number"
      case hasNotBeenViewedMuch = "has_not_been_viewed_much"
      case boostRank = "boost_rank"
      case dateStart = "date_start"
      case dateEnd = "date_end"
      case dateDisplay = "date_display"
      case dateQualifierTitle = "date_qualifier_title"
      case dateQualifierId = "date_qualifier_id"
      case artistDisplay = "artist_display"
      case placeOfOrigin = "place_of_origin"
      case description, dimensions
      case dimensionsDetail = "dimensions_detail"
      case mediumDisplay = "medium_display"
      case inscriptions
      case creditLine = "credit_line"
      case catalogueDisplay = "catalogue_display"
      case publicationHistory = "publication_history"
      case exhibitionHistory = "exhibition_history"
      case provenanceText = "provenance_text"
      case edition
      case publishingVerificationLevel = "publishing_verification_level"
      case internalDepartmentId = "internal_department_id"
      case fiscalYear = "fiscal_year"
      case fiscalYearDeaccession = "fiscal_year_deaccession"
      case isPublicDomain = "is_public_domain"
      case isZoomable = "is_zoomable"
      case maxZoomWindowSize = "max_zoom_window_size"
      case copyrightNotice = "copyright_notice"
      case hasMultimediaResources = "has_multimedia_resources"
      case hasEducationalResources = "has_educational_resources"
      case hasAdvancedImaging = "has_advanced_imaging"
      case colorfulness, color, latitude, longitude, latlon
      case isOnView = "is_on_view"
      case onLoanDisplay = "on_loan_display"
      case galleryTitle = "gallery_title"
      case galleryId = "gallery_id"
      case nomismaId = "nomisma_id"
      case artworkTypeTitle = "artwork_type_title"
      case artworkTypeId = "artwork_type_id"
      case departmentTitle = "department_title"
      case departmentId = "department_id"
      case artistId = "artist_id"
      case artistTitle = "artist_title"
      case altArtistIds = "alt_artist_ids"
      case artistIds = "artist_ids"
      case artistTitles = "artist_titles"
      case categoryIds = "category_ids"
      case categoryTitles = "category_titles"
      case termTitles = "term_titles"
      case styleId = "style_id"
      case styleTitle = "style_title"
      case altStyleIds = "alt_style_ids"
      case styleIds = "style_ids"
      case styleTitles = "style_titles"
      case classificationId = "classification_id"
      case classificationTitle = "classification_title"
      case altClassificationIds = "alt_classification_ids"
      case classificationIds = "classification_ids"
      case classificationTitles = "classification_titles"
      case subjectId = "subject_id"
      case altSubjectIds = "alt_subject_ids"
      case subjectIds = "subject_ids"
      case subjectTitles = "subject_titles"
      case materialId = "material_id"
      case altMaterialIds = "alt_material_ids"
      case materialIds = "material_ids"
      case materialTitles = "material_titles"
      case techniqueId = "technique_id"
      case altTechniqueIds = "alt_technique_ids"
      case techniqueIds = "technique_ids"
      case techniqueTitles = "technique_titles"
      case themeTitles = "theme_titles"
      case imageId = "image_id"
      case altImageIds = "alt_image_ids"
      case documentIds = "document_ids"
      case soundIds = "sound_ids"
      case videoIds = "video_ids"
      case textIds = "text_ids"
      case sectionIds = "section_ids"
      case sectionTitles = "section_titles"
      case siteIds = "site_ids"
      case suggestAutocompleteBoosted = "suggest_autocomplete_boosted"
      case suggestAutocompleteAll = "suggest_autocomplete_all"
      case sourceUpdatedAt = "source_updated_at"
      case updatedAt = "updated_at"
      case timestamp
    }
  }

  // MARK: - Color

  struct Color: Codable {
    let h, l, s: Int?
    let percentage: Double?
    let population: Int?
  }

  // MARK: - DimensionsDetail

  struct DimensionsDetail: Codable {
    let depthCm, depthIn: Double?
    let widthCm, widthIn, heightCm, heightIn: Double?
    let diameterCm, diameterIn: Double?
    let clarification: JSONAny?

    enum CodingKeys: String, CodingKey {
      case depthCm = "depth_cm"
      case depthIn = "depth_in"
      case widthCm = "width_cm"
      case widthIn = "width_in"
      case heightCm = "height_cm"
      case heightIn = "height_in"
      case diameterCm = "diameter_cm"
      case diameterIn = "diameter_in"
      case clarification
    }
  }

  // MARK: - SuggestAutocompleteAll

  struct SuggestAutocompleteAll: Codable {
    let input: [String]?
    let contexts: Contexts?
    let weight: Int?
  }

  // MARK: - Contexts

  struct Contexts: Codable {
    let groupings: [String]?
  }

  // MARK: - Thumbnail

  struct Thumbnail: Codable {
    let lqip: String?
    let width, height: Int?
    let altText: String?

    enum CodingKeys: String, CodingKey {
      case lqip, width, height
      case altText = "alt_text"
    }
  }

  // MARK: - Info

  struct Info: Codable {
    let licenseText: String?
    let licenseLinks: [String]?
    let version: String?

    enum CodingKeys: String, CodingKey {
      case licenseText = "license_text"
      case licenseLinks = "license_links"
      case version
    }
  }

  // MARK: - Pagination

  struct Pagination: Codable {
    let total, limit, offset, totalPages: Int?
    let currentPage: Int?
    let nextUrl: String?

    enum CodingKeys: String, CodingKey {
      case total, limit, offset
      case totalPages = "total_pages"
      case currentPage = "current_page"
      case nextUrl = "next_url"
    }
  }
}

// https://www.artic.edu/open-access/public-api
struct ChicagoAPI: API {
  private static let baseURL = "https://api.artic.edu/api/v1"
  private static let headers = HTTPHeaders([])
  private static let server = Network(baseURL: baseURL, headers: headers)

  static func displayImageUrl(id: String) -> String {
    "https://www.artic.edu/iiif/2/\(id)/full/600,/0/default.jpg"
  }

  static func downloadImageUrl(id: String) -> String {
    "https://www.artic.edu/iiif/2/\(id)/full/full/0/default.jpg"
  }

  static func search(page: Int = 1) async throws -> ChicagoResponse.Result {
    let parameters: [String: Any] = [
      "page": page,
      "limit": 5,
      "q": "Painting and Sculpture of Europe",
//      "q": "modern and contemporary art",
//      "q": "oil on canvas",
      "fields": "id,title,image_id,thumbnail,artist_title",
//      "query": ["term": ["is_public_domain": true]]
//      "query[term][is_public_domain]": true
    ]

    do {
      let result: ChicagoResponse.Result = try await server.get(path: "/artworks/search", parameters: parameters)
      return result
    } catch {
      throw error
    }
  }

  static func artworks(page: Int = 1) async throws -> ChicagoResponse.Result {
    let parameters: [String: Any] = [
      "page": page,
      "limit": 5
    ]

    do {
      let result: ChicagoResponse.Result = try await server.get(path: "/artworks", parameters: parameters)
      return result
    } catch {
      throw error
    }
  }

  typealias SearchType = RijksResult
  static func search(page: Int = 1, query: String?) async throws -> RijksResult {
    let parameters: [String: Any] = [
      "key": "pfBA8zuf",
      "involvedMaker": query ?? "Rembrandt van Rijn",
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
