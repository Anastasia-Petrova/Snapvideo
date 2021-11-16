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
  var vc: VideoViewController!
  
  override func setUpWithError() throws {
    let url = try XCTUnwrap(Bundle.snapshotTests.url(forResource: "videoTest", withExtension: "MOV"))
    vc = VideoViewController(asset: AVAsset(url: url))
  }
  
  override func tearDown() {
    vc = nil
  }
  
  func testVideoViewController() {
    vc.view.backgroundColor = .red
    vc.viewDidLoad()
    assertSnapshot(matching: vc, as: .image)
  }
}
