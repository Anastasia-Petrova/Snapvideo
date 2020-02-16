//
//  ToolsCollectionViewLayout.swift
//  UnitTests
//
//  Created by Anastasia Petrova on 09/02/2020.
//  Copyright © 2020 Anastasia Petrova. All rights reserved.
//

import XCTest
@testable import Snapvideo

final class ToolsCollectionViewLayout: XCTestCase {
    func test_properties() {
        let expectedSize = CGSize(width: 60, height: 76)
        let toolsCollectionViewLayout = LooksCollectionViewLayout(itemSize: expectedSize)
        
        XCTAssertEqual(
            toolsCollectionViewLayout.sectionInset,
            UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        )
        XCTAssertEqual(toolsCollectionViewLayout.minimumLineSpacing, 5)
        XCTAssertEqual(toolsCollectionViewLayout.scrollDirection, .horizontal)
        XCTAssertEqual(toolsCollectionViewLayout.itemSize, expectedSize)
    }
}
