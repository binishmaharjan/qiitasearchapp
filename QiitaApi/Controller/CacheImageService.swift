//
//  CacheImageService.swift
//  QiitaApi
//
//  Created by guest on 2018/07/12.
//  Copyright © 2018年 guest. All rights reserved.
//

import Foundation
import UIKit

class CacheImageService{
  static let cache = NSCache<NSString, UIImage>()
  
  static func downloadImage(withURL url :URL, completion : @escaping (_ image: UIImage?)->()){
    let dataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
      DispatchQueue.global(qos: .default).async{
        var downloadedImage: UIImage?
        
        if let data = data{
          downloadedImage = UIImage(data: data)
        }
        
        if downloadedImage != nil{
          cache.setObject(downloadedImage!, forKey: url.absoluteString as NSString)
        }
        
        DispatchQueue.main.async {
          completion(downloadedImage)
        }
      }
    }
    dataTask.resume()
  }
  
  
  static func getImage(withURL url :URL, completion : @escaping (_ image: UIImage?)->()){
    if let image = cache.object(forKey: url.absoluteString as NSString){
      completion(image)
    }else{
      downloadImage(withURL: url, completion: completion)
    }
  }
}
