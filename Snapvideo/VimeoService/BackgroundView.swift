//
//  BackgroundView.swift
//  Snapvideo
//
//  Created by Anastasia Petrova on 20/04/2020.
//  Copyright © 2020 Anastasia Petrova. All rights reserved.
//

import UIKit

final class BackgroundView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        setUpBackgroundView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpBackgroundView() {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(label)
        label.font = .systemFont(ofSize: 25, weight: .medium)
        label.numberOfLines = 0
        label.text = "You don't have any videos yet"
        label.textColor = .lightGray
        label.textAlignment = .center
        
        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 40),
            label.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -40)
        ])
    }
}
