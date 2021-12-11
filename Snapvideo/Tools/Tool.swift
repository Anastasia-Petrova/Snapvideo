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
    associatedtype F: Filter
    
    var filter: F { get }
    var icon: Icon { get }
    
    func apply(image: CIImage) -> CIImage
}

extension Tool {
    var description: String { icon.description }
}

enum ToolEnum: Equatable {
    case vignette(tool: VignetteTool)
    case colourCorrection(tool: LightTool)
    case blur(tool: VignetteTool)
    case sharpenTool(tool: SharpenTool)
    case exposureTool(tool: ExposureTool)
    case noiseReductionTool(tool: NoiseReductionTool)
    case highlightShadowTool(tool: HighlightShadowTool)
    case vibranceTool(tool: VibranceTool)
    case straightenTool(tool: StraightenTool)
    case cropTool(tool: CropTool)
    
    var name: String {
        switch self {
        case let .vignette(tool),
             let .blur(tool):
            return tool.description
        case let .colourCorrection(tool):
            return tool.description
        case let .sharpenTool(tool):
            return tool.description
        case let .exposureTool(tool):
            return tool.description
        case let .noiseReductionTool(tool):
            return tool.description
        case let .highlightShadowTool(tool):
            return tool.description
        case let .vibranceTool(tool):
            return tool.description
        case let .straightenTool(tool):
            return tool.description
        case let .cropTool(tool):
            return tool.description
        }
    }
    
    var icon: UIImage {
        switch self {
        case let .vignette(tool),
             let .blur(tool):
            return tool.icon.image()
        case let .colourCorrection(tool):
            return tool.icon.image()
        case let .sharpenTool(tool):
            return tool.icon.image()
        case let .exposureTool(tool):
            return tool.icon.image()
        case let .noiseReductionTool(tool):
            return tool.icon.image()
        case let .highlightShadowTool(tool):
            return tool.icon.image()
        case let .vibranceTool(tool):
            return tool.icon.image()
        case let .straightenTool(tool):
            return tool.icon.image()
        case let .cropTool(tool):
            return tool.icon.image()
        }
    }
}
