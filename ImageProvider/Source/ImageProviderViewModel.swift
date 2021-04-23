//
//  ImageProviderViewModel.swift
//  ImageProvider
//
//  Created by Mohamed Korany on 4/23/21.
//  Copyright © 2021 Mohamed Korany. All rights reserved.
//

import Foundation
import class UIKit.UIImage

// MARK: - ImageProviderViewModel
//
class ImageProviderViewModel {
  
  // MARK: - Handlers
  
  /// Get  image by urlString and complete with image
  ///
  func loadImage(from imageURL: String, completion: @escaping (_ image: UIImage?) -> Void) {
    guard let url = URL(string: imageURL) else { return }
    guard let data = try? Data(contentsOf: url) else {
      return
    }
    completion(UIImage(data: data))
    
  }
}
