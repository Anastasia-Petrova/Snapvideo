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

protocol Tool: CustomStringConvertible, Equatable, Parameterized {
    associatedtype Icon: ImageAssets
    
    var icon: Icon { get }
    
    func apply(image: CIImage) -> CIImage
}

extension Tool {
    var description: String { icon.description }
}

enum ToolEnum: Equatable {
    case vignette(tool: VignetteTool)
    case bright(name: String, icon: UIImage)
    case blur(name: String, icon: UIImage)
    
    var name: String {
        switch self {
        case let .vignette(tool):
            return tool.description
        case let .bright(name, _),
             let .blur(name, _):
            return name
        }
    }
    
    var icon: UIImage {
        switch self {
        case let .vignette(tool):
            return tool.icon.image()
        case let .bright(_, icon),
             let .blur(_, icon):
            return icon
        }
    }
}
