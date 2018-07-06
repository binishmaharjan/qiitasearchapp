//
//  ListViewDelegate.swift
//  QiitaApi
//
//  Created by guest on 2018/07/01.
//  Copyright © 2018年 guest. All rights reserved.
//

import UIKit


protocol ListViewDelegate {
  func itemIsClicked(url : String)
  func loadmore()
}
