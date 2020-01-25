//
//  FilterCollectionDataSourceTests.swift
//  FilterCollectionDataSourceTests
//
//  Created by Anastasia Petrova on 24/01/2020.
//  Copyright © 2020 Anastasia Petrova. All rights reserved.
//

import XCTest
@testable import Snapvideo

final class FilterCollectionDataSourceTests: XCTestCase {
    var dataSource: FilterCollectionDataSource!
    var collectionView: UICollectionView!

    override func setUp() {
        super.setUp()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
        dataSource = FilterCollectionDataSource(collectionView: collectionView, filters: [])
    }

    override func tearDown() {
        super.tearDown()
        dataSource = nil
        collectionView = nil
    }

    func test_init_propertyAssignment() {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
        let filters = [
            AnyFilter(PassthroughFilter())
        ]
        let sut = FilterCollectionDataSource(collectionView: collectionView, filters: filters)
        
        
        XCTAssertEqual(sut.filters, filters)
        XCTAssertEqual(sut.collectionView, collectionView)
    }
    
    func test_init_sets_collectionView_dataSource() {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
        let sut = FilterCollectionDataSource(collectionView: collectionView, filters: [])
        
        XCTAssertEqual(collectionView.dataSource?.isEqual(sut), true)
    }
    
    func test_register_cell() {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
        let _ = FilterCollectionDataSource(collectionView: collectionView, filters: [])
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "effectsCollectionViewCell",
            for: .init()
        )
        
        XCTAssertTrue(cell is EffectsCollectionViewCell)
    }
}
