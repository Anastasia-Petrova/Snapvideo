//
//  ToolsCollectionDataSource.swift
//  Snapvideo
//
//  Created by Anastasia Petrova on 02/02/2020.
//  Copyright © 2020 Anastasia Petrova. All rights reserved.
//

import UIKit

class ToolsCollectionDataSource: NSObject, UICollectionViewDataSource {
    //TODO: Параметризировать инициализатор с коллекций тулзов
    init(collectionView: UICollectionView) {
        super.init()
        collectionView.dataSource = self
        collectionView.register(ToolsCollectionViewCell.self, forCellWithReuseIdentifier: ToolsCollectionViewCell.identifier)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ToolsCollectionViewCell.identifier, for: indexPath) as! ToolsCollectionViewCell
        cell.toolName.text = "Crop"
        return cell
    }
}
