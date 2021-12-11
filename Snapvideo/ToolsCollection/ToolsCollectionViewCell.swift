//
//  ToolsCollectionViewCell.swift
//  Snapvideo
//
//  Created by Anastasia Petrova on 02/02/2020.
//  Copyright © 2020 Anastasia Petrova. All rights reserved.
//

import UIKit

final class ToolsCollectionViewCell: UICollectionViewCell {
    let toolImageView = UIImageView(image: UIImage(named: "placeholder"))
    let toolName = UILabel()
    static let identifier = "ToolsCollectionViewCell"
    
    override func prepareForReuse() {
        super.prepareForReuse()
        toolImageView.image = UIImage(named: "placeholder")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let stackView = UIStackView(arrangedSubviews: [
            toolImageView,
            toolName
        ])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.bottomAnchor.constraint(greaterThanOrEqualTo: contentView.bottomAnchor),
            toolImageView.heightAnchor.constraint(equalTo: toolImageView.widthAnchor),
            toolImageView.widthAnchor.constraint(equalToConstant: frame.width * 0.5)
        ])
        stackView.alignment = .center
        stackView.axis = .vertical
        stackView.spacing = 8
        toolName.setContentCompressionResistancePriority(.required, for: .vertical)
        toolName.font = UIFont.systemFont(ofSize: 14)
        toolName.numberOfLines = 0
        toolName.textAlignment = .center
        toolName.lineBreakMode = .byWordWrapping
        toolImageView.contentMode = .scaleAspectFill
        toolImageView.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
