//
//  NoiseReductionFilter.swift
//  Snapvideo
//
//  Created by Anastasia Petrova on 09/11/2021.
//  Copyright © 2021 Anastasia Petrova. All rights reserved.
//

import CoreImage

struct NoiseReductionFilter: Filter {
    let name: String = "NoiseReduction"
    var noise: Double
    var sharpness: Double
    
    init(noise: Double, sharpness: Double) {
        self.noise = noise
        self.sharpness = sharpness
    }
    
    func apply(image: CIImage) -> CIImage {
        let optionalNoiseReductionFilter = CIFilter(name: "CINoiseReduction")
        guard let noiseReductionFilter = optionalNoiseReductionFilter else {
            return image
        }
        noiseReductionFilter.setValue(image, forKey: kCIInputImageKey)
        noiseReductionFilter.setValue(noise, forKey: "inputNoiseLevel")
        noiseReductionFilter.setValue(sharpness, forKey: "inputSharpness")
        
        return noiseReductionFilter.outputImage ?? image
    }
}
