//
//  SpeedViewControllerTests.swift
//  UnitTests
//
//  Created by Anastasia Petrova on 16/11/2021.
//  Copyright © 2021 Anastasia Petrova. All rights reserved.
//

import Foundation
@testable import Snapvideo
import XCTest

final class SpeedViewControllerTests: XCTestCase {
  var vc: SpeedViewController!
  
  override func setUp() {
    guard let path = Bundle.unitTests.path(forResource: "videoTest", ofType:"MOV") else {
        XCTFail("testVideo.MOV not found")
        return
    }
    vc = SpeedViewController(url: URL(fileURLWithPath: path)) { _ in }
  }

  override func tearDown() {
    vc = nil
  }
  
  func test_isSpeedUpEnabled_when_currentSpeed_isEqualToDefautSpeed() {
    vc.currentSpeed = 1.0
    XCTAssertTrue(vc.isSpeedUpEnabled)
  }
  
  func test_isSpeedUpEnabled_when_currentSpeed_isLowerThanMaxSpeed() {
    vc.currentSpeed = 1.25
    XCTAssertTrue(vc.isSpeedUpEnabled)
  }
  
  func test_isSpeedUpEnabled_when_currentSpeed_isHigherThanMaxSpeed() {
    vc.currentSpeed = 2.25
    XCTAssertFalse(vc.isSpeedUpEnabled)
  }
  
  func test_isSlowDownEnabled_when_currentSpeed_isEqualToDefautSpeed() {
    vc.currentSpeed = 1.0
    XCTAssertTrue(vc.isSlowDownEnabled)
  }
  
  func test_isSlowDownEnabled_when_currentSpeed_isHigherThanMinSpeed() {
    vc.currentSpeed = 0.75
    XCTAssertTrue(vc.isSlowDownEnabled)
  }
  
  func test_isSlowDownEnabled_when_currentSpeed_isLowerThanMinSpeed() {
    vc.currentSpeed = 0.0
    XCTAssertFalse(vc.isSlowDownEnabled)
  }
  
  func test_getSpeedMode_when_speed_isLowerThanDefaultSpeed() {
    XCTAssertEqual(vc.getSpeedMode(0.25), .slowDown(scale: 3))
  }
  
  func test_getSpeedMode_when_speed_isHigherThanDefaultSpeed() {
    XCTAssertEqual(vc.getSpeedMode(1.25), .speedUp(scale: 1))
  }
  
  func test_speedUp_when_speedUpIsEnabled() {
    XCTAssertEqual(vc.currentSpeed, 1.0, "precondition")
    XCTAssertEqual(vc.videoViewController.player.rate, 0.0, "precondition")
    
    _ = vc.speedUpItem.target?.perform(vc.speedUpItem.action)
    
    XCTAssertEqual(vc.currentSpeed, 1.25)
    XCTAssertEqual(vc.videoViewController.player.rate, 1.25)
  }
  
  func test_speedUp_when_speedUpIsDisabled() {
    XCTAssertEqual(vc.videoViewController.player.rate, 0.0, "precondition")
    vc.currentSpeed = 2.0
    
    _ = vc.speedUpItem.target?.perform(vc.speedUpItem.action)
    
    XCTAssertEqual(vc.currentSpeed, 2.0)
    XCTAssertEqual(vc.videoViewController.player.rate, 0.0)
  }
  
  func test_slowDown_when_slowDownIsEnabled() {
    XCTAssertEqual(vc.currentSpeed, 1.0, "precondition")
    XCTAssertEqual(vc.videoViewController.player.rate, 0.0, "precondition")
    
    _ = vc.slowDownItem.target?.perform(vc.slowDownItem.action)
    
    XCTAssertEqual(vc.currentSpeed, 0.75)
    XCTAssertEqual(vc.videoViewController.player.rate, 0.75)
  }
  
  func test_slowDown_when_slowDownIsDisabled() {
    XCTAssertEqual(vc.videoViewController.player.rate, 0.0, "precondition")
    vc.currentSpeed = 0.25
    
    _ = vc.speedUpItem.target?.perform(vc.slowDownItem.action)
    
    XCTAssertEqual(vc.currentSpeed, 0.25)
    XCTAssertEqual(vc.videoViewController.player.rate, 0.0)
  }
}
