//
//  SpeedViewControllerSnapshotTests.swift
//  SnapshotTests
//
//  Created by Anastasia Petrova on 16/11/2021.
//  Copyright © 2021 Anastasia Petrova. All rights reserved.
//

import XCTest
import SnapshotTesting
@testable import Snapvideo

final class SpeedViewControllerSnapshotTests: XCTestCase {
  func testSpeedViewController() throws {
    let path = try XCTUnwrap(Bundle.snapshotTests.path(forResource: "videoTest", ofType:"MOV"))
    let url = URL(fileURLWithPath: path)
    let vc = SpeedViewController(url: url) { _ in }
    vc.view.layer.borderColor = UIColor.red.cgColor
    vc.view.layer.borderWidth = 4
    assertSnapshot(matching: vc, as: .image)
  }
}
