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

    func testExample() {
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
        //asset contstraint constant
        XCTAssertEqual(vc.bottomLooksConstraint.constant, 0 - vc.view.safeAreaInsets.bottom)
        vc.closeLooks()
        //asset contstraint constant
        XCTAssertEqual(vc.bottomLooksConstraint.constant, 100)
    }
}
