//
//  TabBarItem.swift
//  Snapvideo
//
//  Created by Anastasia Petrova on 02/02/2020.
//  Copyright © 2020 Anastasia Petrova. All rights reserved.
//

import UIKit

final class TabBarItem: UITabBarItem {
    init(title: String) {
        super.init()
        self.title = title
        self.setTitleTextAttributes(
            [
                NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14, weight: .semibold),
                NSAttributedString.Key.foregroundColor : UIColor.systemBlue
            ],
            for: .normal
        )
        self.titlePositionAdjustment = .init(horizontal: 0, vertical: -9)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
