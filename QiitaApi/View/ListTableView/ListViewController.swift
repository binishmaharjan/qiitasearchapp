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
  var activityIndicator : UIActivityIndicatorView?
  var errorMessage = ""

    override func viewDidLoad() {
        super.viewDidLoad()
      
      setup()
      setupConstraints()
      loadFromApi()
    }

  
  private func setup(){
    do{
      let baseView = UIView()
      self.view.addSubview(baseView)
      self.baseView = baseView
      baseView.backgroundColor = .white
    }
    
    do{
      let tableView = ListTableView()
      self.view.addSubview(tableView)
      self.tableView = tableView
      tableView.delegate = self
      tableView.backgroundColor = .white
    }
    do{
      let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
      self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: activityIndicator)
      self.activityIndicator = activityIndicator
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
    // リクエストパラメタの設定（方法２）
    //      URLComponentsを用いて[URLQueryItem]型のパラメタを付加する（GETメソッド以外では必須）
    // URL文字列作成
    let urlString = "https://qiita.com/api/v2/items"
    guard var urlComponents = URLComponents(string: urlString) else {
      errorMessage = "通信エラー発生!"
      print("URLString error")
      self.showErrorMessage()
      return
    }
    let queryItemsArray = [URLQueryItem(name: "page", value: "1"),
                           URLQueryItem(name: "per_page", value: "20"),
                           URLQueryItem(name: "query", value: "swift")]
    urlComponents.queryItems = queryItemsArray
    // URL型に変換
    guard let url = urlComponents.url else {
      errorMessage = "通信エラー発生!"
      print("URLComponents error")
      self.showErrorMessage()
      return
    }
    
    
    // URLRequest作成
    var request = URLRequest(url: url)
    
    // HTTPメソッドの設定
    request.httpMethod = "GET"
    
    // URLRequestにリクエストヘッダを付加
    request.addValue("application/json", forHTTPHeaderField: "Accept")
    //request.addValue("Bearer あなたのアクセストークン", forHTTPHeaderField: "Authorization")
    
    
    // URLSessionオブジェクト初期化とタスクの設定
    let session = URLSession.shared
    
    let task = session.dataTask(
      with: request,
      completionHandler: { data, response, error in
        
        guard let urlResponse = response else {
          self.errorMessage = "通信エラー発生!"
          print("Response nil")
          self.showErrorMessage()
          return
        }
        guard let httpResponse = urlResponse as? HTTPURLResponse else {
          self.errorMessage = "通信エラー発生!"
          print("HTTPURLResponse type error")
          self.showErrorMessage()
          return
        }
        if httpResponse.statusCode < 200 || httpResponse.statusCode >= 300 {
          self.errorMessage = "通信エラー発生!"
          print("Status code is \(httpResponse.statusCode)")
          self.showErrorMessage()
          return
        }
        print("レスポンスヘッダ：\(httpResponse.allHeaderFields)")
        
        // Data型から配列を得て、structにマッピングする（パース）
        guard let responseData = data else {
          self.errorMessage = "通信エラー発生!"
          print("Response data nil")
          self.showErrorMessage()
          return
        }
        do {
          self.articleArray = try
            JSONDecoder().decode([Article].self, from: responseData)
        } catch {
          self.errorMessage = "通信エラー発生!"
          print("JSON decode error")
          print(error.localizedDescription)
          self.showErrorMessage()
        }
        // 検索結果が0件なら、エラーメッセージに表示する（通信は正常終了）
        if self.articleArray?.count == 0 {
          self.errorMessage = "データ0件"
        }
        // テーブルビューの再描画
        DispatchQueue.main.async {
          // インジケーター停止
          UIApplication.shared.isNetworkActivityIndicatorVisible = false
          self.activityIndicator?.stopAnimating()
          self.loadData()
        }
    }
    )
    
//    DispatchQueue.global(qos: .default).async { // ネットが重い時のシミュレーション
//      for _ in 0..<50000 {
//        for _ in 0..<10000 {
//
//        }
//      }
//      task.resume()
//    }
    
      // タスク実行
      task.resume()
    // インジケーター開始
    UIApplication.shared.isNetworkActivityIndicatorVisible = true
    self.activityIndicator?.startAnimating()

  }
}

//MARK:- List View Delegate
extension ListViewController : ListViewDelegate{
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
      // インジケーター停止
      UIApplication.shared.isNetworkActivityIndicatorVisible = false
      self.activityIndicator?.stopAnimating()
      // テーブルビュー再描画
      self.tableView?.tableView?.reloadData()
    }
  }
}
