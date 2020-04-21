//
//  VideoModel.swift
//  Snapvideo
//
//  Created by Anastasia Petrova on 21/04/2020.
//  Copyright © 2020 Anastasia Petrova. All rights reserved.
//

import Foundation
import EasyCoreData

struct VideoModel: CoreDataMappable {
    let url: URL?
    let filter: String?
    
    init(model: Video) {
        url = model.url
        filter = model.filter
    }
}
