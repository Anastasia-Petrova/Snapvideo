//
//  LooksViewControllerTests.swift
//  UnitTests
//
//  Created by Anastasia Petrova on 09/02/2020.
//  Copyright © 2020 Anastasia Petrova. All rights reserved.
//

import XCTest
@testable import Snapvideo

final class LooksViewControllerTests: XCTestCase {
    func test_init_assigns_properties() {
        //Given
        let expectedItemSize = CGSize(width: 60, height: 76)
        let expectedFilters = [AnyFilter(PassthroughFilter())]
        //When
        let vc = LooksViewController(itemSize: expectedItemSize, filters: expectedFilters) {_,_ in }
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
        var actualSelectedIndex: Int?
        var actualPreviousIndex: Int?
        let vc = LooksViewController(itemSize: .zero, filters: []) { selectedIndex, previousIndex in
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
    
    func test_didSelect_when_indexPathRow_notZero_calls_collectionView_scrollToItem() {
        //Given
        let expectedIndexPath = IndexPath(item: 1, section: 0)
        let vc = LooksViewController(itemSize: .zero, filters: []) {_,_ in }
        let spy = CollectionViewSpy()
        //When
        vc.collectionView(spy, didSelectItemAt: expectedIndexPath)
        //Then
        XCTAssertEqual(spy.scrollToItemIndexPath, expectedIndexPath)
        XCTAssertEqual(spy.scrollToItemScrollPosition, .centeredHorizontally)
        XCTAssertEqual(spy.scrollToItemAnimated, true)
    }
    
    func test_didSelect_when_indexPathRow_isZero_doesnt_call_collectionView_scrollToItem() {
        //Given
        let expectedIndexPath = IndexPath(item: 0, section: 0)
        let vc = LooksViewController(itemSize: .zero, filters: []) {_,_ in }
        let spy = CollectionViewSpy()
        //When
        vc.collectionView(spy, didSelectItemAt: expectedIndexPath)
        //Then
        XCTAssertNil(spy.scrollToItemIndexPath)
        XCTAssertNil(spy.scrollToItemScrollPosition)
        XCTAssertNil(spy.scrollToItemAnimated)
    }
    
    func test_deselectFilter_calls_deselectItem_and_selectItem_and_didSelectItem() {
        //Given
        let collectionSpy = CollectionViewSpy()
        let delegateSpy = CollectionViewDelegateSpy()
        let vc = LooksViewController(itemSize: .zero, filters: App.unitTests.filters, collectionView: collectionSpy) {_,_ in }
        collectionSpy.delegate = delegateSpy
        let expectedDeselectedIndex = 2
        vc.selectedFilterIndex = expectedDeselectedIndex
        //When
        vc.deselectFilter()
        //Then
        XCTAssertEqual(collectionSpy.deselectItemAnimated, false)
        XCTAssertEqual(collectionSpy.deselectItemIndexPath, IndexPath(item: expectedDeselectedIndex, section: 0))
        XCTAssertEqual(collectionSpy.selectItemIndexPath, IndexPath(item: 0, section: 0))
        XCTAssertEqual(collectionSpy.selectItemAnimated, false)
        XCTAssertEqual(collectionSpy.selectItemScrollPosition, .top)
        XCTAssertEqual(delegateSpy.didSelectIndexPath, IndexPath(item: 0, section: 0))
        XCTAssertEqual(delegateSpy.didSelectCollectionView, collectionSpy)
    }
}

private final class CollectionViewSpy: UICollectionView {
    //scrollToItem props
    var scrollToItemIndexPath: IndexPath?
    var scrollToItemScrollPosition: UICollectionView.ScrollPosition?
    var scrollToItemAnimated: Bool?
    
    //deselect props
    var deselectItemIndexPath: IndexPath?
    var deselectItemAnimated: Bool?
    
    //select props
    var selectItemIndexPath: IndexPath?
    var selectItemScrollPosition: UICollectionView.ScrollPosition?
    var selectItemAnimated: Bool?
    
    init() {
        super.init(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func scrollToItem(at indexPath: IndexPath, at scrollPosition: UICollectionView.ScrollPosition, animated: Bool) {
        scrollToItemIndexPath = indexPath
        scrollToItemScrollPosition = scrollPosition
        scrollToItemAnimated = animated
    }
    
    override func deselectItem(at indexPath: IndexPath, animated: Bool) {
        deselectItemIndexPath = indexPath
        deselectItemAnimated = animated
    }
    
    override func selectItem(at indexPath: IndexPath?, animated: Bool, scrollPosition: UICollectionView.ScrollPosition) {
        selectItemIndexPath = indexPath
        selectItemAnimated = animated
        selectItemScrollPosition = scrollPosition
    }
}

private final class CollectionViewDelegateSpy: NSObject, UICollectionViewDelegate {
    var didSelectIndexPath: IndexPath?
    var didSelectCollectionView: UICollectionView?
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didSelectCollectionView = collectionView
        didSelectIndexPath = indexPath
    }
}
