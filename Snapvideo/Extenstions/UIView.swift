//
//  UIView.swift
//  Snapvideo
//
//  Created by Anastasia Petrova on 16/03/2020.
//  Copyright © 2020 Anastasia Petrova. All rights reserved.
//

import UIKit

extension UIView {
    func setHiddenAnimated(_ isHidden: Bool, duration: TimeInterval) {
        if self.isHidden && !isHidden {
           self.isHidden = isHidden
        }
        
        UIView.animate(
            withDuration: duration,
            animations: {
                self.alpha = isHidden ? 0 : 1
        },
            completion: { (_) in
                self.isHidden = isHidden
        })
    }
}
