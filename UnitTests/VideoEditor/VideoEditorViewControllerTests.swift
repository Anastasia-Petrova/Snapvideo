//
//  VideoEditorViewControllerTests.swift
//  UnitTests
//
//  Created by Anastasia Petrova on 10/02/2020.
//  Copyright © 2020 Anastasia Petrova. All rights reserved.
//

import XCTest
@testable import Snapvideo

final class VideoEditorViewControllerTests: XCTestCase {
    func test_openLooks_and_closeLooks_setCorrect_topLooksConstraint_constant() {
        let filters = [
            AnyFilter(PassthroughFilter())
        ]
        guard let path = Bundle.unitTests.path(forResource: "videoTest", ofType:"MOV") else {
            XCTFail("testVideo.MOV not found")
            return
        }
        let url = URL(fileURLWithPath: path)
        let vc = VideoEditorViewController(url: url, index: 0, filters: filters)
        
        vc.openLooks()
        XCTAssertEqual(
            vc.topLooksConstraint.constant,
            vc.looksViewController.view.frame.height + vc.tabBar.frame.height + 0.3
        )
        
        vc.closeLooks()
        XCTAssertEqual(
            vc.topLooksConstraint.constant,
            -vc.view.safeAreaInsets.bottom
        )
    }
    
    
    func test_openExportMenu_and_closeExportMenu_setCorrect_topExportMenuConstraint_constant() {
        let filters = [
            AnyFilter(PassthroughFilter())
        ]
        guard let path = Bundle.unitTests.path(forResource: "videoTest", ofType:"MOV") else {
            XCTFail("testVideo.MOV not found")
            return
        }
        let url = URL(fileURLWithPath: path)
        let vc = VideoEditorViewController(url: url, index: 0, filters: filters)
        
        vc.openExportMenu()
        XCTAssertEqual(
            vc.topExportConstraint.constant,
            vc.exportView.frame.height + vc.tabBar.frame.height
        )
        
        vc.closeExportMenu()
        XCTAssertEqual(
            vc.topExportConstraint.constant,
            -vc.view.safeAreaInsets.bottom
        )
    }
}
