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
        let vc = VideoEditorViewController(url: url, filters: filters)
        
        assertSnapshot(matching: vc, as: .wait(for: 2, on: .image))
    }
    
    func testVideoEditorViewController_openLooks_and_closeLooks_set_correct_constraints() {
        let filters = [AnyFilter(PassthroughFilter())]
        guard let path = Bundle.snapshotTests.path(forResource: "videoTest", ofType:"MOV") else {
            XCTFail("testVideo.MOV not found")
            return
        }
        let url = URL(fileURLWithPath: path)
        let vc = VideoEditorViewController(url: url, filters: filters)
        
        vc.openLooks()
        assertSnapshot(matching: vc, as: .wait(for: 2, on: .image))
        
        vc.closeLooks()
        assertSnapshot(matching: vc, as: .wait(for: 2, on: .image))
    }
    
    func testVideoEditorViewController_openTools_and_closeTools_set_correct_constraints() {
        let filters = [AnyFilter(PassthroughFilter())]
        guard let path = Bundle.snapshotTests.path(forResource: "videoTest", ofType:"MOV") else {
            XCTFail("testVideo.MOV not found")
            return
        }
        let url = URL(fileURLWithPath: path)
        let vc = VideoEditorViewController(url: url, filters: filters)
        
        vc.openTools()
        assertSnapshot(matching: vc, as: .wait(for: 2, on: .image))
        
        vc.closeTools()
        assertSnapshot(matching: vc, as: .wait(for: 2, on: .image))
    }
    
    func testVideoEditorViewController_openExportMenu_and_closeExportMenu_set_correct_constraints() {
        let filters = [AnyFilter(PassthroughFilter())]
        guard let path = Bundle.snapshotTests.path(forResource: "videoTest", ofType:"MOV") else {
            XCTFail("testVideo.MOV not found")
            return
        }
        let url = URL(fileURLWithPath: path)
        let vc = VideoEditorViewController(url: url, filters: filters)
        
        vc.openExportMenu()
        assertSnapshot(matching: vc, as: .wait(for: 2, on: .image))
        
        vc.closeExportMenu()
        assertSnapshot(matching: vc, as: .wait(for: 2, on: .image))
    }
}
