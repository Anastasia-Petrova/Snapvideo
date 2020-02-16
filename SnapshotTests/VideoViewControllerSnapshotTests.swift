//
//  VideoViewControllerSnapshotTests.swift
//  SnapshotTests
//
//  Created by Anastasia Petrova on 16/02/2020.
//  Copyright © 2020 Anastasia Petrova. All rights reserved.
//

import AVFoundation
@testable import Snapvideo
import SnapshotTesting
import XCTest

final class VideoViewControllerSnapshotTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func DISABLED_test() {
        guard let path = Bundle.snapshotTests.path(forResource: "videoTest", ofType:"MOV") else {
            XCTFail("testVideo.MOV not found")
            return
        }
        let url = URL(fileURLWithPath: path)
        let asset = AVAsset(url: url)
        let vc = VideoViewController(asset: asset)
        
        assertSnapshot(matching: vc, as: .wait(for: 1, on: .image))
    }
}
