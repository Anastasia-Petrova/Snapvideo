//
//  FilterCollectionDataSourceTests.swift
//  FilterCollectionDataSourceTests
//
//  Created by Anastasia Petrova on 24/01/2020.
//  Copyright © 2020 Anastasia Petrova. All rights reserved.
//

import Foundation
import UIKit
import XCTest
@testable import Snapvideo

final class FilterCollectionDataSourceTests: XCTestCase {
    var dataSource: FilterCollectionDataSource!
    var collectionView: UICollectionView!
    var context: CIContext!

    override func setUp() {
        super.setUp()
        context = CIContext(options: [CIContextOption.workingColorSpace : NSNull()])
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
        dataSource = FilterCollectionDataSource(collectionView: collectionView, filters: [], context: context)
    }

    override func tearDown() {
        super.tearDown()
        dataSource = nil
        context = nil
        collectionView = nil
    }

    func test_init_propertyAssignment() {
        //Given
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
        let filters = [
            AnyFilter(PassthroughFilter())
        ]
        
        //When
        let sut = FilterCollectionDataSource(collectionView: collectionView, filters: filters, context: context)
        
        //Then
        XCTAssertEqual(sut.filters, filters)
        XCTAssertEqual(sut.collectionView, collectionView)
    }
    
    func test_init_sets_collectionView_dataSource() {
        //Given
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
        
        //When
        let sut = FilterCollectionDataSource(collectionView: collectionView, filters: [], context: context)
        
        //Then
        XCTAssertEqual(collectionView.dataSource?.isEqual(sut), true)
    }
    
    func test_register_cell() {
        //Given
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
        
        //When
        let _ = FilterCollectionDataSource(collectionView: collectionView, filters: [], context: context)
        
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
        let sut = FilterCollectionDataSource(collectionView: collectionView, filters: filters, context: context)
        
        //Then
        let numberOfCells = sut.collectionView(collectionView, numberOfItemsInSection: 0)
        XCTAssertEqual(filters.count, numberOfCells)
    }
    
    func test_numberOfSection() {
        //Given
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
        
        //When
        let sut = FilterCollectionDataSource(collectionView: collectionView, filters: [], context: context)
        
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
        let sut = FilterCollectionDataSource(collectionView: collectionView, filters: filters, context: context)
        
        //Then
        let cell = sut.collectionView(collectionView, cellForItemAt: IndexPath(item: 0, section: 0))
        
        XCTAssertTrue(cell is EffectsCollectionViewCell)
    }
    
    func test_when_has_noOriginalImage_cell_previewImage_is_placeholder() {
        //Given
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
        let filters = [
            AnyFilter(PassthroughFilter())
        ]
        let placeholder = UIImage(named: "placeholder")!
        let sut = FilterCollectionDataSource(collectionView: collectionView, filters: filters, context: context)
        sut.image = nil
        
        //When
        let cell = sut.collectionView(collectionView, cellForItemAt: IndexPath(item: 0, section: 0))
        
        //Then
        guard let filterCell = cell as? EffectsCollectionViewCell else {
            XCTFail("expected EffectsCollectionViewCell, got \(cell.self)")
            return
        }
        assertEqual(placeholder, filterCell.previewImageView.image!)
    }
    
    func test_when_originalImage_cell_previewImage_is_filteredOriginalImage() {
        //Given
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
        let filter = AnyFilter(BlurFilter(blurRadius: 10))
        let image = UIImage(named: "testImage", in: .testBundle, with: nil)!
        
        let filteredCIImage = filter.apply(CIImage(cgImage: image.cgImage!))
        let filteredCGImage = context.createCGImage(filteredCIImage, from: filteredCIImage.extent)!
        let filteredImage = UIImage(cgImage: filteredCGImage)
        
        let sut = FilterCollectionDataSource(collectionView: collectionView, filters: [filter], context: context)
        sut.image = image
        
        //When
        let cell = sut.collectionView(collectionView, cellForItemAt: IndexPath(item: 0, section: 0))
        
        //Then
        guard let filterCell = cell as? EffectsCollectionViewCell else {
            XCTFail("expected EffectsCollectionViewCell, got \(cell.self)")
            return
        }
        assertEqual(filterCell.previewImageView.image!, filteredImage)
    }
    
    func test_cell_name_is_filter_name() {
        //Given
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
        let filter = AnyFilter(BlurFilter(blurRadius: 10))
        let sut = FilterCollectionDataSource(collectionView: collectionView, filters: [filter], context: context)
        
        //When
        let cell = sut.collectionView(collectionView, cellForItemAt: IndexPath(item: 0, section: 0))
        
        //Then
        guard let filterCell = cell as? EffectsCollectionViewCell else {
            XCTFail("expected EffectsCollectionViewCell, got \(cell.self)")
            return
        }
        
        XCTAssertEqual(filter.name, filterCell.filterName.text)
    }
}
