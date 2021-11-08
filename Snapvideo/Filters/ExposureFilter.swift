//
//  ExposureFilter.swift
//  Snapvideo
//
//  Created by Anastasia Petrova on 08/11/2021.
//  Copyright © 2021 Anastasia Petrova. All rights reserved.
//

import CoreImage

struct ExposureFilter: Filter {
    let name: String = "Exposure"
    var exposure: Double
    
    init(exposure: Double) {
        self.exposure = exposure
    }
    
    func apply(image: CIImage) -> CIImage {
        let optionalExposureFilter = CIFilter(name: "CIExposureAdjust")
        guard let exposureFilter = optionalExposureFilter else {
            return image
        }
        exposureFilter.setValue(image, forKey: kCIInputImageKey)
        exposureFilter.setValue(exposure, forKey:kCIInputEVKey)
        
        return exposureFilter.outputImage ?? image
    }
}
