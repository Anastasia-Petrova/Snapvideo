//
//  VideoTestTests.swift
//  VideoTestTests
//
//  Created by Anastasia Petrova on 24/01/2020.
//  Copyright © 2020 Anastasia Petrova. All rights reserved.
//

import XCTest
@testable import VideoTest

final class VideoTestTests: XCTestCase {
    var dataSource: EffectsCollectionViewDataSource!
    var collectionView: UICollectionView!

    override func setUp() {
        super.setUp()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
        dataSource = EffectsCollectionViewDataSource(collectionView: collectionView, filters: [])
    }

    override func tearDown() {
        super.tearDown()
        dataSource = nil
        collectionView = nil
    }

    func testInit() {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
        let filters = [AnyFilter(PassthroughFilter())]
        let sut = EffectsCollectionViewDataSource(collectionView: collectionView, filters: filters)
        
        
        XCTAssertEqual(sut.filters, filters)
    }
}
