//
//  ToolsCollectionViewLayout.swift
//  Snapvideo
//
//  Created by Anastasia Petrova on 07/02/2020.
//  Copyright © 2020 Anastasia Petrova. All rights reserved.
//

import UIKit

final class ToolsCollectionViewLayout: UICollectionViewFlowLayout {
    static let spacing: CGFloat = 20.0
    
    override init() {
        super.init()
        self.itemSize = .zero
        self.sectionInset = UIEdgeInsets(
            top: Self.spacing,
            left: Self.spacing,
            bottom: Self.spacing,
            right: Self.spacing
        )
        self.minimumLineSpacing = Self.spacing/2.0
        self.scrollDirection = .vertical
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setWidth(width: CGFloat) {
        let itemWidth = (width - Self.spacing * 5)/4.0
        self.itemSize = CGSize(width: itemWidth, height: itemWidth * 1.2)
    }
}
