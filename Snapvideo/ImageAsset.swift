//
//  ImageAsset.swift
//  Snapvideo
//
//  Created by Anastasia Petrova on 13/02/2020.
//  Copyright © 2020 Anastasia Petrova. All rights reserved.
//

import Foundation
import UIKit

protocol ImageAssets: ImageRepresentable, RawRepresentable, CustomStringConvertible where RawValue == String { }

protocol ImageRepresentable {
    func image() -> UIImage
}

extension ImageAssets {
    func image() -> UIImage {
        return UIImage(named: rawValue, in: .main, with: nil) ?? UIImage()
    }
    
    var description: String {
        rawValue.camelCaseToWords().capitalized
    }
}

enum ImageAsset: String, ImageAssets, Equatable {
    case addButton
    case cancel
    case done
    case effects
    case logo
    case placeholder
    case playCircle
    case saveVideoCopyImage
    case saveVideoImage
}

extension ImageAsset {
    enum Tools: String, ImageAssets, Equatable {
        case bright
        case exposure
        case crop
        case cut
        case fade
        case highlights
        case saturation
        case shadows
        case sharpen
        case slowDown
        case speedUp
        case tiltShift
        case tune
        case vignette
        case warmth
    }
}
