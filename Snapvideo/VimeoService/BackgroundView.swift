//
//  BackgroundView.swift
//  Snapvideo
//
//  Created by Anastasia Petrova on 20/04/2020.
//  Copyright © 2020 Anastasia Petrova. All rights reserved.
//

import UIKit

final class BackgroundView: UIView {
    let stackView = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        setUpBackgroundView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpBackgroundView() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(stackView)
        stackView.axis = .vertical
        
        let imageView = UIImageView(image: UIImage(systemName: "video"))
        imageView.tintColor = .lightGray
        imageView.contentMode = .scaleAspectFit
        let label = UILabel()
        label.font = .systemFont(ofSize: 25, weight: .medium)
        label.numberOfLines = 0
        label.text = "You haven't uploaded any videos yet"
        label.textColor = .lightGray
        label.textAlignment = .center
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(label)
        
        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 40),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -40),
            imageView.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}
