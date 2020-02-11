//
//  VideoEditorViewControllerTests.swift
//  UnitTests
//
//  Created by Anastasia Petrova on 10/02/2020.
//  Copyright © 2020 Anastasia Petrova. All rights reserved.
//

import XCTest
@testable import Snapvideo

class VideoEditorViewControllerTests: XCTestCase {
    func test_openLooks_and_closeLooks_setCorrect_topLooksConstraint_constant() {
        let filters = [
            AnyFilter(PassthroughFilter())
        ]
        guard let path = Bundle.unitTests.path(forResource: "videoTest", ofType:"MOV") else {
            XCTFail("testVideo.MOV not found")
            return
        }
        let url = URL(fileURLWithPath: path)
        let vc = VideoEditorViewController(url: url, filters: filters)
        
        vc.openLooks()
        XCTAssertEqual(
            vc.topLooksConstraint.constant,
            vc.looksViewController.view.frame.height + vc.tabBar.frame.height
        )
        
        vc.closeLooks()
        XCTAssertEqual(
            vc.topLooksConstraint.constant,
            -vc.view.safeAreaInsets.bottom
        )
    }
    
    func test_openTools_and_closeTools_setCorrect_topToolsConstraint_constant() {
        let filters = [
            AnyFilter(PassthroughFilter())
        ]
        guard let path = Bundle.unitTests.path(forResource: "videoTest", ofType:"MOV") else {
            XCTFail("testVideo.MOV not found")
            return
        }
        let url = URL(fileURLWithPath: path)
        let vc = VideoEditorViewController(url: url, filters: filters)
        
        vc.openTools()
        XCTAssertEqual(
            vc.topToolsConstraint.constant,
            vc.toolsViewController.view.frame.height + vc.tabBar.frame.height
        )
        
        vc.closeTools()
        XCTAssertEqual(
            vc.topToolsConstraint.constant,
            -vc.view.safeAreaInsets.bottom
        )
    }
}
