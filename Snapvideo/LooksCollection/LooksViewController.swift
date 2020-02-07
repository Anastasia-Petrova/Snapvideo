//
//  LooksViewController.swift
//  Snapvideo
//
//  Created by Anastasia Petrova on 07/02/2020.
//  Copyright © 2020 Anastasia Petrova. All rights reserved.
//

import UIKit

class LooksViewController: UIViewController {
    let dataSource: LooksCollectionDataSource
    let collectionView: UICollectionView

    init(itemSize: CGSize, filters: [AnyFilter], context: CIContext ) {
       self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: LooksCollectionViewLayout(itemSize: itemSize))
        self.dataSource = LooksCollectionDataSource(collectionView: collectionView, filters: filters, context: context)
       super.init(nibName: nil, bundle: nil)
   }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
}
