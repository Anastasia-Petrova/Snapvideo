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

final class LooksCollectionDataSourceTests: XCTestCase {
    var dataSource: LooksCollectionDataSource!
    var collectionView: UICollectionView!
    var context: CIContext!

    override func setUp() {
        super.setUp()
        context = CIContext(options: [CIContextOption.workingColorSpace : NSNull()])
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
        dataSource = LooksCollectionDataSource(collectionView: collectionView, filters: [], context: context)
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
        let sut = LooksCollectionDataSource(collectionView: collectionView, filters: filters, context: context)
        
        //Then
        XCTAssertEqual(sut.filters, filters)
        XCTAssertEqual(sut.collectionView, collectionView)
    }
    
    func test_init_sets_collectionView_dataSource() {
        //Given
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
        
        //When
        let sut = LooksCollectionDataSource(collectionView: collectionView, filters: [], context: context)
        
        //Then
        XCTAssertEqual(collectionView.dataSource?.isEqual(sut), true)
    }
    
    func test_register_cell() {
        //Given
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
        
        //When
        let _ = LooksCollectionDataSource(collectionView: collectionView, filters: [], context: context)
        
        //Then 
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "LooksCollectionViewCell",
            for: .init()
        )
        
        XCTAssertTrue(cell is LooksCollectionViewCell)
    }
    
    func test_numberOfItemsInSection_isEqual_to_filtersCount() {
        //Given
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
        let filters = [
            AnyFilter(PassthroughFilter())
        ]
        
        //When
        let sut = LooksCollectionDataSource(collectionView: collectionView, filters: filters, context: context)
        
        //Then
        let numberOfCells = sut.collectionView(collectionView, numberOfItemsInSection: 0)
        XCTAssertEqual(filters.count, numberOfCells)
    }
    
    func test_numberOfSection() {
        //Given
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
        
        //When
        let sut = LooksCollectionDataSource(collectionView: collectionView, filters: [], context: context)
        
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
        let sut = LooksCollectionDataSource(collectionView: collectionView, filters: filters, context: context)
        
        //Then
        let cell = sut.collectionView(collectionView, cellForItemAt: IndexPath(item: 0, section: 0))
        
        XCTAssertTrue(cell is LooksCollectionViewCell)
    }
    
    func test_when_has_noOriginalImage_cell_previewImage_is_placeholder() {
        //Given
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
        let filters = [
            AnyFilter(PassthroughFilter())
        ]
        let placeholder = UIImage(named: "placeholder")!
        let sut = LooksCollectionDataSource(collectionView: collectionView, filters: filters, context: context)
        sut.image = nil
        
        //When
        let cell = sut.collectionView(collectionView, cellForItemAt: IndexPath(item: 0, section: 0))
        
        //Then
        guard let filterCell = cell as? LooksCollectionViewCell else {
            XCTFail("expected LooksCollectionViewCell, got \(cell.self)")
            return
        }
        assertEqual(placeholder, filterCell.previewImageView.image!)
    }
    
    func test_when_originalImage_cell_previewImage_is_filteredOriginalImage() {
        //Given
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
        let filter = AnyFilter(BlurFilter(blurRadius: 10))
        let image = UIImage(named: "testImage", in: .unitTests, with: nil)!
        
        let filteredCIImage = filter.apply(CIImage(cgImage: image.cgImage!))
        let filteredCGImage = context.createCGImage(filteredCIImage, from: filteredCIImage.extent)!
        let expectedImage = UIImage(cgImage: filteredCGImage)
        
        let sut = LooksCollectionDataSource(collectionView: collectionView, filters: [filter], context: context)
        sut.image = image
        let expectation = XCTestExpectation(description: "finished filtering image")
        
        //When
        let _ = sut.collectionView(collectionView, cellForItemAt: IndexPath(item: 0, section: 0))
        
        sut.cellForItemCallback = {
            //Then
            let cell = sut.collectionView(collectionView, cellForItemAt: IndexPath(item: 0, section: 0))
            guard let filterCell = cell as? LooksCollectionViewCell else {
                XCTFail("expected LooksCollectionViewCell, got \(cell.self)")
                return
            }
            assertEqual(filterCell.previewImageView.image!, expectedImage)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5)
    }
    
    func test_cell_name_is_filter_name() {
        //Given
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
        let filter = AnyFilter(BlurFilter(blurRadius: 10))
        let sut = LooksCollectionDataSource(collectionView: collectionView, filters: [filter], context: context)
        
        //When
        let cell = sut.collectionView(collectionView, cellForItemAt: IndexPath(item: 0, section: 0))
        
        //Then
        guard let filterCell = cell as? LooksCollectionViewCell else {
            XCTFail("expected LooksCollectionViewCell, got \(cell.self)")
            return
        }
        
        XCTAssertEqual(filter.name, filterCell.filterName.text)
    }
    
    func test_cellPreviewImage_is_taken_from_cache() {
        //Given
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
        let filter = AnyFilter(BlurFilter(blurRadius: 10))
        let sut = LooksCollectionDataSource(collectionView: collectionView, filters: [filter], context: context)
        sut.image = nil
        let expectedImage = UIImage(named: "testImage", in: .unitTests, with: nil)!
        sut.filteredImages["Blur"] = expectedImage
        //When
        let cell = sut.collectionView(collectionView, cellForItemAt: IndexPath(item: 0, section: 0))
        //Then
        guard let filterCell = cell as? LooksCollectionViewCell else {
            XCTFail("expected LooksCollectionViewCell, got \(cell.self)")
            return
        }
        
        XCTAssertEqual(
            filterCell.previewImageView.image,
            expectedImage
        )
    }
    
    func test_adding_filtered_images_to_cache() {
        //Given
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
        let filter = AnyFilter(BlurFilter(blurRadius: 10))
        let image = UIImage(named: "testImage", in: .unitTests, with: nil)!
        let filteredCIImage = filter.apply(CIImage(cgImage: image.cgImage!))
        let filteredCGImage = context.createCGImage(filteredCIImage, from: filteredCIImage.extent)!
        let expectedImage = UIImage(cgImage: filteredCGImage)
        let sut = LooksCollectionDataSource(collectionView: collectionView, filters: [filter], context: context)
        sut.image = UIImage(named: "testImage", in: .unitTests, with: nil)!

        
        //When
        let expectation = XCTestExpectation(description: "added filtered image to cache")
        let _ = sut.collectionView(collectionView, cellForItemAt: IndexPath(item: 0, section: 0))
        
        sut.cellForItemCallback = {
            //Then
            guard let actualImage = sut.filteredImages["Blur"] else {
                XCTFail("expected to get image from filteredImages cache")
                return
            }
            assertEqual(expectedImage, actualImage)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5)
    }
    
    func test_filterAsync() {
        //Given
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
        let filter = AnyFilter(BlurFilter(blurRadius: 10))
        let image = UIImage(named: "testImage", in: .unitTests, with: nil)!
        
        let filteredCIImage = filter.apply(CIImage(cgImage: image.cgImage!))
        let filteredCGImage = context.createCGImage(filteredCIImage, from: filteredCIImage.extent)!
        let expectedImage = UIImage(cgImage: filteredCGImage)
        
        let sut = LooksCollectionDataSource(collectionView: collectionView, filters: [filter], context: context)
        
        //When
        let expectation = XCTestExpectation(description: "finished filtering image")
        sut.filterAsync(image: image, indexPath: IndexPath(row: 0, section: 0)) { (actualImage) in
            //Then
            guard let actualImage = actualImage else {
                XCTFail("expected to get image with filterAsync callback")
                return
            }
            assertEqual(expectedImage, actualImage)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5)
    }
}
