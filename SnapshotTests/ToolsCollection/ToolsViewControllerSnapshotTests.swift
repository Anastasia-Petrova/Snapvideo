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

final class ToolsViewControllerSnapshotTests: XCTestCase {
    func testToolsViewController() {
      let vc = ToolsViewController()
      assertSnapshot(matching: vc, as: .image)
    }
}
