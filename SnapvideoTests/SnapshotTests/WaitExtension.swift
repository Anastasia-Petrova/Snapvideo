//
//  WaitExtension.swift
//  SnapvideoTests
//
//  Created by Anastasia Petrova on 06/02/2020.
//  Copyright © 2020 Anastasia Petrova. All rights reserved.
//

import Foundation
import XCTest
import SnapshotTesting

extension Snapshotting {
    static func waiting(
        for duration: TimeInterval,
        on strategy: Snapshotting
    ) -> Snapshotting {
        return strategy.pullback { value in
            let expectation = XCTestExpectation(description: "Wait")
            DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                expectation.fulfill()
            }
            _ = XCTWaiter.wait(for: [expectation], timeout: duration + 1)
            return value
        }
    }
}
