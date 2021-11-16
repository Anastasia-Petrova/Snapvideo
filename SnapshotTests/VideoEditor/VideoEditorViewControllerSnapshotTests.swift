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
  var vc: VideoEditorViewController!
  
  override func setUpWithError() throws {
    vc = try XCTUnwrap(makeVideoEditorViewController())
  }
  
  override func tearDown() {
    vc = nil
  }
  
  func testVideoEditorViewController() {
    vc.view.backgroundColor = .red
    assertSnapshot(matching: vc, as: .image)
  }
  
  func testVideoEditorViewController_openLooks_and_closeLooks_set_correct_constraints() {
    vc.view.backgroundColor = .red
    
    vc.openLooks()
    assertSnapshot(matching: vc, as: .image)
    
    vc.closeLooks()
    assertSnapshot(matching: vc, as: .image)
  }
  
  func testVideoEditorViewController_openTools_and_closeTools_set_correct_constraints() {
    vc.view.backgroundColor = .red
    
    vc.openTools()
    assertSnapshot(matching: vc, as: .image)
    
    vc.closeTools()
    assertSnapshot(matching: vc, as: .image)
  }
  
  func testVideoEditorViewController_openExportMenu_and_closeExportMenu_set_correct_constraints() {
    vc.view.backgroundColor = .red
    
    vc.openExportMenu()
    assertSnapshot(matching: vc, as: .image)
    
    vc.closeExportMenu()
    assertSnapshot(matching: vc, as: .image)
  }
  
  func makeVideoEditorViewController() throws -> VideoEditorViewController {
    let path = try XCTUnwrap(Bundle.snapshotTests.path(forResource: "videoTest", ofType:"MOV"))
    let url = URL(fileURLWithPath: path)
    return VideoEditorViewController(
      url: url,
      selectedFilterIndex: 0,
      filters: [PassthroughFilter()],
      tools: [.vignette(tool: VignetteTool())]
    )
  }
}
