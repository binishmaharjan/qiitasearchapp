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
    
    self.navigationBar.barTintColor = Colors.mainGreen
    
    self.navigationBar.tintColor = Colors.mainWhite
    
    let attrs = [
      NSAttributedStringKey.foregroundColor : Colors.mainWhite
    ]
    
    self.navigationBar.titleTextAttributes = attrs
    
    self.navigationBar.isTranslucent = false
    
    UIApplication.shared.statusBarStyle = .lightContent
  }
}
