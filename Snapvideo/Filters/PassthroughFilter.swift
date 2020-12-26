//
//  PassthroughFilter.swift
//  Snapvideo
//
//  Created by Anastasia Petrova on 02/02/2020.
//  Copyright © 2020 Anastasia Petrova. All rights reserved.
//

import Foundation
import CoreImage

struct PassthroughFilter: Filter {
    let name: String = "Original"
    
    func apply(image: CIImage) -> CIImage { image }
}
