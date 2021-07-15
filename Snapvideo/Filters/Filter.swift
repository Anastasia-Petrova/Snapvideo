//
//  Filter.swift
//  Snapvideo
//
//  Created by Anastasia Petrova on 02/02/2020.
//  Copyright © 2020 Anastasia Petrova. All rights reserved.
//

import Foundation
import CoreImage

protocol Filter {
    var name: String { get }
    
    func apply(image: CIImage) -> CIImage
}

struct CompositeFilter: Filter {
    var name: String {
        filter1.name + " + " + filter2.name
    }
    let filter1: Filter
    let filter2: Filter
    
    init(filter1: Filter, filter2: Filter) {
        self.filter1 = filter1
        self.filter2 = filter2
    }
    
    func apply(image: CIImage) -> CIImage {
      let filteredImage = filter1.apply(image: image)
      return filter2.apply(image: filteredImage)
    }
}

func + (filter1: Filter, filter2: Filter) -> CompositeFilter {
    CompositeFilter(filter1: filter1, filter2: filter2)
}
