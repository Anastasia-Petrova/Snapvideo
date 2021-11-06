//
//  ExportViewControllerSnapshotTests.swift
//  SnapshotTests
//
//  Created by Anastasia Petrova on 03/11/2021.
//  Copyright © 2021 Anastasia Petrova. All rights reserved.
//

import XCTest
import SnapshotTesting
@testable import Snapvideo

final class ExportViewControllerSnapshotTests: XCTestCase {
    func testExportViewController() {
        let vc = ExportViewController()
        vc.view.layer.borderColor = UIColor.red.cgColor
        vc.view.layer.borderWidth = 4
        vc.view.heightAnchor.constraint(equalToConstant: 100).isActive = true
        assertSnapshot(matching: vc, as: .image)
    }
}
