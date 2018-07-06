//
//  CustomListCell.swift
//  QiitaApi
//
//  Created by guest on 2018/06/29.
//  Copyright © 2018年 guest. All rights reserved.
//

import Foundation
import UIKit

class CustomListCell : BaseTableViewCell{
  
  var mainView : CustomListCellView?
  
  override func didInit() {
    super.didInit()
    setup()
    setupConstraints()
  }
  
  
  func setup(){
    do{
      let mainView = CustomListCellView()
      self.addSubview(mainView)
      mainView.backgroundColor = Colors.mainWhite
      self.mainView = mainView
    }
  }
  
  func setupConstraints(){
    guard let mainView = self.mainView else {return}
    
    do{
      mainView.translatesAutoresizingMaskIntoConstraints = false
      NSLayoutConstraint.activate([
        mainView.topAnchor.constraint(equalTo: self.topAnchor),
        mainView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        mainView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
        mainView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
  }
}
