//
//  MainView.swift
//  QiitaApi
//
//  Created by guest on 2018/07/02.
//  Copyright © 2018年 guest. All rights reserved.
//

import UIKit
import StoreKit

class MainView : BaseView{
  private var contentView: UIView?
  private var textFieldBG: UIView?
  private var textField: UITextField?
  private var searchBtnBG: UIView?
  private var searchBtn: UIButton?
  private var cancelBtnBG: UIView?
  private var cancelBtn: UIButton?
  private var titleImageBG : UIView?
  private var titleImage : UIImageView?
  
  var delegate : MainViewDelegate?
  
  override func didInit() {
    super.didInit()
    setup()
    setupConstraints()
  }
  
  func setup(){
    do{
      let contentView = UIView()
      self.addSubview(contentView)
      backgroundColor = Colors.mainWhite
      self.contentView = contentView
    }
    do{
      let textFieldBG = UIView()
      textFieldBG.backgroundColor = Colors.mainWhite
      textFieldBG.layer.cornerRadius = 5.0
      textFieldBG.layer.borderColor = Colors.blue.cgColor
      textFieldBG.layer.borderWidth = 0.5
      textFieldBG.dropShadow()
      contentView?.addSubview(textFieldBG)
      self.textFieldBG = textFieldBG
    }
    do{
      let textField = UITextField()
      textField.backgroundColor = Colors.mainWhite
      textField.font = UIFont.boldSystemFont(ofSize: 12)
      textField.placeholder = "検索してください"
      textField.returnKeyType = .done
      textField.delegate = self
      textFieldBG?.addSubview(textField)
      self.textField = textField
    }
    do{
      let searchBtnBG = UIView()
      searchBtnBG.backgroundColor = Colors.mainGreen
      searchBtnBG.dropShadow()
      searchBtnBG.layer.cornerRadius = 5.0
      self.searchBtnBG = searchBtnBG
      self.contentView?.addSubview(searchBtnBG)
    }
    do{
      let searchBtn = UIButton()
      searchBtn.backgroundColor = UIColor.clear
      searchBtn.setTitleColor(Colors.mainWhite, for: .normal)
      searchBtn.setTitle("Search", for: .normal)
      searchBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
      searchBtn.addTarget(self, action: #selector(searchButtonClicked), for: .touchUpInside)
      searchBtnBG?.addSubview(searchBtn)
      self.searchBtn = searchBtn
    }
    do{
      let cancelBtnBG = UIView()
      cancelBtnBG.backgroundColor = Colors.mainGreen
      cancelBtnBG.dropShadow()
      cancelBtnBG.layer.cornerRadius = 5.0
      self.cancelBtnBG = cancelBtnBG
      self.contentView?.addSubview(cancelBtnBG)
    }
    do{
      let cancelBtn = UIButton()
      cancelBtn.backgroundColor = UIColor.clear
      cancelBtn.setTitle("Cancel", for: .normal)
      cancelBtn.setTitleColor(Colors.mainWhite, for: .normal)
      cancelBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
      cancelBtn.addTarget(self, action: #selector(cancelButtonClicked), for: .touchUpInside)
      cancelBtnBG?.addSubview(cancelBtn)
      self.cancelBtn = cancelBtn
    }
    do{
      let titleImageBG = UIView()
      titleImageBG.backgroundColor = Colors.mainWhite
      contentView?.addSubview(titleImageBG)
      self.titleImageBG = titleImageBG
    }
    do{
      let titleImage = UIImageView()
      titleImageBG?.addSubview(titleImage)
      titleImage.image = UIImage(named: "qiita")
      titleImage.contentMode = .scaleAspectFit
      self.titleImage = titleImage
    }
  }
  
  func setupConstraints(){
    guard let contentView = self.contentView,
          let textFieldBG = self.textFieldBG,
          let textField = self.textField,
          let searchBtnBG = self.searchBtnBG,
          let searchBtn = self.searchBtn,
          let cancelBtnBG = self.cancelBtnBG,
          let cancelBtn = self.cancelBtn,
          let titleImageBG = self.titleImageBG,
          let titleImage = self.titleImage
          else{return}
    
    do{
      contentView.anchor(top: self.topAnchor, left: self.leftAnchor, right: self.rightAnchor, bottom: self.bottomAnchor, paddingTop: 0, paddingLeft: 0, paddingRight: 0, paddingBottom: 0)
    }
    do{
      searchBtnBG.anchor(top: nil, left: contentView.leftAnchor, right: nil, bottom: nil, paddingTop: 0, paddingLeft: 16, paddingRight: 0, paddingBottom: 0,width:((UIScreen.main.bounds.width - 32)/2) - 8 ,height: 42 )
      //searchBtnBG.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
    }
    do{
      searchBtn.pinToEdges(view: searchBtnBG)
    }
    do{
      cancelBtnBG.anchor(top: searchBtn.topAnchor, left: searchBtn.rightAnchor, right: contentView.rightAnchor, bottom: nil, paddingTop: 0, paddingLeft: 8, paddingRight: 16, paddingBottom: 0,width: 0 ,height: 42)
    }
    do{
      cancelBtn.pinToEdges(view: cancelBtnBG)
    }
    do{
      textFieldBG.anchor(top: nil, left: contentView.leftAnchor, right: contentView.rightAnchor, bottom: searchBtnBG.topAnchor, paddingTop: 0, paddingLeft: 16, paddingRight: 16, paddingBottom: -16,width: 0,height: 42)
      textFieldBG.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
    }
    do{
      textField.anchor(top: textFieldBG.topAnchor, left: textFieldBG.leftAnchor, right: textFieldBG.rightAnchor, bottom: textFieldBG.bottomAnchor, paddingTop: 0, paddingLeft: 8, paddingRight: 8, paddingBottom: 0)
    }
    do{
      titleImageBG.anchor(top: nil, left: textField.leftAnchor, right: textField.rightAnchor, bottom: textField.topAnchor, paddingTop: 0, paddingLeft: 0, paddingRight: 0, paddingBottom: -25)
    }
    do{
      titleImage.pinToEdges(view: titleImageBG)
    }
  }
}

//MARk:- Buttons
extension MainView{
  @objc func cancelButtonClicked(){
    guard let textField = self.textField else {return}
    textField.text = ""
    textField.resignFirstResponder()
    SKStoreReviewController.requestReview()
  }
  
  @objc func searchButtonClicked(){
    guard let textField = self.textField,
      let delegate = self.delegate
      else {return}
    if !(textField.text?.isEmpty)!{
      delegate.searchButtonClicked(search: textField.text!)
    }else{
      AlertController.showMessage(title: "エラー", msg: "検索文字を入れてください", handler: {_ in })
    }
    textField.resignFirstResponder()
  }
}

 //MARK:- Text Fields
extension MainView : UITextFieldDelegate{
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
}
