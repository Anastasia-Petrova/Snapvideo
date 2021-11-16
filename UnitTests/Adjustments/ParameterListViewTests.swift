//
//  ParameterListViewTests.swift
//  UnitTests
//
//  Created by Anastasia Petrova on 23/02/2020.
//  Copyright © 2020 Anastasia Petrova. All rights reserved.
//

import Foundation
@testable import Snapvideo
import XCTest

final class ParameterListViewTests: XCTestCase {
    func test_init_assigns_parameters() {
        let expected = [
            Parameter(name: "Foo", value: 1, minPercent: 0),
            Parameter(name: "Bar", value: 2, minPercent: 0)
        ]
        let view = ParameterListView(parameters: expected)
        XCTAssertEqual(view.parameters, expected)
    }
    
    func test_translateY_boundries() {
        let view = ParameterListView(parameters: [
            Parameter(name: "", value: 1, minPercent: 0),
            Parameter(name: "", value: 1, minPercent: 0)
        ])
        add(view, on: UIViewController())
        
        XCTAssertEqual(view.verticalOffset, ParameterListView.minOffset)
        
        view.translateY(5)
        XCTAssertEqual(view.verticalOffset, 5)
        
        view.translateY(-100)
        XCTAssertEqual(view.verticalOffset, ParameterListView.minOffset)
        
        view.translateY(10000)
        XCTAssertEqual(view.verticalOffset, view.maxOffset)
    }
    
    func test_calculateSelectedRowIndex() {
        let rowHeight = 100
        XCTAssertEqual(ParameterListView.calculateSelectedRowIndex(offset: 0, rowHeight: rowHeight), 0)
        XCTAssertEqual(ParameterListView.calculateSelectedRowIndex(offset: 50, rowHeight: rowHeight), 0)
        XCTAssertEqual(ParameterListView.calculateSelectedRowIndex(offset: 51, rowHeight: rowHeight), 1)
        XCTAssertEqual(ParameterListView.calculateSelectedRowIndex(offset: 100, rowHeight: rowHeight), 1)
        XCTAssertEqual(ParameterListView.calculateSelectedRowIndex(offset: 150, rowHeight: rowHeight), 1)
        XCTAssertEqual(ParameterListView.calculateSelectedRowIndex(offset: 151, rowHeight: rowHeight), 2)
    }
    
    func test_didSelectParameter_callback() {
        let expected1 = Parameter(name: "Foo", value: 1, minPercent: 0)
        let expected2 = Parameter(name: "Bar", value: 2, minPercent: 0)
        var actual: Parameter?
        
        let view = ParameterListView(parameters: [expected1, expected2])
        view.didSelectParameter = { actual = $0 }
        add(view, on: UIViewController())
        let translation = view.rowHeight/2.0 + 1
        
        view.translateY(translation)
        view.layoutSubviews()
        XCTAssertEqual(expected2, actual)
        
        view.translateY(-translation)
        view.layoutSubviews()
        XCTAssertEqual(expected1, actual)
    }
    
    func add(_ view: UIView, on vc: UIViewController) {
        view.translatesAutoresizingMaskIntoConstraints = false
        vc.view.addSubview(view)
        NSLayoutConstraint.activate([
            view.centerXAnchor.constraint(equalTo: vc.view.centerXAnchor),
            view.centerYAnchor.constraint(equalTo: vc.view.centerYAnchor)
        ])
        vc.view.layoutIfNeeded()
    }
}
