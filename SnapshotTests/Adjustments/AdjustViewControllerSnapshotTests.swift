//
//  AdjustViewControllerSnapshotTests.swift
//  SnapshotTests
//
//  Created by Anastasia Petrova on 13/02/2020.
//  Copyright © 2020 Anastasia Petrova. All rights reserved.
//

import XCTest
import SnapshotTesting
@testable import Snapvideo

final class AdjustViewControllerSnapshotTests: XCTestCase {
  func testEditingWithToolViewController() {
    let tool = VignetteTool()
    guard let path = Bundle.snapshotTests.path(forResource: "videoTest", ofType:"MOV") else {
      XCTFail("testVideo.MOV not found")
      return
    }
    let url = URL(fileURLWithPath: path)
    let vc = AdjustmentsViewController(url: url, tool: tool) { _ in }
    vc.view.backgroundColor = .red
    assertSnapshot(matching: vc, as: .image)
  }
}
