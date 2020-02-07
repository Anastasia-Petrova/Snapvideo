//
//  HomeViewControllerTests.swift
//  SnapvideoTests
//
//  Created by Anastasia Petrova on 06/02/2020.
//  Copyright © 2020 Anastasia Petrova. All rights reserved.
//

import XCTest
import SnapshotTesting
@testable import Snapvideo

final class HomeViewControllerTests: XCTestCase {
    func testHomeViewController() {
      let vc = HomeViewController()

      assertSnapshot(matching: vc, as: .image)
    }
}
