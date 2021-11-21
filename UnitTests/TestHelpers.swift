//
//  TestHelpers.swift
//  Snapvideo
//
//  Created by Anastasia Petrova on 02/02/2020.
//  Copyright © 2020 Anastasia Petrova. All rights reserved.
//

import Foundation
import UIKit
import XCTest

func assertEqual(_ image1: UIImage, _ image2: UIImage, file: StaticString = #file, line: UInt = #line) {
    XCTAssertEqual(image1.pngData(), image2.pngData(), file: file, line: line)
}

extension UIBarButtonItem {
  @discardableResult func tap() {
    target?.perform(action)
  }
}
