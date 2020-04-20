//
//  UIView.swift
//  Snapvideo
//
//  Created by Anastasia Petrova on 16/03/2020.
//  Copyright © 2020 Anastasia Petrova. All rights reserved.
//

import UIKit

extension UIView {
    func setHiddenAnimated(_ isHidden: Bool, alpha: CGFloat = 1, duration: TimeInterval = 0.2) {
        if self.isHidden && !isHidden {
           self.isHidden = isHidden
        }
        
        UIView.animate(
            withDuration: duration,
            animations: {
                self.alpha = isHidden ? 0 : alpha
        },
            completion: { (_) in
                self.isHidden = isHidden
        })
    }
}
