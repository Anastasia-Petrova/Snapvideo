//
//  Bundle.swift
//  Snapvideo
//
//  Created by Anastasia Petrova on 02/02/2020.
//  Copyright © 2020 Anastasia Petrova. All rights reserved.
//

import Foundation

extension Bundle {
    static let unitTests = Bundle(for: Fake.self)
}

private class Fake {}
