//
//  ToolsCollectionViewCellSnapshotTests.swift
//  SnapvideoTests
//
//  Created by Anastasia Petrova on 07/02/2020.
//  Copyright © 2020 Anastasia Petrova. All rights reserved.
//

import XCTest
import SnapshotTesting
@testable import Snapvideo

class ToolsCollectionViewCellSnapshotTests: XCTestCase {
    func testToolsCollectionViewCell() {
        let cell = ToolsCollectionViewCell(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 60, height: 76)))
        cell.toolName.text = "Crop"
        assertSnapshot(matching: cell, as: .wait(for: 1, on: .image))
    }
}
