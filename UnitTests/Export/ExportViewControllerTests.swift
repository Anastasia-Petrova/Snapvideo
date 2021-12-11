//
//  ExportViewControllerTests.swift
//  UnitTests
//
//  Created by Anastasia Petrova on 03/11/2021.
//  Copyright © 2021 Anastasia Petrova. All rights reserved.
//

import XCTest
@testable import Snapvideo

class ExportViewControllerTests: XCTestCase {
  var exportVC: ExportViewController!
  
  override func setUpWithError() throws {
    exportVC = ExportViewController()
  }
  
  override func tearDownWithError() throws {
    exportVC = nil
  }
  
  func test_saveVideoCopy() {
    var capturedActions: [ExportAction] = []
    exportVC.didTapExportViewButton = { action in
      capturedActions.append(action)
    }
    
    exportVC.loadViewIfNeeded()
    exportVC.saveCopyButton.sendActions(for: .touchUpInside)
    
    XCTAssertEqual(capturedActions, [ExportAction.saveVideoCopy])
  }
  
  func test_openActivityView() {
    var capturedActions: [ExportAction] = []
    exportVC.didTapExportViewButton = { action in
      capturedActions.append(action)
    }
    
    exportVC.loadViewIfNeeded()
    exportVC.shareButton.sendActions(for: .touchUpInside)
    
    XCTAssertEqual(capturedActions, [ExportAction.openActivityView])
  }
}
