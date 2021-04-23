//
//  ViewController.swift
//  ImageProvider
//
//  Created by Mohamed Korany on 4/23/21.
//  Copyright © 2021 Mohamed Korany. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  
  @IBOutlet weak var imageView: UIImageView!
  
  let imageProvider = ImageProvider()
  override func viewDidLoad() {
    super.viewDidLoad()
    
    loadImage(with: "https://avatars.githubusercontent.com/u/45698820?v=4") { [weak self] image in
      self?.imageView.image = image
    }
  }
  
  // Image will cache in NSCache and file system so it will be available on app when app running in NSCache and even if open app again in file system
  func loadImage(with urlString: String, completion: @escaping (UIImage?) -> Void) {
    imageProvider.getImage(with: urlString, completion: completion)
  }
  
}

