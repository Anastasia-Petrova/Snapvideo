//
//  LookCollectionViewLayoutTests.swift
//  UnitTests
//
//  Created by Anastasia Petrova on 09/02/2020.
//  Copyright © 2020 Anastasia Petrova. All rights reserved.
//

import XCTest
import UIKit
@testable import Snapvideo

final class LookCollectionViewLayoutTests: XCTestCase {
    func test_properties() {
        let expectedSize = CGSize(width: 60, height: 76)
        let looksCollectionViewLayout = LooksCollectionViewLayout(itemSize: expectedSize)
        
        XCTAssertEqual(
            looksCollectionViewLayout.sectionInset,
            UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        )
        XCTAssertEqual(looksCollectionViewLayout.minimumLineSpacing, 5)
        XCTAssertEqual(looksCollectionViewLayout.scrollDirection, .horizontal)
        XCTAssertEqual(looksCollectionViewLayout.itemSize, expectedSize)
    }
}
