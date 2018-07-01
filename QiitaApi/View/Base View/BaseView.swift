//
//  BaseView.swift
//  QiitaApi
//
//  Created by guest on 2018/06/29.
//  Copyright © 2018年 guest. All rights reserved.
//

import Foundation
import UIKit

class BaseView : UIView{
  convenience init(){self.init(frame : .zero)}

  override init(frame : CGRect){
    super.init(frame : frame)
    didInit()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func didInit(){}
}
