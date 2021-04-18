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
        let tools: Array<ToolEnum> = [.vignette(tool: VignetteTool())]
        guard let path = Bundle.snapshotTests.path(forResource: "videoTest", ofType:"MOV") else {
            XCTFail("testVideo.MOV not found")
            return
        }
        let url = URL(fileURLWithPath: path)
        let vc = VideoEditorViewController(url: url, selectedFilterIndex: 0, filters: filters, tools: tools)
        
        assertSnapshot(matching: vc, as: .wait(for: 2, on: .image))
    }
    
    func DISABLED_testVideoEditorViewController_openLooks_and_closeLooks_set_correct_constraints() {
        let filters = [AnyFilter(PassthroughFilter())]
        let tools: Array<ToolEnum> = [.vignette(tool: VignetteTool())]
        guard let path = Bundle.snapshotTests.path(forResource: "videoTest", ofType:"MOV") else {
            XCTFail("testVideo.MOV not found")
            return
        }
        let url = URL(fileURLWithPath: path)
        let vc = VideoEditorViewController(url: url, selectedFilterIndex: 0, filters: filters, tools: tools)
        
        vc.openLooks()
        assertSnapshot(matching: vc, as: .wait(for: 5, on: .image))
        
        vc.closeLooks()
        assertSnapshot(matching: vc, as: .wait(for: 5, on: .image))
    }
    
    func DISABLED_testVideoEditorViewController_openTools_and_closeTools_set_correct_constraints() {
        let filters = [AnyFilter(PassthroughFilter())]
        let tools: Array<ToolEnum> = [.vignette(tool: VignetteTool())]
        guard let path = Bundle.snapshotTests.path(forResource: "videoTest", ofType:"MOV") else {
            XCTFail("testVideo.MOV not found")
            return
        }
        let url = URL(fileURLWithPath: path)
        let vc = VideoEditorViewController(url: url, selectedFilterIndex: 0, filters: filters, tools: tools)

        vc.openTools()
        assertSnapshot(matching: vc, as: .wait(for: 5, on: .image))
        
        vc.closeTools()
        assertSnapshot(matching: vc, as: .wait(for: 5, on: .image))
    }
    
    func DISABLED_testVideoEditorViewController_openExportMenu_and_closeExportMenu_set_correct_constraints() {
        let filters = [AnyFilter(PassthroughFilter())]
        let tools: Array<ToolEnum> = [.vignette(tool: VignetteTool())]
        guard let path = Bundle.snapshotTests.path(forResource: "videoTest", ofType:"MOV") else {
            XCTFail("testVideo.MOV not found")
            return
        }
        let url = URL(fileURLWithPath: path)
        let vc = VideoEditorViewController(url: url, selectedFilterIndex: 0, filters: filters, tools: tools)
        
        vc.openExportMenu()
        assertSnapshot(matching: vc, as: .wait(for: 5, on: .image))
        
        vc.closeExportMenu()
        assertSnapshot(matching: vc, as: .wait(for: 5, on: .image))
    }
}
