//
//  ImageType.swift
//  Wallpapers
//
//  Created by 高子蒙 on 2023/9/12.
//

import Foundation

struct UserLinks: Codable {
  let selfLink, html, photos, likes: String

  enum CodingKeys: String, CodingKey {
    case selfLink = "self"
    case html, photos, likes
  }
}

struct User: Codable {
  let id, username, name: String
  let portfolio_url, bio, location: String?
  let links: UserLinks
}

struct ImageViewURL: Codable {
  let display, download: String
  var displayUrl: URL? {
    URL(string: display)
  }

  var downloadUrl: URL? {
    URL(string: download)
  }
}

struct ImageViewProps: Codable, Identifiable, Hashable {
  let id: String
  let height, width: Int?
  let urls: ImageViewURL

  var resolution: ImageResolution {
    ImageResolution.getImageResolution(width: width ?? 0, height: height ?? 0)
  }

  let title: String?
  let location: Location?
  let color: String?
  let blur_hash: String?
  let base64: String?
  let author: String
  let user: User?
  let userLink: String?
  let imageLink: String?

  func hashValue() -> String {
    id
  }
}

extension ImageViewProps {
  func hash(into hasher: inout Hasher) {
    hasher.combine(id)
    hasher.combine(urls.download)
  }

  static func == (lhs: ImageViewProps, rhs: ImageViewProps) -> Bool {
    lhs.id == rhs.id
  }

  static func adapt<T>(_ object: T) -> [ImageViewProps] {
    switch object {
    case let result as UnsplashResult:
      return result.results.map { adaptItem(result: $0) }
    case let result as [PhotosRespose]:
      return result.map { adaptItem(result: $0) }
    case let result as [Random]:
      return result.map { adaptItem(result: $0) }
    case let result as PexelsAPI.Response.Result:
      return result.photos.map { adaptItem($0) }
    case let result as RijksResult:
      return result.artObjects.map { adaptItem(result: $0) }
    case let result as ChicagoResponse.Result:
      return result.data.map { adaptItem(result: $0) }
    case let result as CivitalResponse.Result:
      return result.items.map { adaptItem(result: $0) }
    case let result as [Met.Result]:
      return result.filter { $0.primaryImage != nil && $0.primaryImage != "" }.map { adaptItem($0) }
    default:
      return []
    }
  }

  static func adaptItem(_ result: PexelsAPI.Response.Image) -> ImageViewProps {
    return ImageViewProps(id: "\(result.id)", height: result.height, width: result.width, urls: .init(display: result.src.medium ?? "", download: result.src.original ?? ""), title: result.alt, location: nil, color: result.avgColor, blur_hash: nil, base64: nil, author: result.photographer ?? "", user: nil, userLink: result.photographerUrl, imageLink: result.url)
  }

  static func adaptItem(_ result: Met.Result) -> ImageViewProps {
    let baseURL = "https://www.metmuseum.org/art/collection/search"
    let imageLink = "\(baseURL)/\(result.objectID)"
    let userLink = result.artistDisplayName != nil ? "\(baseURL)?q=\(result.artistDisplayName ?? "")" : ""

    return ImageViewProps(id: "\(result.objectID)", height: 0, width: 0, urls: ImageViewURL(
      display: result.primaryImageSmall ?? result.primaryImage ?? "",
      download: result.primaryImage ?? ""
    ), title: result.title, location: nil, color: nil, blur_hash: nil, base64: nil, author: result.artistDisplayName ?? "", user: nil,
    userLink: userLink, imageLink: imageLink)
  }

  static func adaptItem(result: CivitalResponse.Item) -> ImageViewProps {
    let baseURL = "https://civitai.com"
    let imageLink = "\(baseURL)/images/\(result.id)"
    let userLink = "\(baseURL)/user/\(result.username)"
    return ImageViewProps(id: "\(result.id)", height: result.height, width: result.width, urls: ImageViewURL(
      display: result.url,
      download: result.url
    ), title: result.meta?.prompt, location: nil, color: nil, blur_hash: result.hash, base64: nil, author: result.username, user: nil,
    userLink: userLink, imageLink: imageLink)
  }

  static func adaptItem(result: ChicagoResponse.Datum) -> ImageViewProps {
    let imageId = result.imageId ?? ""
    var base64 = result.thumbnail?.lqip ?? ""
    if let range = base64.range(of: "base64,") {
      base64 = String(base64[range.upperBound...])
    }

    let baseURL = "https://www.artic.edu"
    let imageLink = "\(baseURL)/artworks/\(result.id)/\(result.title.convertToHyphens())"
    let userLink = "\(baseURL)/artists/\(result.artistId)/\((result.artistTitle ?? "").convertToHyphens())"

    return ImageViewProps(id: String(describing: result.id), height: result.thumbnail?.height, width: result.thumbnail?.width, urls: ImageViewURL(
      display: ChicagoAPI.displayImageUrl(id: imageId),
      download: ChicagoAPI.downloadImageUrl(id: imageId)
    ), title: result.title, location: nil, color: nil, blur_hash: nil, base64: base64, author: result.artistTitle ?? "", user: nil,
    userLink: userLink, imageLink: imageLink)
  }

  static func adaptItem(result: Random) -> ImageViewProps {
    return ImageViewProps(id: result.id, height: result.height, width: result.width, urls: ImageViewURL(
      display: result.urls?.small ?? "",
      download: result.urls?.full ?? ""
    ), title: result.description, location: result.location, color: result.color, blur_hash: result.blur_hash, base64: nil, author: result.user.name, user: result.user, userLink: result.user.links.html, imageLink: result.links.html)
  }

  static func adaptItem(result: PhotosRespose) -> ImageViewProps {
    return ImageViewProps(
      id: result.id,
      height: result.height,
      width: result.width,
      urls: ImageViewURL(
        display: result.urls?.regular ?? "",
        download: result.urls?.full ?? ""
      ),
      title: result.description,
      location: nil,
      color: result.color,
      blur_hash: result.blur_hash, base64: nil,
      author: result.user.name,
      user: result.user,
      userLink: result.user.links.html,
      imageLink: result.links.html
    )
  }

  static func adaptItem(result: ArtObject) -> ImageViewProps {
    let userLink = "https://www.rijksmuseum.nl/en/collection/search?query=\(result.principalOrFirstMaker)"
    return ImageViewProps(
      id: result.id,
      height: result.webImage.height,
      width: result.webImage.width,
      urls: ImageViewURL(
        display: result.headerImage.url ?? result.webImage.url!,
        download: result.webImage.url!
      ),
//      title: artObject.longTitle,
      title: result.title,
      location: nil,
      color: nil,
      blur_hash: nil, base64: nil,
      author: result.principalOrFirstMaker,
      user: nil,
      userLink: userLink,
      imageLink: result.links.web
    )
  }
}
