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
        XCTAssertEqual(vc.selectedFilterIndex, 0)
        XCTAssertEqual(looksLayout.itemSize, expectedItemSize)
        XCTAssertEqual(dataSource.filters, expectedFilters)
        XCTAssertEqual(dataSource.collectionView, collectionView)
        XCTAssertEqual(collectionView.delegate?.isEqual(vc), true)
        XCTAssertEqual(collectionView.dataSource?.isEqual(dataSource), true)
    }
    
    func test_didSelect_calls_filterIndexChangeCallback() {
        //Given
        let expectedIndexPath = IndexPath(item: 1, section: 0)
        let vc = LooksViewController(itemSize: .zero, filters: [])
        
        var actualSelectedIndex: Int?
        var actualPreviousIndex: Int?
        vc.filterIndexChangeCallback = { selectedIndex, previousIndex in
            actualSelectedIndex = selectedIndex
            actualPreviousIndex = previousIndex
        }
        
        //When
        vc.collectionView(vc.collectionView, didSelectItemAt: expectedIndexPath)
        //Then
        XCTAssertEqual(vc.selectedFilterIndex, actualSelectedIndex)
        XCTAssertEqual(expectedIndexPath.row, actualSelectedIndex)
        XCTAssertEqual(0, actualPreviousIndex)
    }
    
    func test_didSelect_calls_collectionView_scrollToItem() {
        //Given
        let expectedIndexPath = IndexPath(item: 1, section: 0)
        let vc = LooksViewController(itemSize: .zero, filters: [])
        let spy = CollectionViewSpy()
        //When
        vc.collectionView(spy, didSelectItemAt: expectedIndexPath)
        //Then
        XCTAssertEqual(spy.actualIndexPath, expectedIndexPath)
        XCTAssertEqual(spy.actualScrollPosition, .centeredHorizontally)
        XCTAssertEqual(spy.actualAnimated, true)
    }
}

private final class CollectionViewSpy: UICollectionView {
    var actualIndexPath: IndexPath?
    var actualScrollPosition: UICollectionView.ScrollPosition?
    var actualAnimated: Bool?
    
    init() {
        super.init(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func scrollToItem(at indexPath: IndexPath, at scrollPosition: UICollectionView.ScrollPosition, animated: Bool) {
        actualIndexPath = indexPath
        actualScrollPosition = scrollPosition
        actualAnimated = animated
    }
}
