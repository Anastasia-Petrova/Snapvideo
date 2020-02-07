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

final class VideoEditorViewControllerSnapshotTests: XCTestCase {
    func DISABLED_testVideoEditorViewController() {
        let filters = [AnyFilter(PassthroughFilter())]
        guard let path = Bundle.snapshotTests.path(forResource: "videoTest", ofType:"MOV") else {
            XCTFail("testVideo.MOV not found")
            return
        }
        let url = URL(fileURLWithPath: path)
        let vc = VideoEditorViewController(url: url, filters: filters) { (presentedFilter) in
        }
        
        assertSnapshot(matching: vc, as: .wait(for: 5, on: .image))
    }
}
