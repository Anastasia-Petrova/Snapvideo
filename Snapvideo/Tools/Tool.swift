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
    var name: String { get }
    
    func apply(image: CIImage) -> CIImage
}

extension Tool {
    var description: String { name }
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
    case speed
    
    var name: String {
        switch self {
        case let .vignette(tool),
             let .blur(tool):
            return tool.name
        case let .colourCorrection(tool):
            return tool.name
        case let .sharpenTool(tool):
            return tool.name
        case let .exposureTool(tool):
            return tool.name
        case let .noiseReductionTool(tool):
            return tool.name
        case let .highlightShadowTool(tool):
            return tool.name
        case let .vibranceTool(tool):
            return tool.name
        case let .straightenTool(tool):
            return tool.name
        case let .cropTool(tool):
            return tool.name
        case .speed:
            return "Speed"
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
        case .speed:
            return ImageAsset.Tools.speed.image()
        }
    }
}
