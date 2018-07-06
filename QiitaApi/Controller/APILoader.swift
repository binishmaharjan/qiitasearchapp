//
//  APILoader.swift
//  QiitaApi
//
//  Created by guest on 2018/07/03.
//  Copyright © 2018年 guest. All rights reserved.
//

import UIKit

protocol APILoaderProtocol{
  static func loadData(page : String ,matching query: String, completion: @escaping ([Article]) -> Void,failure:@escaping ((String?)->()))
}

class APILoader : APILoaderProtocol{
  static var articleArray : [Article]?
  static var errorMessage : String = ""
  
  static func loadData(page : String, matching query: String, completion: @escaping ([Article]) -> Void,failure:@escaping ((String?)->())) {
    //      URLComponentsを用いて[URLQueryItem]型のパラメタを付加する（GETメソッド以外では必須）
    // URL文字列作成
    let urlString = "https://qiita.com/api/v2/items"
    guard var urlComponents = URLComponents(string: urlString) else {
      errorMessage = "通信エラー発生!"
      print("URLString error")
      failure(self.errorMessage)
      return
    }
    let queryItemsArray = [URLQueryItem(name: "page", value: page),
                           URLQueryItem(name: "per_page", value: "20"),
                           URLQueryItem(name: "query", value: query)]
    urlComponents.queryItems = queryItemsArray
    // URL型に変換
    guard let url = urlComponents.url else {
      errorMessage = "通信エラー発生!"
      print("URLComponents error")
      failure(self.errorMessage)
      return
    }
    
    print("MyUrl : \(url)")
    
    // URLRequest作成
    var request = URLRequest(url: url)
    
    // HTTPメソッドの設定
    request.httpMethod = "GET"
    
    // URLRequestにリクエストヘッダを付加
    request.addValue("application/json", forHTTPHeaderField: "Accept")
    //request.addValue("2028db84b93b78c48d09df96bb8706e37edd9cd7", forHTTPHeaderField: "Authorization")
    
    
    // URLSessionオブジェクト初期化とタスクの設定
    let session = URLSession.shared
    
    let task = session.dataTask(
      with: request,
      completionHandler: { data, response, error in
        
        guard let urlResponse = response else {
          self.errorMessage = "通信エラー発生!"
          print("Response nil")
          failure(self.errorMessage)
          return
        }
        guard let httpResponse = urlResponse as? HTTPURLResponse else {
          self.errorMessage = "通信エラー発生!"
          print("HTTPURLResponse type error")
          failure(self.errorMessage)
          return
        }
        if httpResponse.statusCode < 200 || httpResponse.statusCode >= 300 {
          self.errorMessage = "通信エラー発生!"
          print("Status code is \(httpResponse.statusCode)")
          failure(self.errorMessage)
          return
        }
        print("レスポンスヘッダ：\(httpResponse.allHeaderFields)")
        
        // Data型から配列を得て、structにマッピングする（パース）
        guard let responseData = data else {
          self.errorMessage = "通信エラー発生!"
          print("Response data nil")
          failure(self.errorMessage)
          return
        }
        do {
          self.articleArray = try JSONDecoder().decode([Article].self, from: responseData)
        } catch {
          self.errorMessage = "通信エラー発生!"
          print("JSON decode error")
          print(error.localizedDescription)
          failure(self.errorMessage)
        }
         //検索結果が0件なら、エラーメッセージに表示する（通信は正常終了）
        if self.articleArray?.count == 0 {
          self.errorMessage = "データ0件"
          failure(self.errorMessage)
        }
        // テーブルビューの再描画
        DispatchQueue.main.async {
          // インジケーター停止
          SKActivityIndicator.dismiss()
          completion(self.articleArray!)
        }
    }
    )
    // タスク実行
    task.resume()
    // インジケーター開始
    SKActivityIndicator.spinnerColor(Colors.mainGreen)
    SKActivityIndicator.statusTextColor(Colors.mainGreen)
    SKActivityIndicator.show("Loading")
    
  }

}
