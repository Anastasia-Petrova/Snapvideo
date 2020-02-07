//
//  VideoEditorViewControllerSnapshotTests.swift
//  SnapvideoTests
//
//  Created by Anastasia Petrova on 06/02/2020.
//  Copyright © 2020 Anastasia Petrova. All rights reserved.
//

import XCTest
import SnapshotTesting
@testable import Snapvideo

final class ToolsCollectionViewControllerSnapshotTests: XCTestCase {
    func testCollectionViewController() {
      let vc = ToolsCollectionViewController(dataSource: ToolsCollectionDataSource())
      assertSnapshot(matching: vc, as: .image)
    }
}
