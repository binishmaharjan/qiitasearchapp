//
//  ListTableView.swift
//  QiitaApi
//
//  Created by guest on 2018/06/29.
//  Copyright © 2018年 guest. All rights reserved.
//

import Foundation
import UIKit

class ListTableView : BaseView{
  
  typealias Cell = CustomListCell
  let CELL_CLASS = Cell.self
  let CELL_ID = NSStringFromClass(Cell.self)
  
  var tableView : UITableView?
  var errorMessage = ""
  var delegate : ListViewDelegate?
  
  var articleArray: [Article]?{
    didSet{
      self.tableView?.reloadData()
    }
  }
  
  override func didInit() {
    super.didInit()
    setup()
    setupConstraints()
    
  }
  
  private func setup(){
    do{
      let tableView = UITableView()
      self.addSubview(tableView)
      self.tableView = tableView
      tableView.backgroundColor = Colors.mainWhite
      tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
      tableView.register(CELL_CLASS, forCellReuseIdentifier: CELL_ID)
      tableView.delegate = self
      tableView.dataSource = self
      
    }
  }
  
  private func setupConstraints(){
    guard let tableView = self.tableView else{return}
    do{
      tableView.translatesAutoresizingMaskIntoConstraints = false
      NSLayoutConstraint.activate([
        tableView.topAnchor.constraint(equalTo: self.topAnchor),
        tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        tableView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
        tableView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
  }
}


//MARK:- TableView Delegate and Datasource
extension ListTableView : UITableViewDelegate, UITableViewDataSource{
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return articleArray?.count ?? 1
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: CELL_ID) as? Cell
    
    var title = ""
    var name = ""
    var iconImage = UIImage(named: "blank") // 初めに空白アイコンを表示

    if let article = self.articleArray?[indexPath.row]{
      title = article.title
      name = article.user.id
      
      guard let imageURL = URL(string: article.user.profile_image_url) else {
        fatalError("imageURL Error!")
      }
//      var imageData = Data()
//      DispatchQueue.global(qos: .default).async {
//        do {
//          imageData = try Data(contentsOf: imageURL)
//        } catch {
//          print("imageURL Error! \(error.localizedDescription)")
//        }
//        DispatchQueue.main.async {
//          iconImage = UIImage(data: imageData)
//          cell?.mainView?.imageView?.image = iconImage
//          cell?.setNeedsLayout() // セルのみの再描画
//        }
//      }
      
      CacheImageService.getImage(withURL: imageURL) { (image) in
        iconImage = image
        cell?.mainView?.imageView?.image = iconImage
        cell?.setNeedsLayout()
      }
    }else{
      if errorMessage != "" { // エラーがある場合はエラーを表示
        title = errorMessage
      } else {
        title = "Loading...\n"
      }
    }
    
    cell?.mainView?.nameLabel?.text = name
    cell?.mainView?.lbl?.text = title
    cell?.mainView?.imageView?.image = iconImage
    cell?.mainView?.relayout()
  
    return cell!
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard  let delegate = self.delegate,
            let articleArray = self.articleArray else {return}
    let article  = articleArray[indexPath.row]
    delegate.itemIsClicked(url: article.url)
    
  }
  
  func loadMore(){
    delegate?.loadmore()
  }
}


//MARK:- ScrollView Delegate
//Detect the is the scroll view reached the end
extension ListTableView :UIScrollViewDelegate{
  func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    // UITableView only moves in one direction, y axis
    let currentOffset = scrollView.contentOffset.y
    let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
    
    // Change 10.0 to adjust the distance from bottom
    if maximumOffset - currentOffset <= 10.0 {
      self.loadMore()
    }
  }
}
