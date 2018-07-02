//
//  SafariView.swift
//  QiitaApi
//
//  Created by guest on 2018/06/30.
//  Copyright © 2018年 guest. All rights reserved.
//

import UIKit
import WebKit

class SafariView : BaseView{
  
  private var mainView : WKWebView?
  private var progressBar : UIProgressView?
  var url : String? {
    didSet{
      loadPage()
    }
  }
  
  override func didInit() {
    super.didInit()
    setup()
    setupConstraints()
  }
  
  func setup(){
    do{
      let mainView = WKWebView()
      mainView.allowsBackForwardNavigationGestures = true
      self.mainView = mainView
      self.addSubview(mainView)
    }
    do{
      let progressBar = UIProgressView()
      mainView?.addSubview(progressBar)
      mainView?.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
      mainView?.addObserver(self, forKeyPath: "loading", options: .new, context: nil)
      self.progressBar = progressBar
    }
  }
  
  func setupConstraints(){
    guard let mainView  = self.mainView else {return}
    do{
      mainView.anchor(top: self.topAnchor, left: self.leftAnchor, right: self.rightAnchor, bottom: self.bottomAnchor, paddingTop: 0, paddingLeft: 0, paddingRight: 0, paddingBottom: 0)
    }
    
    do{
      progressBar?.anchor(top: mainView.topAnchor, left: mainView.leftAnchor, right: mainView.rightAnchor, bottom: nil, paddingTop: 0, paddingLeft: 0, paddingRight: 0, paddingBottom: 0, width: 0, height: 3)
    }
    
  }
  
  func loadPage(){
    guard let mainView = self.mainView,
    let url = self.url else{return}
    mainView.load(URLRequest(url: URL(string: url)!))
  }
  
  deinit {
    guard let mainView  = self.mainView else{return}
    mainView.removeObserver(self, forKeyPath: "estimatedProgress", context: nil)
    mainView.removeObserver(self, forKeyPath: "loading", context: nil)
  }

  override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
    guard let progressBar = self.progressBar,
      let mainView = self.mainView else {return}
    
    if (keyPath == "estimatedProgress") {
      // Progress Viewを表示
      progressBar.alpha = 1.0
      // estimatedProgressが変更されたときにプログレスバーの値を変更
      progressBar.setProgress(Float(1), animated: true)
      
      // estimatedProgressが1.0になったらアニメーションを使って非表示にし
      // アニメーション完了時0.0をセットする
      if (mainView.estimatedProgress >= 1.0) {
        UIView.animate(
          withDuration: 0.3,
          delay: 0.3,
          options: .curveEaseOut,
          animations: {
            progressBar.alpha = 0.0
        },
          completion: { finished in
            progressBar.setProgress(0.0, animated: false)
        }
        )
      }
    }
  }
}
