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
        let tools = [AnyTool(WarmthTool())]
        let vc = ToolsViewController(tools: tools)
//        record = true
        assertSnapshot(matching: vc, as: .image)
    }
}
