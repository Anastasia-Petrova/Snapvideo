//
//  ParameterValueViewSnapshotTests.swift
//  SnapshotTests
//
//  Created by Anastasia Petrova on 16/11/2021.
//  Copyright © 2021 Anastasia Petrova. All rights reserved.
//

import XCTest
import SnapshotTesting
@testable import Snapvideo

final class ParameterValueViewSnapshotTests: XCTestCase {
  func testParameterValueView() {
    let vc = UIViewController()
    let label = UILabel()
    label.text = "test"
    let view = ParameterValueView(label: label)
    vc.add(view)
    view.backgroundColor = .red
    assertSnapshot(matching: vc, as: .image)
  }
}
