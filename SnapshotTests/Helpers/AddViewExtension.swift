//
//  AddViewExtension.swift
//  SnapshotTests
//
//  Created by Anastasia Petrova on 16/11/2021.
//  Copyright © 2021 Anastasia Petrova. All rights reserved.
//

import Foundation
import XCTest
import SnapshotTesting

extension UIViewController {
  func add(_ view: UIView) {
    view.translatesAutoresizingMaskIntoConstraints = false
    self.view.backgroundColor = .black
    self.view.addSubview(view)
    NSLayoutConstraint.activate([
      view.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.7),
      view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
      view.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
    ])
    self.viewDidLoad()
    self.view.layoutIfNeeded()
  }
}

