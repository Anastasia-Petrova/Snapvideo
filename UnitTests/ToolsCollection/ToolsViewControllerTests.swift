//
//  ToolsViewControllerTests.swift
//  UnitTests
//
//  Created by Anastasia Petrova on 13/02/2020.
//  Copyright © 2020 Anastasia Petrova. All rights reserved.
//

import XCTest
@testable import Snapvideo

class ToolsViewControllerTests: XCTestCase {

    func test_init_assigns_properties() {
        let tools = [AnyTool(WarmthTool())]
        let vc = ToolsViewController(tools: tools)
        let collectionView = vc.collectionView
        let dataSource = vc.dataSource
        XCTAssertEqual(dataSource.collectionView, collectionView)
        XCTAssertEqual(collectionView.dataSource?.isEqual(dataSource), true)
        XCTAssertEqual(collectionView.delegate?.isEqual(vc), true)
    }
    
    func test_didSelect_calls_choosenToolCallback() {
        let expectedIndexPath = IndexPath(item: 1, section: 0)
        let tools = [AnyTool(WarmthTool())]
        let vc = ToolsViewController(tools: tools)
        
        var toolIndex: Int?
        vc.didSelectToolCallback = { index in
            toolIndex = index
        }
        vc.collectionView(vc.collectionView, didSelectItemAt: expectedIndexPath)
        
        XCTAssertEqual(expectedIndexPath.row, toolIndex)
    }
}
