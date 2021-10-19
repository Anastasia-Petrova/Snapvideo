//
//  HeaderExportLabel.swift
//  Snapvideo
//
//  Created by Anastasia Petrova on 02/02/2020.
//  Copyright © 2020 Anastasia Petrova. All rights reserved.
//

import UIKit

final class HeaderExportLabel: UILabel {
    init() {
        super.init(frame: .zero)
        self.font = .systemFont(ofSize: 13, weight: .medium)
        self.numberOfLines = 1
        self.textColor = .darkGray
        self.textAlignment = .left
        self.setContentCompressionResistancePriority(.required, for: .vertical)
        self.setContentHuggingPriority(.required, for: .vertical)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
