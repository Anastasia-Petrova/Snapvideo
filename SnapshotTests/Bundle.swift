//
//  Bundle.swift
//  SnapshotTests
//
//  Created by Anastasia Petrova on 07/02/2020.
//  Copyright © 2020 Anastasia Petrova. All rights reserved.
//

import Foundation

extension Bundle {
    static let snapshotTests = Bundle(for: Fake.self)
}

private class Fake {}

