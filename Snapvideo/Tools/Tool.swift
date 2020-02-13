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

protocol Tool: CustomStringConvertible, Equatable {
    associatedtype Icon: ImageAssets
    
    var icon: Icon { get }
//    var name: String { get }
    
    func apply(image: CIImage) -> CIImage
}

extension Tool {
    var description: String { icon.description }
}

struct AnyTool: Equatable {
    let apply: (CIImage) -> CIImage
    let name: String
    let icon: UIImage
    
    init<T: Tool>(_ tool: T) where T.Icon == ImageAsset.Tools {
        apply = tool.apply
        name = tool.description
        icon = tool.icon.image()
    }
    
    static func == (lhs: AnyTool, rhs: AnyTool) -> Bool {
        lhs.name == rhs.name
    }
}
