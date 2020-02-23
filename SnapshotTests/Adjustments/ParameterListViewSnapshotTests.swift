//
//  ParameterListViewSnapshotTests.swift
//  SnapshotTests
//
//  Created by Anastasia Petrova on 23/02/2020.
//  Copyright © 2020 Anastasia Petrova. All rights reserved.
//

import XCTest
import SnapshotTesting
@testable import Snapvideo

final class ParameterListViewSnapshotTests: XCTestCase {
    private typealias Parameter = ParameterListView.Parameter
    func test_default() {
//        record = true
        let vc = UIViewController()
        vc.view.backgroundColor = .white
        let view = ParameterListView(parameters: [
            Parameter(name: "Hello", value: "10")
        ]) { _ in }
        view.backgroundColor = .red
        view.translatesAutoresizingMaskIntoConstraints = false
        vc.view.addSubview(view)
        NSLayoutConstraint.activate([
            view.centerXAnchor.constraint(equalTo: vc.view.centerXAnchor),
            view.centerYAnchor.constraint(equalTo: vc.view.centerYAnchor),
        ])
        vc.viewDidLoad()
        vc.view.layoutIfNeeded()
        assertSnapshot(matching: vc, as: .image)
    }
}
