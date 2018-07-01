//
//  Article.swift
//  QiitaApi
//
//  Created by guest on 2018/06/29.
//  Copyright © 2018年 guest. All rights reserved.
//

import Foundation

struct Article: Codable { // QiitaAPIから得られるJSONの構造
  let title: String
  let url: String
  let user: User
  struct User: Codable {
    let id: String
    let profile_image_url: String
  }
}

