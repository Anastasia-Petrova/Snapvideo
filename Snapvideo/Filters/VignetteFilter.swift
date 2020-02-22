//
//  VignetteFilter.swift
//  Snapvideo
//
//  Created by Anastasia Petrova on 02/02/2020.
//  Copyright © 2020 Anastasia Petrova. All rights reserved.
//

import Foundation
import CoreImage

struct VignetteFilter: Filter {
    let name: String = "Vignette"
    let radius: Double
    let intensity: Double
    
    private let filter = CIFilter(name: "CIVignette", parameters: nil)
    
    func parameters(with image: CIImage) -> [String : Any] {
        [
            kCIInputImageKey:  image,
            kCIInputRadiusKey : NSNumber(floatLiteral: radius),
            kCIInputIntensityKey : NSNumber(floatLiteral: intensity),
        ]
    }
    
    func apply(image: CIImage) -> CIImage {
        filter?.createOutputImage(for: parameters(with: image)) ?? image
    }
}

extension VignetteFilter {
    init() {
        radius = 0.8
        intensity = 5.0
    }
}

extension CIFilter {
    func createOutputImage(for parameters: [String : Any]) -> CIImage? {
        setValuesForKeys(parameters)
        return outputImage
    }
}
