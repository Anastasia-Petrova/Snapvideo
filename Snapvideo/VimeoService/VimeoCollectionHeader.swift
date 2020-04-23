//
//  VimeoCollectionHeader.swift
//  Snapvideo
//
//  Created by Anastasia Petrova on 20/04/2020.
//  Copyright © 2020 Anastasia Petrova. All rights reserved.
//

import UIKit

final class VimeoCollectionHeader: UICollectionViewCell {
    static let identifier = "VimeoCollectionHeader"
    
    let imageView = ExportImageView(systemName: "arrow.up.right.video")
    let uploadVideoButton = HightlightedButton()
    var callback: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpHeaderView()
        setUpUploadButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpHeaderView() {
        let stackView = UIStackView()
        let image = UIImage(systemName: "arrow.up.right.video")?.withRenderingMode(.alwaysTemplate)
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .systemBlue
        
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .medium)
        label.numberOfLines = 1
        label.textColor = .systemBlue
        label.textAlignment = .left
        label.text = "Upload video"
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 20
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(label)
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            stackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 35),
            imageView.heightAnchor.constraint(equalToConstant: 35)
        ])
    }
    
    private func setUpUploadButton() {
        uploadVideoButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(uploadVideoButton)
        NSLayoutConstraint.activate ([
            uploadVideoButton.leadingAnchor.constraint(equalTo:  contentView.leadingAnchor),
            uploadVideoButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            uploadVideoButton.topAnchor.constraint(equalTo: contentView.topAnchor),
            uploadVideoButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
        uploadVideoButton.addTarget(self, action: #selector(handleUpload), for: .touchUpInside)
    }
    
    @objc func handleUpload() {
        callback?()
    }
}
