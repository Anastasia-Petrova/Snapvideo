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
    
    let videoImageView = UIImageView()
    let uploadVideoLabel = UILabel()
    let activityIndicator = UIActivityIndicatorView()
    let uploadVideoButton = HightlightedButton()
    var callback: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        prepareViewsForHeader()
        setUpHeaderStackView()
        setUpUploadButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpHeaderStackView() {
        let stackView = UIStackView()
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 20
        stackView.addArrangedSubview(activityIndicator)
        stackView.addArrangedSubview(videoImageView)
        stackView.addArrangedSubview(uploadVideoLabel)
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            stackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
    }
    
    private func prepareViewsForHeader() {
        uploadVideoLabel.font = .systemFont(ofSize: 22, weight: .medium)
        uploadVideoLabel.numberOfLines = 1
        uploadVideoLabel.textColor = .systemBlue
        uploadVideoLabel.textAlignment = .left
        uploadVideoLabel.text = "Upload video"
        
        activityIndicator.color = .systemBlue
        activityIndicator.hidesWhenStopped = true
        
        let image = UIImage(systemName: "arrow.up.right.video")?.withRenderingMode(.alwaysTemplate)
        videoImageView.image = image
        videoImageView.contentMode = .scaleAspectFit
        videoImageView.tintColor = .systemBlue
        
        NSLayoutConstraint.activate([
            videoImageView.widthAnchor.constraint(equalToConstant: 35),
            videoImageView.heightAnchor.constraint(equalToConstant: 35)
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
    
    func setActivityIndicatorOn(_ isOn: Bool) {
        videoImageView.isHidden = isOn
        uploadVideoButton.isEnabled = !isOn
        uploadVideoLabel.text = isOn ? "Uploading..." : "Upload video"
        if isOn {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
    
    @objc func handleUpload() {
        setActivityIndicatorOn(true)
        callback?()
    }
}
