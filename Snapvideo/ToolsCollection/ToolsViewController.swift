//
//  ToolsCollectionViewController.swift
//  Snapvideo
//
//  Created by Anastasia Petrova on 02/02/2020.
//  Copyright © 2020 Anastasia Petrova. All rights reserved.
//

import UIKit

final class ToolsViewController: UIViewController {
    let dataSource: ToolsCollectionDataSource
    let collectionView: UICollectionView

    init() {
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: ToolsCollectionViewLayout())
        self.dataSource = ToolsCollectionDataSource(collectionView: collectionView)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCollectionView()
    }
    
    func setUpCollectionView() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(collectionView)
        collectionView.backgroundColor = .white
        
        NSLayoutConstraint.activate ([
        collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
        collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
        collectionView.topAnchor.constraint(equalTo: self.view.topAnchor),
        collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
    
}
