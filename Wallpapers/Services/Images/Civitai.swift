//
//  Civitai.swift
//  Wallpapers
//
//  Created by 高子蒙 on 2023/9/18.
//

import Alamofire
import Foundation

struct CivitalResponse {
  
  struct Models {
    struct Result: Codable {
      let items: [Item]?
      let metadata: ResultMetadata?
    }
    
    // MARK: - Item
    struct Item: Codable {
      let id: Int?
      let name, description, type: String?
      let poi, nsfw, allowNoCredit: Bool?
      let allowCommercialUse: String?
      let allowDerivatives, allowDifferentLicense: Bool?
      let stats: ItemStats?
      let creator: Creator?
      let tags: [String]?
      let modelVersions: [ModelVersion]?
    }
    
    // MARK: - Creator
    struct Creator: Codable {
      let username: String?
      let image: String?
    }
    
    // MARK: - ModelVersion
    struct ModelVersion: Codable {
      let id, modelId: Int?
      let name, createdAt, updatedAt: String?
      let trainedWords: [String]?
      let baseModel: String?
      let earlyAccessTimeFrame: Int?
      let description: String?
      let stats: ModelVersionStats?
      let files: [File]?
      let images: [Image]?
      let downloadUrl: String?
    }
    
    // MARK: - File
    struct File: Codable {
      let name: String?
      let id: Int?
      let sizeKb: Double?
      let type: String?
      let metadata: FileMetadata?
      let pickleScanResult, pickleScanMessage, virusScanResult, scannedAt: String?
      let hashes: Hashes?
      let downloadUrl: String?
      let primary: Bool?
      
      enum CodingKeys: String, CodingKey {
        case name, id
        case sizeKb = "sizeKB"
        case type, metadata, pickleScanResult, pickleScanMessage, virusScanResult, scannedAt, hashes, downloadUrl, primary
      }
    }
    
    // MARK: - Hashes
    struct Hashes: Codable {
      let autoV2, sha256, crc32, blake3: String?
      
      enum CodingKeys: String, CodingKey {
        case autoV2 = "AutoV2"
        case sha256 = "SHA256"
        case crc32 = "CRC32"
        case blake3 = "BLAKE3"
      }
    }
    
    // MARK: - FileMetadata
    struct FileMetadata: Codable {
      let fp, size, format: String?
    }
    
    // MARK: - Image
    struct Image: Codable {
      let url: String?
      let nsfw: Bool?
      let width, height: Int?
      let hash: String?
      let meta: Meta?
    }
    
    // MARK: - Meta
    struct Meta: Codable {
      let ensd, size: String?
      let seed: Int?
      let score: String?
      let steps: Int?
      let prompt: String?
      let sampler: Sampler?
      let etaDdim: String?
      let cfgScale: Double?
      let resources: [Resource]?
      let modelHash, hiresUpscale: String?
      let hiresUpscaler: HiresUpscaler?
      let negativePrompt, denoisingStrength, clipSkip: String?
      let firstPassSize: FirstPassSize?
      let hiresSteps, maskBlur, model: String?
      
      enum CodingKeys: String, CodingKey {
        case ensd = "ENSD"
        case size = "Size"
        case seed
        case score = "Score"
        case steps, prompt, sampler
        case etaDdim = "Eta DDIM"
        case cfgScale, resources
        case modelHash = "Model hash"
        case hiresUpscale = "Hires upscale"
        case hiresUpscaler = "Hires upscaler"
        case negativePrompt
        case denoisingStrength = "Denoising strength"
        case clipSkip = "Clip skip"
        case firstPassSize = "First pass size"
        case hiresSteps = "Hires steps"
        case maskBlur = "Mask blur"
        case model = "Model"
      }
    }
    
    enum FirstPassSize: String, Codable {
      case the512X320 = "512x320"
      case the512X512 = "512x512"
      case the576X448 = "576x448"
    }
    
    enum HiresUpscaler: String, Codable {
      case latent = "Latent"
      case latentNearestExact = "Latent (nearest-exact)"
      case rEsrgan4X = "R-ESRGAN 4x+"
    }
    
