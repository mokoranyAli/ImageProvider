//
//  ImageProvider.swift
//  ImageProvider
//
//  Created by Mohamed Korany on 4/23/21.
//  Copyright © 2021 Mohamed Korany. All rights reserved.
//

import Foundation
import UIKit

// MARK: - ImageProvider

/// Get image from remote and hadndler cacheing operations
///
class ImageProvider {
  
    
  // MARK: - Typealiass
 
  /// Completion
  ///
  typealias Completion = (UIImage?) -> Void
  
  /// This is the same original UIImage, we just do it cause handle for viewModel
  /// Cause viewModel do logic and we shouldn't need to import UIKit in viewModel
  typealias LoadedImage = UIImage
  
  // MARK: - Propeties
  
  /// Handle getting image from remote server
  ///
  private let viewModel: ImageProviderViewModel
  
  /// for chaching image
  ///
  private static let imageCache = NSCache<AnyObject, AnyObject>()
  
  // MARK: - Init
  
  init(viewModel: ImageProviderViewModel? = nil) {
    self.viewModel = viewModel ?? ImageProviderViewModel()
  }
  
  // MARK: - Handlers
  
  /// Getting user image either from cache or remote in case of first time
  ///
  func getImage(with urlString: String?, completion: Completion?) {
    
    guard let urlString = urlString else {
      NSLog("⛔️ Image should have a name.")
      completion?(nil)
      return
    }
    
    if let image = getCachedImage(with: urlString) {
      completion?(image)
    } else {
      loadAndCacheImage(named: urlString, completion: completion)
    }
  }
}

// MARK: - ImageHandler+Cacheing handlers
//
private extension ImageProvider {
  
  /// Load and cache image
  ///
  func loadAndCacheImage(named urlString: String, completion: Completion?) {
    viewModel.loadImage(from: urlString) { [weak self] image in
      guard let self = self else { return }
      self.cache(image, with: urlString)
      completion?(image)
    }
  }
  
  /// Get image from cache if exist
  ///
  func getCachedImage(with urlString: String) -> UIImage? {
    
    // return image if exist in RAM cache
    if let imageFromRam = getCachedImageFromRAM(key: urlString) {
      return imageFromRam
    }
    
    // Get image if cache in Dirctory
    if let imageFromDirctory = getCachedImageFromDirctory(key: urlString) {
      // Cache in memory in case of cached in dirctory only
      cacheImageInRAM(image: imageFromDirctory, with: urlString)
      return imageFromDirctory
    }
    
    return nil
  }
  
  /// Cacheing image with `urlString`which is urlString
  func cache(_ image: UIImage?, with urlString: String) {
    guard let image = image else { return }
    cacheImageInRAM(image: image, with: urlString)
    cacheImageInDirctory(image: image, with: urlString)
  }
  
  /// Cache image in dirctory locally with `urlString` which is urlString
  ///
  func cacheImageInDirctory(image: UIImage, with urlString: String) {
    if let data = image.pngData() {
      let fileURL = cacheFileUrl(urlString)
      
      try? data.write(to: fileURL, options: Data.WritingOptions.atomic)
      
    }
  }
  
  /// Cache image in RAM locally with `urlString` which is urlString
  ///
  func cacheImageInRAM(image: UIImage, with id: String) {
    ImageProvider.imageCache.setObject(image, forKey: id as AnyObject)
  }
  
  /// Get cached image from RAM cache by `key` which is urlString
  ///
  func getCachedImageFromDirctory(key: String) -> UIImage? {
    let fileURL = cacheFileUrl(key)
    if let imageData = try? Data(contentsOf: fileURL) {
      return UIImage(data: imageData)
    }
    
    return nil
  }
  
  /// Get cached image from RAM cache by `key` which is urlString
  ///
  func getCachedImageFromRAM(key: String) -> UIImage? {
    
    return ImageProvider.imageCache.object(forKey: key as AnyObject) as? UIImage
  }
  
  /// Get path about cached images for specific image with `urlString`
  ///
  func cacheFileUrl(_ urlString: String) -> URL {
    let cacheURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
    return cacheURL.appendingPathComponent(urlString)
  }
}
