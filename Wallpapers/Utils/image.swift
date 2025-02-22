//
//  image.swift
//  Wallpapers
//
//  Created by GaoZimeng on 2024/11/29.
//

import SwiftUI

struct ImageHelper {
  static let shared = ImageHelper()
  private init() {}

  // NSView 转 NSImage
  func imageFromView(cview: NSView) -> NSImage? {
    // 从view、data、CGImage获取BitmapImageRep
    // NSBitmapImageRep *bitmap = [NSBitmapImageRep imageRepWithData:data];
    // NSBitmapImageRep *bitmap = [[[NSBitmapImageRep alloc] initWithCGImage:CGImage];
    guard let bitmap: NSBitmapImageRep = cview.bitmapImageRepForCachingDisplay(in: cview.visibleRect) else { return nil }
    cview.cacheDisplay(in: cview.visibleRect, to: bitmap)
    let image = NSImage(size: cview.frame.size)
    image.addRepresentation(bitmap)

    return image
  }

  // 保存图片到本地
  func saveImage(image: NSImage, fileName: String) -> Bool {
    guard var imageData = image.tiffRepresentation,
          let imageRep = NSBitmapImageRep(data: imageData) else { return false }

    //    [imageRep setSize:size];  // 只是打开图片时的初始大小，对图片本省没有影响
    // jpg
    if fileName.hasSuffix("jpg") {
      let quality: NSNumber = 0.85 // 压缩率
      imageData = imageRep.representation(using: .jpeg, properties: [.compressionFactor: quality])!

    } else {
      // png
      imageData = imageRep.representation(using: .png, properties: [:])!
    }

    do {
      // 写文件 保存到本地需要关闭沙盒  ---- 保存的文件路径一定要是绝对路径，相对路径不行
      try imageData.write(to: URL(fileURLWithPath: fileName), options: .atomic)
      return true
    } catch {
      return false
    }
  }

  // 将图片按照比例压缩
  // rate 压缩比0.1～1.0之间
  func compressedImageDataWithImg(image: NSImage, rate: CGFloat) -> NSData? {
    guard let imageData = image.tiffRepresentation,
          let imageRep = NSBitmapImageRep(data: imageData) else { return nil }
    guard let data: Data = imageRep.representation(using: .jpeg, properties: [.compressionFactor: rate]) else { return nil }

    return data as NSData
  }

  // 完全填充,变形压缩
  func resizeImage(sourceImage: NSImage, forSize size: NSSize) -> NSImage {
    let targetFrame: NSRect = NSMakeRect(0, 0, size.width, size.height)

    let sourceImageRep: NSImageRep = sourceImage.bestRepresentation(for: targetFrame, context: nil, hints: nil)!
    let targetImage = NSImage(size: size)

    targetImage.lockFocus()
    sourceImageRep.draw(in: targetFrame)
    targetImage.unlockFocus()

    return targetImage
  }

  // 将图像居中缩放截取targetsize
  func resizeImage1(sourceImage: NSImage, forSize targetSize: CGSize) -> NSImage {
    let imageSize: CGSize = sourceImage.size
    let width: CGFloat = imageSize.width
    let height: CGFloat = imageSize.height
    let targetWidth: CGFloat = targetSize.width
    let targetHeight: CGFloat = targetSize.height
    var scaleFactor: CGFloat = 0.0

    let widthFactor: CGFloat = targetWidth / width
    let heightFactor: CGFloat = targetHeight / height
    scaleFactor = (widthFactor > heightFactor) ? widthFactor : heightFactor

    // 需要读取的源图像的高度或宽度
    let readHeight: CGFloat = targetHeight / scaleFactor
    let readWidth: CGFloat = targetWidth / scaleFactor
    let readPoint = CGPoint(x: widthFactor > heightFactor ? 0 : (width - readWidth) * 0.5,
                            y: widthFactor < heightFactor ? 0 : (height - readHeight) * 0.5)

    let newImage = NSImage(size: targetSize)
    let thumbnailRect = CGRect(x: 0, y: 0, width: targetSize.width, height: targetSize.height)
    let imageRect = NSRect(x: readPoint.x, y: readPoint.y, width: readWidth, height: readHeight)

    newImage.lockFocus()
    sourceImage.draw(in: thumbnailRect, from: imageRect, operation: .copy, fraction: 1.0)
    newImage.unlockFocus()

    return newImage
  }

