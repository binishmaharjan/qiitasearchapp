//
//  CustomListCellView.swift
//  QiitaApi
//
//  Created by guest on 2018/06/29.
//  Copyright © 2018年 guest. All rights reserved.
//

import Foundation
import UIKit


class CustomListCellView: BaseView {
  
  var imageView : UIImageView?
  var nameLabel : UILabel?
  var lbl : UILabel?
  
  private var bottomToLabel : NSLayoutConstraint?
  private var bottomToImage : NSLayoutConstraint?
  
  override func didInit() {
    super.didInit()
    setup()
    setupConstraints()
  }
  
  func setup(){
    do{
      let imageView = UIImageView()
      self.addSubview(imageView)
      self.imageView = imageView
      imageView.backgroundColor = UIColor.lightGray
      imageView.layer.borderWidth = 1
      imageView.contentMode = .scaleAspectFill
    }
    do{
      let lbl = UILabel()
      self.addSubview(lbl)
      self.lbl = lbl
      lbl.layer.borderWidth = 1
      lbl.numberOfLines = 0
    }
    do{
      let lbl = UILabel()
      self.addSubview(lbl)
      self.nameLabel = lbl
      lbl.layer.borderWidth = 1
      lbl.numberOfLines = 0
    }
  }
  
  func setupConstraints(){
    guard let imageView = self.imageView,
      let titlelbl = self.nameLabel,
      let lbl = self.lbl else{return}
    
    self.translatesAutoresizingMaskIntoConstraints = false
    self.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true

    do{
      imageView.translatesAutoresizingMaskIntoConstraints = false
      imageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 5).isActive = true
      imageView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.20).isActive  = true
      imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, constant: 1).isActive = true
      imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
      imageView.setNeedsLayout()
      imageView.layoutIfNeeded()
      imageView.layer.masksToBounds = true
      imageView.layer.cornerRadius = imageView.bounds.width / 2
    }
    
    do{
     titlelbl.anchor(top: self.topAnchor, left: imageView.rightAnchor, right: self.rightAnchor, bottom: nil, paddingTop: 5, paddingLeft: 5, paddingRight: 5, paddingBottom: -5, width: 0,height: 30)
    }

    do{
      lbl.anchor(top: titlelbl.bottomAnchor, left: imageView.rightAnchor, right: self.rightAnchor, bottom: self.bottomAnchor, paddingTop: 5, paddingLeft: 5, paddingRight: 5, paddingBottom: -5)
    }
    
    do{
      self.bottomToImage = self.bottomAnchor.constraint(equalTo: imageView.bottomAnchor,constant :5)
      self.bottomToImage?.priority = .defaultHigh
      self.bottomToImage?.isActive = true
      
      
      self.bottomToImage = self.bottomAnchor.constraint(equalTo: lbl.bottomAnchor,constant :5)
      self.bottomToImage?.priority = .defaultHigh
      self.bottomToImage?.isActive = false
    }
  }
  
  func relayout(){
    guard let imageView = self.imageView,
      let lbl = self.lbl else {return}
    
    lbl.setNeedsLayout()
    lbl.layoutIfNeeded()
    
    self.bottomToLabel?.isActive = false
    self.bottomToLabel?.isActive = false
    
    if imageView.frame.maxY > lbl.frame.maxY{
      self.bottomToImage?.isActive = true
    }else{
      self.bottomToLabel?.isActive = true
    }
    
    self.layoutIfNeeded()
  }
}
