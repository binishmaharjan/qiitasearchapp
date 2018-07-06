//
//  AlertController.swift
//  QiitaApi
//
//  Created by guest on 2018/07/03.
//  Copyright © 2018年 guest. All rights reserved.
//

import Foundation
import UIKit

class AlertController{
  static func showMessage(title: String, msg: String,handler : @escaping (UIAlertAction) -> Void) {
    let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertControllerStyle.alert)
    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: handler))
    UIApplication.topViewController()?.present(alert, animated: true, completion: nil)
  }
}
