//
//  SpeedViewControllerTests.swift
//  UnitTests
//
//  Created by Anastasia Petrova on 16/11/2021.
//  Copyright © 2021 Anastasia Petrova. All rights reserved.
//

import Foundation
@testable import Snapvideo
//import UIKit
import XCTest

final class SpeedViewControllerTests: XCTestCase {
  var url: URL!
  
  override func setUp() {
    guard let path = Bundle.unitTests.path(forResource: "videoTest", ofType:"MOV") else {
        XCTFail("testVideo.MOV not found")
        return
    }
    url = URL(fileURLWithPath: path)
  }

  override func tearDown() {
    url = nil
  }
  
  func test_isSpeedUpEnabled_when_currentSpeed_isEqualToDefautSpeed() {
    let vc = SpeedViewController(url: url) { _ in }
    vc.currentSpeed = 1.0
    XCTAssertTrue(vc.isSpeedUpEnabled)
  }
  
  func test_isSpeedUpEnabled_when_currentSpeed_isLowerThanMaxSpeed() {
    let vc = SpeedViewController(url: url) { _ in }
    vc.currentSpeed = 1.25
    XCTAssertTrue(vc.isSpeedUpEnabled)
  }
  
  func test_isSpeedUpEnabled_when_currentSpeed_isHigherThanMaxSpeed() {
    let vc = SpeedViewController(url: url) { _ in }
    vc.currentSpeed = 2.25
    XCTAssertFalse(vc.isSpeedUpEnabled)
  }
  
  func test_isSlowDownEnabled_when_currentSpeed_isEqualToDefautSpeed() {
    let vc = SpeedViewController(url: url) { _ in }
    vc.currentSpeed = 1.0
    XCTAssertTrue(vc.isSlowDownEnabled)
  }
  
  func test_isSlowDownEnabled_when_currentSpeed_isHigherThanMinSpeed() {
    let vc = SpeedViewController(url: url) { _ in }
    vc.currentSpeed = 0.75
    XCTAssertTrue(vc.isSlowDownEnabled)
  }
  
  func test_isSlowDownEnabled_when_currentSpeed_isLowerThanMinSpeed() {
    let vc = SpeedViewController(url: url) { _ in }
    vc.currentSpeed = 0.0
    XCTAssertFalse(vc.isSlowDownEnabled)
  }
  
  
}
