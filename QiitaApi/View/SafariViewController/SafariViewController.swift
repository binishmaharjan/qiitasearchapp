//
//  SafariViewController.swift
//  QiitaApi
//
//  Created by guest on 2018/06/30.
//  Copyright © 2018年 guest. All rights reserved.
//

import UIKit

class SafariViewController: UIViewController {
  
  var baseView : UIView?
  var safariView : SafariView?
  var url : String?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
    setupConstraints()
  }
  
  func setup(){
    do{
      let baseView = UIView()
      self.view.addSubview(baseView)
      self.baseView = baseView
    }
    do{
      guard let url = self.url else{return}
      let safariView = SafariView()
      safariView.url = url
      self.view.addSubview(safariView)
      self.safariView = safariView
    }
  }
  
  func setupConstraints(){
    guard let baseView = self.baseView,
      let safariView = self.safariView else{return}
    do{
      baseView.anchor(top: self.view.safeTopAnchor, left: self.view.safeLeftAnchor, right: self.view.safeRightAnchor, bottom: self.view.bottomAnchor, paddingTop: 0, paddingLeft: 0, paddingRight: 0, paddingBottom: 0)
    }
    
    do{
      safariView.anchor(top: self.view.topAnchor, left: self.view.leftAnchor, right: self.view.rightAnchor, bottom: self.view.bottomAnchor, paddingTop: 0, paddingLeft: 0, paddingRight: 0, paddingBottom: 0)
    }
  }
}
