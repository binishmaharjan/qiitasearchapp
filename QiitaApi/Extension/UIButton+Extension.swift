//
//  UIButton+Extesnion.swift
//  QiitaApi
//
//  Created by guest on 2018/07/02.
//  Copyright © 2018年 guest. All rights reserved.
//

import UIKit

extension UIButton{
  
  open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesBegan(touches, with: event)
    UIView.animate(withDuration: 0.2) {
      self.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
    }
  }
  
  open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesEnded(touches, with: event)
    UIView.animate(withDuration: 0.2, delay: 0.2, options: UIViewAnimationOptions.curveEaseInOut, animations: {
      self.transform = CGAffineTransform.identity
    }, completion: nil)
  }
}
