//
//  AdjustmentSliderView.swift
//  Snapvideo
//
//  Created by Anastasia Petrova on 28/03/2020.
//  Copyright © 2020 Anastasia Petrova. All rights reserved.
//

import UIKit

final class AdjustmentSliderView: UIView {
    
    init() {
        super.init(frame: .zero)
        self.backgroundColor = .clear
        setUpViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpViews() {
        let sliderView = UIView()
        sliderView.backgroundColor = .systemBlue
        
        let adjustmentName = UILabel()
        adjustmentName.font = .systemFont(ofSize: 12)
        adjustmentName.textColor = .systemBlue
        adjustmentName.text = "Adjustment +2"
        adjustmentName.numberOfLines = 1
        adjustmentName.textAlignment = .center
        
        let stackView = UIStackView(arrangedSubviews: [sliderView, adjustmentName])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 4
        self.addSubview(stackView)
        
        NSLayoutConstraint.activate ([
            sliderView.heightAnchor.constraint(equalToConstant: 6),
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: self.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}
