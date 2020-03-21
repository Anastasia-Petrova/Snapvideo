//
//  UILabel.swift
//  Snapvideo
//
//  Created by Anastasia Petrova on 21/03/2020.
//  Copyright © 2020 Anastasia Petrova. All rights reserved.
//

import UIKit

extension UILabel {
    func setText(_ text: String, animationDuration duration: TimeInterval) {
        UIView.transition(
            with: self,
            duration: duration,
            options: .transitionCrossDissolve,
            animations: {  self.text = text },
            completion: nil
        )
    }
}
