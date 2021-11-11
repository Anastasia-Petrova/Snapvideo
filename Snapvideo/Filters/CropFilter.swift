//
//  CropFilter.swift
//  Snapvideo
//
//  Created by Anastasia Petrova on 11/11/2021.
//  Copyright © 2021 Anastasia Petrova. All rights reserved.
//

import CoreImage

struct CropFilter: Filter {
    let name: String = "Crop"
    var x: CGFloat
    var y: CGFloat
    var width: CGFloat
    var height: CGFloat
  
    func apply(image: CIImage) -> CIImage {
        let optionalCropFilter = CIFilter(name: "CICrop")
        guard let cropFilter = optionalCropFilter else {
            return image
        }
        cropFilter.setValue(image, forKey: kCIInputImageKey)
        let rectangle = CIVector(x: x, y: y, z: width, w: height)
        cropFilter.setValue(rectangle, forKey:"inputRectangle")
        
        return cropFilter.outputImage ?? image
    }
}

