//
//  ListViewController.swift
//  QiitaApi
//
//  Created by guest on 2018/06/29.
//  Copyright © 2018年 guest. All rights reserved.
//

import UIKit

class ListViewController: UIViewController {
  
  var baseView :UIView?
  var tableView : ListTableView?
  var articleArray : [Article]?
  var errorMessage = ""
  var searchText = ""
  var page = "1"
  var isLoading : Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
      
      setup()
      setupConstraints()
      loadFromApi()
    }

  
  private func setup(){
    do{
      self.title = searchText
    }
    do{
      let baseView = UIView()
      self.view.addSubview(baseView)
      self.baseView = baseView
      baseView.backgroundColor = Colors.mainWhite
    }
    
    do{
      let tableView = ListTableView()
      self.view.addSubview(tableView)
      self.tableView = tableView
      tableView.delegate = self
      tableView.backgroundColor  = Colors.mainWhite
    }
  }
  
  private func setupConstraints(){
    guard let baseView = self.baseView,
      let tableView = self.tableView else{ return }
    
    do{
      baseView.translatesAutoresizingMaskIntoConstraints = false
      NSLayoutConstraint.activate([
          baseView.topAnchor.constraint(equalTo: self.view.topAnchor),
          baseView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
          baseView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
          baseView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
    }
    
    do{
      tableView.translatesAutoresizingMaskIntoConstraints = false
      NSLayoutConstraint.activate([
        tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
        tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
        tableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
        tableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
  }
  
  private func loadData(){
    guard  let tableView = self.tableView else {return}
    tableView.errorMessage = self.errorMessage
    tableView.articleArray = self.articleArray

  }
  
  func loadFromApi(){
    APILoader.loadData(page : page , matching: searchText, completion: { (articles) in
      self.articleArray = articles
      DispatchQueue.main.async {
        self.loadData()
      }
    }) { (errorMessage) in
      self.errorMessage = errorMessage!
      SKActivityIndicator.dismiss()
      DispatchQueue.main.async {
        self.showErrorMessage()
      }
    }
  }
}

//MARK:- List View Delegate
extension ListViewController : ListViewDelegate{
  func loadmore() {
    if !isLoading { // Check if data is already loading, if not proceed
      self.isLoading = true //Set is loading to true
      self.page = String( Int(self.page)! + 1)
      
      APILoader.loadData(page: self.page, matching: searchText, completion: { (articles) in
        DispatchQueue.main.async {
          self.tableView?.articleArray?.append(contentsOf: articles)
          self.isLoading = false // Set isLoading to false when data is loaded
        }
      }) { (errorMessage) in
        self.errorMessage = errorMessage!
        SKActivityIndicator.dismiss()
        DispatchQueue.main.async {
          self.showErrorMessage()
          self.isLoading = false
        }
      }
    }
    
  }
  
  func itemIsClicked(url : String) {
    let safariViewController = SafariViewController()
    safariViewController.url = url
    self.navigationController?.pushViewController(safariViewController, animated: true)
  }
  
  
}

//MARK:- Error Message
extension ListViewController{
  internal func showErrorMessage() {
    DispatchQueue.main.async {
      // テーブルビュー再描画
      self.loadData()
    }
  }
}
