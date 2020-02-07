//
//  LooksViewControllerSnapshotTests.swift
//  SnapshotTests
//
//  Created by Anastasia Petrova on 07/02/2020.
//  Copyright © 2020 Anastasia Petrova. All rights reserved.
//

import XCTest
import SnapshotTesting
@testable import Snapvideo

class LooksViewControllerSnapshotTests: XCTestCase {
    func testLooksViewController() {
//        record = true
        
        let vc = LooksViewController(itemSize: CGSize(width: 60, height: 76), filters: App.snapshotTests.filters)
      assertSnapshot(matching: vc, as: .image)
    }
}
