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
        self.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        self.minimumLineSpacing = 20
        self.scrollDirection = .vertical
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
