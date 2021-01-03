//
//  TemperatureAndTintFilter.swift
//  Snapvideo
//
//  Created by Anastasia Petrova on 31/12/2020.
//  Copyright © 2020 Anastasia Petrova. All rights reserved.
//

import Foundation
import CoreImage

struct TemperatureAndTintFilter: Filter {
    static let min: Double = 2000.0
    static let mid: Double = 6500.0
    static let max: Double = 10000.0
    
    let name: String = "Temperature and Tint"
    private let filter = CIFilter(name: "CITemperatureAndTint")!
    var inputNeutral: CGFloat = CGFloat(Self.mid)
    var targetNeutral: CGFloat = CGFloat(Self.mid)
    
    func parameters(with image: CIImage) -> [String : Any] {
        [
            kCIInputImageKey:  image,
            "inputNeutral" : CIVector(x: inputNeutral, y: 0),
            "inputTargetNeutral" : CIVector(x: targetNeutral, y: 0),
        ]
    }
    
    func apply(image: CIImage) -> CIImage {
        filter.createOutputImage(for: parameters(with: image)) ?? image
    }
}
