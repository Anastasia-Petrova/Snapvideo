//
//  BodyExportLabel.swift
//  Snapvideo
//
//  Created by Anastasia Petrova on 02/02/2020.
//  Copyright © 2020 Anastasia Petrova. All rights reserved.
//

import UIKit

final class BodyExportLabel: UILabel {
    init() {
        super.init(frame: .zero)
        self.font = .systemFont(ofSize: 10, weight: .medium)
        self.numberOfLines = 0
        self.textColor = .lightGray
        self.textAlignment = .left
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
