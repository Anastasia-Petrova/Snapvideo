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
//        record = true
    }

    func test() {
        let url = Bundle.snapshotTests.url(forResource: "videoTest", withExtension: "mp4")!
        print("videoTest:" + url.absoluteString)
        let asset = AVAsset(url: url)
        let vc = VideoViewController(asset: asset)
        vc.viewDidLoad()
        assertSnapshot(matching: vc, as: .wait(for: 5, on: .image))
    }
}
