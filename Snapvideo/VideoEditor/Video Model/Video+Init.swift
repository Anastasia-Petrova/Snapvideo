//
//  Video+Init.swift
//  Snapvideo
//
//  Created by Anastasia Petrova on 21/04/2020.
//  Copyright © 2020 Anastasia Petrova. All rights reserved.
//

import CoreData

extension Video {
    convenience init() {
        self.init(entity: Video.entity(),
                  insertInto: nil)
    }
}
