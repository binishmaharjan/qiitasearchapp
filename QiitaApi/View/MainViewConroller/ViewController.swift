//
//  ViewController.swift
//  QiitaApi
//
//  Created by guest on 2018/06/29.
//  Copyright © 2018年 guest. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  
  var showButton : UIButton?

  override func viewDidLoad() {
    super.viewDidLoad()

    setup()
    setupConstraints()
    
  }

  
  func setup(){
    self.view.backgroundColor = .white
    self.title = "Qiita"
    
    do{
      let showButton = UIButton(type: .system)
      showButton.setTitle("Show", for: .normal)
      showButton.addTarget(self, action: #selector(showButtonPressed), for: .touchUpInside)
      self.view.addSubview(showButton)
      self.showButton = showButton
    }
  }
  
  func setupConstraints(){
    guard let showButton = self.showButton else{ return }
    
    do{
      showButton.translatesAutoresizingMaskIntoConstraints = false
      NSLayoutConstraint.activate([
        showButton.heightAnchor.constraint(equalToConstant: 30),
        showButton.widthAnchor.constraint(equalToConstant: 50),
        showButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
        showButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        ])
    }
  }
  
  @objc func showButtonPressed(){
    let listViewController = ListViewController()
    self.navigationController?.pushViewController(listViewController, animated: true)
  }
  
}

