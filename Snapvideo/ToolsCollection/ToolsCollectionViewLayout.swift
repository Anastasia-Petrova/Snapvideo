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
    static let numberOfItemsInRow: Int = 4
    
    override init() {
        super.init()
        itemSize = .zero
        sectionInset = UIEdgeInsets(
            top: Self.spacing,
            left: Self.spacing,
            bottom: Self.spacing,
            right: Self.spacing
        )
        minimumLineSpacing = Self.spacing/2.0
        scrollDirection = .vertical
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setContainerWidth(_ width: CGFloat) {
        itemSize = Self.getItemSize(containerWidth: width)
    }
    
    static func getItemSize(containerWidth width: CGFloat) -> CGSize {
        let itemWidth = (width - spacing * 5)/CGFloat(numberOfItemsInRow)
        return CGSize(width: itemWidth, height: itemWidth * 1.2)
    }
}
