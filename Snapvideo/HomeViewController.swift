//
//  HomeViewController.swift
//  Snapvideo
//
//  Created by Anastasia Petrova on 02/02/2020.
//  Copyright © 2020 Anastasia Petrova. All rights reserved.
//

import UIKit
import AVKit
import MobileCoreServices

final class HomeViewController: UIViewController {
    private let app = App.shared
    private var addVideoButton = UIButton()
    private var videoEditorViewController: VideoEditorViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.navigationController?.navigationBar.barTintColor = .white
        self.navigationController?.hideHairline()
        setUpStackView()
        setUpAddVideoButton()
        setUpOpenButton()
    }
    
    func setUpOpenButton() {
        let openButton = UIBarButtonItem(title: "OPEN", style: .plain, target: self, action: #selector(handleAddVideoTap))
        openButton.setTitleTextAttributes([NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15, weight: .semibold), NSAttributedString.Key.foregroundColor : UIColor.gray], for: .normal)
        navigationItem.leftBarButtonItem = openButton
    }
    
    private func setUpStackView() {
        let imageView = UIImageView(image: UIImage(named: "addButton")?.withRenderingMode(.alwaysTemplate))
        imageView.tintColor = .lightGray
        
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.numberOfLines = 0
        label.text = "Tap anywhere to choose a video"
        label.textColor = .lightGray
        label.textAlignment = .center
        
        let stackView = UIStackView()
        stackView.alignment = .center
        stackView.axis = .vertical
        stackView.spacing = 32
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(label)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        NSLayoutConstraint.activate ([
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            view.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: 16),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setUpAddVideoButton() {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        NSLayoutConstraint.activate ([
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            button.topAnchor.constraint(equalTo: view.topAnchor),
            button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
        button.addTarget(self, action: #selector(handleAddVideoTap), for: .touchUpInside)
    }
    
    @objc private func handleAddVideoTap() {
         VideoBrowser.startMediaBrowser(delegate: self, sourceType: .savedPhotosAlbum)
    }
    
    private func embed(_ videoEditorVC: VideoEditorViewController) {
        self.videoEditorViewController = videoEditorVC
        videoEditorVC.view.translatesAutoresizingMaskIntoConstraints = false
        addChild(videoEditorVC)
        view.addSubview(videoEditorVC.view)
        NSLayoutConstraint.activate([
            videoEditorVC.view.topAnchor.constraint(equalTo: view.topAnchor),
            videoEditorVC.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            videoEditorVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            videoEditorVC.view.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        videoEditorVC.didMove(toParent: self)
        videoEditorVC.view.isHidden = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            videoEditorVC.view.isHidden = false
        }
    }
    
    func removeEmbeddedViewController() {
        guard let childVC = videoEditorViewController else { return }
        childVC.removeFromParent()
        childVC.view.removeFromSuperview()
    }
}

extension HomeViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let mediaType = info[UIImagePickerController.InfoKey.mediaType] as? String,
            mediaType == (kUTTypeMovie as String),
            let url = info[UIImagePickerController.InfoKey.mediaURL] as? URL else {
                return
        }
        dismiss(animated: true) {
            self.removeEmbeddedViewController()
            self.embed(VideoEditorViewController(url: url, index: 0, filters: self.app.filters, tools: self.app.tools))
        }
    }
}

extension HomeViewController: UINavigationControllerDelegate {}

extension UINavigationController {
    func hideHairline() {
        let hairline = findHairlineImageViewUnder(navigationBar)
        hairline?.isHidden = true
    }

    func findHairlineImageViewUnder(_ view: UIView) -> UIImageView? {
        if view is UIImageView && view.bounds.size.height <= 1.0 {
            return view as? UIImageView
        }
        for subview in view.subviews {
            if let imageView = findHairlineImageViewUnder(subview) {
                return imageView
            }
        }
        return nil
    }
}
