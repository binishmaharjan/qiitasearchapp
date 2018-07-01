//
//  NavigationController.swift
//  QiitaApi
//
//  Created by guest on 2018/07/01.
//  Copyright © 2018年 guest. All rights reserved.
//

import UIKit


class NavigationController : UINavigationController{
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.navigationBar.barTintColor = UIColor.red
    
    self.navigationBar.tintColor = UIColor.white
    
    let attrs = [
      NSAttributedStringKey.foregroundColor : UIColor.black
    ]
    
    self.navigationBar.titleTextAttributes = attrs
    
    self.navigationBar.isTranslucent = false
    
    UIApplication.shared.statusBarStyle = .lightContent
  }
}
