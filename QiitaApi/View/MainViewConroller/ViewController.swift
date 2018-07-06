//
//  ViewController.swift
//  QiitaApi
//
//  Created by guest on 2018/06/29.
//  Copyright © 2018年 guest. All rights reserved.
//

import UIKit
import  StoreKit

class ViewController: UIViewController {
  
  var mainView : MainView?

  override func viewDidLoad() {
    super.viewDidLoad()

    setup()
    setupConstraints()
    
    
  }
  
  func setup(){
    do{
      self.view.backgroundColor = .white
      self.title = "Qiita"
    }
    do{
      let mainView = MainView()
      mainView.delegate = self
      self.view.addSubview(mainView)
      self.mainView = mainView
    }

  }
  
  func setupConstraints(){
    guard let mainView = self.mainView else {return}
    do{
       mainView.pinToEdges(view: self.view)
    }
  }
  
  @objc func showButtonPressed(){
    let listViewController = ListViewController()
    self.navigationController?.pushViewController(listViewController, animated: true)
  }
  
}

extension ViewController : MainViewDelegate{
  func searchButtonClicked(search: String) {
    let listViewController = ListViewController()
    listViewController.searchText  = search
    self.navigationController?.pushViewController(listViewController, animated: true)
  }
  
  
}

