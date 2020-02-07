//
//  LooksCollectionViewCellTests.swift
//  SnapvideoTests
//
//  Created by Anastasia Petrova on 07/02/2020.
//  Copyright © 2020 Anastasia Petrova. All rights reserved.
//

import XCTest
import SnapshotTesting
@testable import Snapvideo

class LooksCollectionViewCellTests: XCTestCase {
    func testLooksCollectionViewCell_image_has_Placeholder() {
        let cell = LooksCollectionViewCell(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 60, height: 76)))
        cell.filterName.text = "BlurFilter"
        assertSnapshot(matching: cell, as: .image)
    }
    
    func testLooksCollectionViewCell_long_name() {
        let cell = LooksCollectionViewCell(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 60, height: 76)))
        cell.filterName.text = "BlurFilterBlurFilterBlurFilterBlurFilterBlurFilterBlurFilterBlurFilterBlurFilterBlurFilterBlurFilter"
        assertSnapshot(matching: cell, as: .image)
    }
    
    func testLooksCollectionViewCell_image() {
        let cell = LooksCollectionViewCell(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 60, height: 76)))
        cell.filterName.text = "BlurFilter"
        assertSnapshot(matching: cell, as: .image)
    }
}
