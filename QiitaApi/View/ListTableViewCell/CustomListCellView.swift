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
  var nameLabelBG : UIView?
  var nameLabel : UILabel?
  var lblBG :UIView?
  var lbl : UILabel?
  
  private var bottomToLabel : NSLayoutConstraint?
  private var bottomToImage : NSLayoutConstraint?
  private var nameBottomToLabel : NSLayoutConstraint?
  
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
      imageView.contentMode = .scaleAspectFill
    }
    do{
      let lblBG = UIView()
      self.addSubview(lblBG)
      self.lblBG = lblBG
    }
    do{
      let lbl = UILabel()
      lblBG?.addSubview(lbl)
      self.lbl = lbl
      lbl.textColor = Colors.titleBlue
      lbl.font = UIFont.boldSystemFont(ofSize: 16)
      lbl.numberOfLines = 0
    }
    do{
      let nameLabelBG = UIView()
      self.addSubview(nameLabelBG)
      self.nameLabelBG = nameLabelBG
    }
    do{
      let nameLabel = UILabel()
      nameLabelBG?.addSubview(nameLabel)
      self.nameLabel = nameLabel
      nameLabel.textColor = Colors.titleGray
      nameLabel.numberOfLines = 0
    }
  }
  
  func setupConstraints(){
    guard let imageView = self.imageView,
      let nameLabelBG = self.nameLabelBG,
      let titlelbl = self.nameLabel,
      let lblBG = self.lblBG,
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
      lblBG.anchor(top: nil, left: imageView.rightAnchor, right: self.rightAnchor, bottom: self.bottomAnchor, paddingTop: 8, paddingLeft: 8, paddingRight: 8, paddingBottom: -8)
    }
    do{
      lbl.pinToEdges(view: lblBG)
    }
    
    do{
      nameLabelBG.anchor(top: self.topAnchor, left: imageView.rightAnchor, right: self.rightAnchor, bottom: nil, paddingTop: 8, paddingLeft: 8, paddingRight: 8, paddingBottom: -2)
    }
    do{
      titlelbl.pinToEdges(view: nameLabelBG)
    }
    
    do{
      self.nameBottomToLabel = self.nameLabelBG?.bottomAnchor.constraint(equalTo: lblBG.topAnchor)
      self.nameBottomToLabel?.priority = .defaultHigh
      self.nameBottomToLabel?.isActive = false
      
      self.bottomToImage = self.bottomAnchor.constraint(equalTo: imageView.bottomAnchor,constant :5)
      self.bottomToImage?.priority = .defaultHigh
      self.bottomToImage?.isActive = false
      
      
      self.bottomToLabel = self.bottomAnchor.constraint(equalTo: lblBG.bottomAnchor,constant :5)
      self.bottomToLabel?.priority = .defaultHigh
      self.bottomToLabel?.isActive = false
    }
  }
  
  func relayout(){
    guard let imageView = self.imageView,
      let nameLabel = self.nameLabel,
      let lbl = self.lbl else {return}
    
    lbl.setNeedsLayout()
    lbl.layoutIfNeeded()
    nameLabel.setNeedsLayout()
    nameLabel.layoutIfNeeded()
    
    self.nameBottomToLabel?.isActive = false
    if nameLabel.frame.maxY > lbl.frame.minY {
      self.nameBottomToLabel?.isActive = true
    }
    
    lbl.setNeedsLayout()
    lbl.layoutIfNeeded()
    
    self.bottomToImage?.isActive = false
    self.bottomToLabel?.isActive = false
    

    if imageView.frame.maxY > lbl.frame.maxY{
      self.bottomToImage?.isActive = true
    }else{
      self.bottomToLabel?.isActive = true
    }
    
    self.layoutIfNeeded()
  }
}
