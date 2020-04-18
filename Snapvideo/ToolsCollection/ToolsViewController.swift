//
//  ToolsCollectionViewController.swift
//  Snapvideo
//
//  Created by Anastasia Petrova on 02/02/2020.
//  Copyright © 2020 Anastasia Petrova. All rights reserved.
//

import UIKit

final class ToolsViewController: UIViewController {
    typealias Callback = ((Int) -> Void)
    
    let dataSource: ToolsCollectionDataSource
    let collectionView: UICollectionView
    var didSelectToolCallback: Callback?

    init(tools: [ToolEnum]) {
        self.collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: ToolsCollectionViewLayout()
        )
        self.dataSource = ToolsCollectionDataSource(collectionView: collectionView, tools: tools)
        super.init(nibName: nil, bundle: nil)
        collectionView.delegate = self
    
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCollectionView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if let toolsLayout = collectionView.collectionViewLayout as? ToolsCollectionViewLayout {
            toolsLayout.setWidth(width: view.frame.width)
        }
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

extension ToolsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didSelectToolCallback?(indexPath.row)
    }
}
