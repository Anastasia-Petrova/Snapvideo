//
//  ToolsCollectionViewLayout.swift
//  Snapvideo
//
//  Created by Anastasia Petrova on 07/02/2020.
//  Copyright © 2020 Anastasia Petrova. All rights reserved.
//

import UIKit

final class ToolsCollectionViewLayout: UICollectionViewFlowLayout {
    override init() {
        super.init()
        self.itemSize = CGSize(width: 60, height: 76)
        self.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        self.minimumLineSpacing = 5
        self.scrollDirection = .vertical
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
