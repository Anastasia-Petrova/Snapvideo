//
//  LooksViewController.swift
//  Snapvideo
//
//  Created by Anastasia Petrova on 07/02/2020.
//  Copyright © 2020 Anastasia Petrova. All rights reserved.
//

import UIKit

final class LooksViewController: UIViewController {
    
    let dataSource: LooksCollectionDataSource
    let collectionView: UICollectionView
    var filterIndexChangeCallback: ((Int, Int) -> Void)?
    var pendingFilterIndex: Int?
    var selectedFilterIndex: Int
    var selectedFilter: AnyFilter {
        dataSource.filters[selectedFilterIndex]
    }

    convenience init(itemSize: CGSize, selectedFilterIndex: Int, filters: [AnyFilter]) {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: LooksCollectionViewLayout(itemSize: itemSize)
        )
        self.init(itemSize: itemSize, selectedFilterIndex: selectedFilterIndex, filters: filters, collectionView: collectionView)
    }
    
    init(itemSize: CGSize, selectedFilterIndex: Int, filters: [AnyFilter], collectionView: UICollectionView) {
        self.selectedFilterIndex = selectedFilterIndex
        self.collectionView = collectionView
        self.dataSource = LooksCollectionDataSource(
            collectionView: collectionView,
            filters: filters,
            context: CIContext(options: [CIContextOption.workingColorSpace : NSNull()])
        )
        super.init(nibName: nil, bundle: nil)
        collectionView.dataSource = dataSource
        collectionView.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCollectionView()
        collectionView.delegate?.collectionView?(collectionView, didSelectItemAt: IndexPath(item: selectedFilterIndex, section: 0))
    }
    
    func setUpCollectionView() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(collectionView)
        collectionView.backgroundColor = .white
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.allowsSelection = true
        collectionView.bounces = false
        
        NSLayoutConstraint.activate ([
            collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: self.view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
    
    func deselectFilter() {
        if let pendingFilterIndex = pendingFilterIndex {
            collectionView.deselectItem(at: IndexPath(item: pendingFilterIndex, section: 0), animated: false)
        }
        let indexPath = IndexPath(row: selectedFilterIndex, section: 0)
        collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .top)
        collectionView.delegate?.collectionView?(collectionView, didSelectItemAt: indexPath)
        pendingFilterIndex = nil
    }
}

extension LooksViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let previousIndex = selectedFilterIndex
        let pendingFilterIndex = indexPath.row
        self.pendingFilterIndex = pendingFilterIndex
        
        filterIndexChangeCallback?(pendingFilterIndex, previousIndex)
        
        if pendingFilterIndex != 0 {
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }
}
