//
//  Tool.swift
//  Snapvideo
//
//  Created by Anastasia Petrova on 11/02/2020.
//  Copyright © 2020 Anastasia Petrova. All rights reserved.
//

import Foundation
import UIKit
import CoreImage

protocol Tool: Equatable {
    var name: String { get }
    
    func apply(image: CIImage) -> CIImage
}

struct AnyTool: Equatable {
    let apply: (CIImage) -> CIImage
    let name: String
    
    init<T: Tool>(_ tool: T) {
        apply = tool.apply
        name = tool.name
    }
    
    static func == (lhs: AnyTool, rhs: AnyTool) -> Bool {
        lhs.name == rhs.name
    }
}
