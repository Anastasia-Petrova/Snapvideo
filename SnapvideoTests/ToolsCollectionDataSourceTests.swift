//
//  ToolsCollectionViewDataSourceTests.swift
//  SnapvideoTests
//
//  Created by Anastasia Petrova on 04/02/2020.
//  Copyright © 2020 Anastasia Petrova. All rights reserved.
//

import Foundation
import UIKit
import XCTest
@testable import Snapvideo

final class ToolsCollectionDataSourceTests: XCTestCase {
    var dataSource: ToolsCollectionDataSource!
    var collectionView: UICollectionView!
    
    override func setUp() {
        super.setUp()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
        dataSource = ToolsCollectionDataSource()
    }

    override func tearDown() {
        super.tearDown()
        dataSource = nil
        collectionView = nil
    }
    
    func test_numberOfSection() {
        //When
        let sut = ToolsCollectionDataSource()
        
        //Then
        let numberOfSections = sut.numberOfSections(in: collectionView)
        
        XCTAssertEqual(1, numberOfSections)
    }
    
    func test_numberOfItemsInSection_isEqual_to_one() {
        //When
        let sut = ToolsCollectionDataSource()
        
        //Then
        let numberOfCells = sut.collectionView(collectionView, numberOfItemsInSection: 0)
        XCTAssertEqual(1, numberOfCells)
    }
    
    func test_cellType() {
        //When
        let sut = ToolsCollectionDataSource()
        
        //Then
        let cell = sut.collectionView(collectionView, cellForItemAt: IndexPath(item: 0, section: 0))
        
        XCTAssertTrue(cell is ToolsCollectionViewCell)
    }
    
    
    
}
