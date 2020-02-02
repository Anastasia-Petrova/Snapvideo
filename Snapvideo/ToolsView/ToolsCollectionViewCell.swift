//
//  ToolsCollectionViewCell.swift
//  Snapvideo
//
//  Created by Anastasia Petrova on 02/02/2020.
//  Copyright © 2020 Anastasia Petrova. All rights reserved.
//

import UIKit

class ToolsCollectionViewCell: UICollectionViewCell {
    let stackView = UIStackView()
    let toolImageView = UIImageView(image: UIImage(named: "placeholder"))
    let toolName = UILabel()
    static let identifier = "ToolsCollectionViewCell"
    
    override func prepareForReuse() {
        super.prepareForReuse()
        toolImageView.image = UIImage(named: "placeholder")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(stackView)
        stackView.addArrangedSubview(toolImageView)
        stackView.addArrangedSubview(toolName)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            toolImageView.heightAnchor.constraint(equalTo: toolImageView.widthAnchor)
        ])
        stackView.alignment = .center
        stackView.axis = .vertical
        stackView.spacing = 6
        toolName.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        toolName.font = UIFont.systemFont(ofSize: 9)
        toolName.numberOfLines = 1
        toolImageView.contentMode = .scaleAspectFill
        toolImageView.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
