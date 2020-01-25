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
        //Given
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
        let filters = [
            AnyFilter(PassthroughFilter())
        ]
        
        //When
        let sut = FilterCollectionDataSource(collectionView: collectionView, filters: filters)
        
        //Then
        XCTAssertEqual(sut.filters, filters)
        XCTAssertEqual(sut.collectionView, collectionView)
    }
    
    func test_init_sets_collectionView_dataSource() {
        //Given
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
        
        //When
        let sut = FilterCollectionDataSource(collectionView: collectionView, filters: [])
        
        //Then
        XCTAssertEqual(collectionView.dataSource?.isEqual(sut), true)
    }
    
    func test_register_cell() {
        //Given
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
        
        //When
        let _ = FilterCollectionDataSource(collectionView: collectionView, filters: [])
        
        //Then 
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "effectsCollectionViewCell",
            for: .init()
        )
        
        XCTAssertTrue(cell is EffectsCollectionViewCell)
    }
    
    func test_numberOfItemsInSection_isEqual_to_filtersCount() {
        //Given
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
        let filters = [
            AnyFilter(PassthroughFilter())
        ]
        
        //When
        let sut = FilterCollectionDataSource(collectionView: collectionView, filters: filters)
        
        //Then
        let numberOfCells = sut.collectionView(collectionView, numberOfItemsInSection: 0)
        XCTAssertEqual(filters.count, numberOfCells)
    }
    
    func test_numberOfSection() {
        //Given
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
        
        //When
        let sut = FilterCollectionDataSource(collectionView: collectionView, filters: [])
        
        //Then
        let numberOfSections = sut.numberOfSections(in: collectionView)
        
        XCTAssertEqual(1, numberOfSections)
    }
    
    func test_cellType() {
        //Given
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
        let filters = [
            AnyFilter(PassthroughFilter())
        ]
        
        //When
        let sut = FilterCollectionDataSource(collectionView: collectionView, filters: filters)
        
        //Then
        let cell = sut.collectionView(collectionView, cellForItemAt: IndexPath(item: 0, section: 0))
        
        XCTAssertTrue(cell is EffectsCollectionViewCell)
    }
}