  // 等比缩放
  func resizeImage2(sourceImage: NSImage, forSize targetSize: CGSize) -> NSImage {
    let imageSize: CGSize = sourceImage.size
    let width: CGFloat = imageSize.width
    let height: CGFloat = imageSize.height
    let targetWidth: CGFloat = targetSize.width
    let targetHeight: CGFloat = targetSize.height
    var scaleFactor: CGFloat = 0.0
    var scaledWidth: CGFloat = targetWidth
    var scaledHeight: CGFloat = targetHeight
    var thumbnailPoint = CGPoint(x: 0.0, y: 0.0)

    if __CGSizeEqualToSize(imageSize, targetSize) == false {
      let widthFactor: CGFloat = targetWidth / width
      let heightFactor: CGFloat = targetHeight / height

      // scale to fit the longer
      scaleFactor = (widthFactor > heightFactor) ? widthFactor : heightFactor
      scaledWidth = ceil(width * scaleFactor)
      scaledHeight = ceil(height * scaleFactor)

      // center the image
      if widthFactor > heightFactor {
        thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5
      } else if widthFactor < heightFactor {
        thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5
      }
    }

    let newImage = NSImage(size: NSSize(width: scaledWidth, height: scaledHeight))
    let thumbnailRect = CGRect(x: thumbnailPoint.x, y: thumbnailPoint.y, width: scaledWidth, height: scaledHeight)
    let imageRect = NSRect(x: 0.0, y: 0.0, width: width, height: height)

    newImage.lockFocus()
    sourceImage.draw(in: thumbnailRect, from: imageRect, operation: .copy, fraction: 1.0)
    newImage.unlockFocus()

    return newImage
  }

  // 将图片压缩到指定大小（KB）
  func compressImgData(imgData: NSData, toAimKB aimKB: NSInteger) -> NSData? {
    let aimRate = CGFloat(aimKB * 1000) / CGFloat(imgData.length)

    let imageRep = NSBitmapImageRep(data: imgData as Data)!
    guard let data: Data = imageRep.representation(using: .jpeg, properties: [.compressionFactor: aimRate]) else { return nil }

    print("数据最终大小：\(CGFloat(data.count) / 1000)， 压缩比率：\(CGFloat(data.count) / CGFloat(imgData.length))")

    return data as NSData
  }

  // 组合图片
  func jointedImageWithImages(imgArray: [NSImage]) -> NSImage {
    var imgW: CGFloat = 0
    var imgH: CGFloat = 0
    for img in imgArray {
      imgW += img.size.width
      if imgH < img.size.height {
        imgH = img.size.height
      }
    }

    print("size : \(NSStringFromSize(NSSize(width: imgW, height: imgH)))")

    let togetherImg = NSImage(size: NSSize(width: imgW, height: imgH))

    togetherImg.lockFocus()

    let imgContext: CGContext? = NSGraphicsContext.current?.cgContext

    var imgX: CGFloat = 0
    for imgItem in imgArray {
      let img = imgItem
      let imageRef: CGImage = getCGImageRefFromNSImage(image: img)!
      imgContext?.draw(imageRef, in: NSRect(x: imgX, y: 0, width: img.size.width, height: img.size.height))

      imgX += img.size.width
    }

    togetherImg.unlockFocus()

    return togetherImg
  }

  // NSImage转CGImageRef
  func getCGImageRefFromNSImage(image: NSImage) -> CGImage? {
    let imageData: NSData? = image.tiffRepresentation as NSData?
    var imageRef: CGImage?
    if imageData != nil {
      let imageSource: CGImageSource = CGImageSourceCreateWithData(imageData! as CFData, nil)!

      imageRef = CGImageSourceCreateImageAtIndex(imageSource, 0, nil)
    }
    return imageRef
  }

  // CGImage 转 NSImage
  func getNSImageWithCGImageRef(imageRef: CGImage) -> NSImage? {
    return NSImage(cgImage: imageRef, size: NSSize(width: imageRef.width, height: imageRef.height))
//        var imageRect: NSRect = NSRect(x: 0, y: 0, width: 0, height: 0)
//
//        var imageContext: CGContext? = nil
//        var newImage: NSImage? = nil
//
//        imageRect.size.height = CGFloat(imageRef.height)
//        imageRect.size.width = CGFloat(imageRef.width)
//
//        // Create a new image to receive the Quartz image data.
//        newImage = NSImage(size: imageRect.size)
//
//        newImage?.lockFocus()
//        // Get the Quartz context and draw.
//        imageContext = NSGraphicsContext.current?.cgContext
//        imageContext?.draw(imageRef, in: imageRect)
//        newImage?.unlockFocus()
//
//        return newImage;
  }

  // NSImage转CIImage
  func getCIImageWithNSImage(image: NSImage) -> CIImage? {
    // convert NSImage to bitmap
    guard let imageData = image.tiffRepresentation,
          let imageRep = NSBitmapImageRep(data: imageData) else { return nil }

    // create CIImage from imageRep
    let ciImage = CIImage(bitmapImageRep: imageRep)!

    // create affine transform to flip CIImage
    let affineTransform = NSAffineTransform()
    affineTransform.translateX(by: 0, yBy: 128)
    affineTransform.scaleX(by: 1, yBy: -1)

    // create CIFilter with embedded affine transform
    let transform = CIFilter(name: "CIAffineTransform")!
    transform.setValue(ciImage, forKey: "inputImage")
    transform.setValue(affineTransform, forKey: "inputTransform")

    // get the new CIImage, flipped and ready to serve
    let result: CIImage? = transform.value(forKey: "outputImage") as? CIImage
    return result
  }
}
