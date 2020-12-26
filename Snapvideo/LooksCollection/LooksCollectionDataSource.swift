//
//  LooksCollectionDataSource.swift
//  Snapvideo
//
//  Created by Anastasia Petrova on 02/02/2020.
//  Copyright © 2020 Anastasia Petrova. All rights reserved.
//

import UIKit

final class LooksCollectionDataSource: NSObject, UICollectionViewDataSource {
    private static let reusableIdentifier = "LooksCollectionViewCell"
    weak var collectionView: UICollectionView?
    let filters: [AnyFilter]
    var filteredImages: [String: UIImage] = [:]
    var image: UIImage? {
        didSet {
            collectionView?.reloadData()
        }
    }
    
    private let context: CIContext
    
    init(collectionView: UICollectionView, filters: [AnyFilter], context: CIContext) {
        self.filters = filters
        self.collectionView = collectionView
        self.context = context
        super.init()
        collectionView.dataSource = self
        collectionView.register(
            LooksCollectionViewCell.self,
            forCellWithReuseIdentifier: "LooksCollectionViewCell"
        )
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filters.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    #if TEST
    var unitTestCallback: (() -> Void)?
    #endif
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Self.reusableIdentifier, for: indexPath) as! LooksCollectionViewCell
        cell.filterName.text = filters[indexPath.row].name
        
        if let filteredImage = filteredImages[filters[indexPath.row].name] {
            cell.previewImageView.image = filteredImage
        } else if let image = image {
            applyFilter(on: image, at: indexPath) { [weak self] (filteredImage) in
                DispatchQueue.main.async {
                    guard let self = self else { return }
                    self.filteredImages[self.filters[indexPath.row].name] = filteredImage
                    collectionView.reloadItems(at: [indexPath])
                    #if TEST
                    self.unitTestCallback?()
                    #endif
                }
            }
        } else {
            cell.previewImageView.image = UIImage(named: "placeholder")
        }
        
        return cell
    }
    
    func applyFilter(on image: UIImage, at indexPath: IndexPath, callback: @escaping (UIImage?) -> Void) {
        guard let cgImage = image.cgImage else {
            callback(nil)
            return
        }
        
        DispatchQueue.global().async {
            let ciImage = CIImage(cgImage: cgImage)
            let filteredCIImage = self.filters[indexPath.row].apply(ciImage)
            if let filteredCGImage = self.context.createCGImage(filteredCIImage, from: filteredCIImage.extent) {
                callback(UIImage(cgImage: filteredCGImage))
            } else {
                callback(nil)
            }
        }
    }
}
