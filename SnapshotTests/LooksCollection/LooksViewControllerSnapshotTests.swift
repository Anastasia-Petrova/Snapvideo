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
        let vc = LooksViewController(itemSize: CGSize(width: 60, height: 76), selectedFilterIndex: 0, filters: [
            PassthroughFilter()
        ])
        vc.loadViewIfNeeded()
        vc.view.setNeedsLayout()
        vc.collectionView.layer.borderColor = UIColor.red.cgColor
        vc.collectionView.layer.borderWidth = 4
        assertSnapshot(matching: vc, as: .image)
    }
}
