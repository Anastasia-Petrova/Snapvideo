//
//  VimeoUploadResponse.swift
//  Snapvideo
//
//  Created by Anastasia Petrova on 24/04/2020.
//  Copyright © 2020 Anastasia Petrova. All rights reserved.
//

import Foundation
import VimeoNetworking

struct VimeoUploadResponse: Codable {
    let uploadOffset: String
    
    enum CodingKeys: String, CodingKey {
        case uploadOffset = "Upload-Offset"
    }
}