    // MARK: - Resource
    struct Resource: Codable {
      let name, type: String?
      let weight: Double?
      let hash: String?
    }
    
    enum Sampler: String, Codable {
      case ddim = "DDIM"
      case dpm2MKarras = "DPM++ 2M Karras"
      case eulerA = "Euler a"
    }
    
    // MARK: - ModelVersionStats
    struct ModelVersionStats: Codable {
      let downloadCount, ratingCount: Int?
      let rating: Double?
    }
    
    // MARK: - ItemStats
    struct ItemStats: Codable {
      let downloadCount, favoriteCount, commentCount, ratingCount: Int?
      let rating: Double?
    }
    
    // MARK: - ResultMetadata
    struct ResultMetadata: Codable {
      let totalItems, currentPage, pageSize, totalPages: Int?
      let nextPage: String?
    }
  }
  // MARK: - Result

  struct Result: Codable {
    let items: [Item]
    let metadata: Metadata
  }
  
  // MARK: - Item

  struct Item: Codable {
    let id: Int
    let url: String
    let hash: String
    let width, height: Int?
    let nsfw: Bool?
    let nsfwLevel, createdAt: String?
    let postId: Int?
    let stats: Stats?
    let meta: Meta?
    let username: String?
  }
  
  // MARK: - Meta

  struct Meta: Codable {
    let size: String?
    let seed: Int?
    let model: String?
    let steps: Int?
    let prompt, sampler: String?
    let cfgScale: Double?
    let clipSkip, hiresUpscale, hiresUpscaler, negativePrompt: String?
    let denoisingStrength: String?
    
    enum CodingKeys: String, CodingKey {
      case size = "Size"
      case seed
      case model = "Model"
      case steps, prompt, sampler, cfgScale
      case clipSkip = "Clip skip"
      case hiresUpscale = "Hires upscale"
      case hiresUpscaler = "Hires upscaler"
      case negativePrompt
      case denoisingStrength = "Denoising strength"
    }
  }
  
  // MARK: - Stats

  struct Stats: Codable {
    let cryCount, laughCount, likeCount, dislikeCount: Int?
    let heartCount, commentCount: Int?
  }
  
  // MARK: - Metadata

  struct Metadata: Codable {
    let nextCursor: String?
    let nextPage: String?
  }
}

enum CivitalAPI {
  private static let baseURL = "https://civitai.com/api/v1"
  private static let headers = HTTPHeaders([])
  private static let server = Network(baseURL: baseURL, headers: headers)
  
  static func images(page: Int = 1) async throws -> CivitalResponse.Result {
    let parameters: [String: Any] = [
      "limit": 5,
//      "postId": 590764,
//      "modelId": modelId,
//      "modelVersionId": modelVersionId,
//      "username": username,
      "nsfw": "None", // None, Soft, Mature, X
      "sort": "Most Reactions", // Most Reactions, Most Comments, Newest
      "period": "Week", //  AllTime, Year, Month, Week, Day
      "page": page
    ]

    do {
      let result: CivitalResponse.Result = try await server.get(path: "/images", parameters: parameters)
      debugPrint(result)
      return result
    } catch {
      throw error
    }
  }
  
  static func tags(page: Int = 1, query: String = "fantasy") async throws -> CivitalResponse.Result {
    let parameters: [String: Any] = [
      "limit": 5,
      "query": query,
      "page": page
    ]
    
    do {
      let result: CivitalResponse.Result = try await server.get(path: "/tags", parameters: parameters)
      debugPrint(result)
      return result
    } catch {
      throw error
    }
  }
  
  static func models(page: Int = 1, tag: String = "fantasy") async throws -> CivitalResponse.Result {
    let parameters: [String: Any] = [
      "limit": 5,
      "tag": tag,
//      "types": "", //(Checkpoint, TextualInversion, Hypernetwork, AestheticGradient, LORA, Controlnet, Poses)
      "sort": "Highest Rated", //Highest Rated, Most Downloaded, Newest
      "page": page,
      "nsfw": false
    ]
    
    do {
      let result: CivitalResponse.Result = try await server.get(path: "/models", parameters: parameters)
      debugPrint(result)
      return result
    } catch {
      throw error
    }
  }
}
