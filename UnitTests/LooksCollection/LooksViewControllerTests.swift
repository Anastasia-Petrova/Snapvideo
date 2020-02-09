//
//  LooksViewControllerTests.swift
//  UnitTests
//
//  Created by Anastasia Petrova on 09/02/2020.
//  Copyright © 2020 Anastasia Petrova. All rights reserved.
//

import XCTest
@testable import Snapvideo

class LooksViewControllerTests: XCTestCase {
    func test_init_assigns_properties() {
        //Given
        let expectedItemSize = CGSize(width: 60, height: 76)
        let expectedFilters = [AnyFilter(PassthroughFilter())]
        //When
        let vc = LooksViewController(itemSize: expectedItemSize, filters: expectedFilters)
        let dataSource = vc.dataSource
        let layout = vc.collectionView.collectionViewLayout
        let collectionView = vc.collectionView
        //Then
        guard let looksLayout = layout as? LooksCollectionViewLayout else {
            XCTFail("Expected LooksCollectionViewLayout, got \(layout.self)")
            return
        }
        XCTAssertEqual(looksLayout.itemSize, expectedItemSize)
        XCTAssertEqual(dataSource.filters, expectedFilters)
        XCTAssertEqual(dataSource.collectionView, collectionView)
        XCTAssertEqual(collectionView.delegate?.isEqual(vc), true)
        XCTAssertEqual(collectionView.dataSource?.isEqual(dataSource), true)
    }
}
