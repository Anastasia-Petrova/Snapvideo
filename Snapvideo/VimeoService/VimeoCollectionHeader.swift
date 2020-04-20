//
//  VimeoCollectionHeader.swift
//  Snapvideo
//
//  Created by Anastasia Petrova on 20/04/2020.
//  Copyright © 2020 Anastasia Petrova. All rights reserved.
//

import UIKit

class VimeoCollectionHeader: UICollectionViewCell {
    static let identifier = "VimeoCollectionHeader"
    
    let uploadVideoButton = UIButton()
    
    override init(frame: CGRect) {
    super.init(frame: frame)
        uploadVideoButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(uploadVideoButton)
        NSLayoutConstraint.activate([
            uploadVideoButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            uploadVideoButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            uploadVideoButton.topAnchor.constraint(equalTo: contentView.topAnchor),
            uploadVideoButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        uploadVideoButton.setTitle("Upload video", for: .normal)
        uploadVideoButton.setTitleColor(.lightGray, for: .normal)
        uploadVideoButton.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold)
        uploadVideoButton.addTarget(self, action: #selector(handleUpload), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func handleUpload() {
        print("Handle upload was tapped!!!!")
    }
}
