//
//  ToolEditingViewController.swift
//  Snapvideo
//
//  Created by Anastasia Petrova on 13/02/2020.
//  Copyright © 2020 Anastasia Petrova. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

final class AdjustViewController: UIViewController {
    let asset: AVAsset
    let videoViewController: VideoViewController
    let tabBar = TabBar(items: "✕", "✓")
    lazy var resumeImageView = UIImageView(image: UIImage(named: "playCircle")?.withRenderingMode(.alwaysTemplate))
    var slider = UISlider()
    
    var trackDuration: Float {
        guard let trackDuration = videoViewController.player.currentItem?.asset.duration else {
            return 0
        }
        return Float(CMTimeGetSeconds(trackDuration))
    }
    
    init(url: URL, tool: AnyTool) {
        asset = AVAsset(url: url)
        videoViewController = VideoViewController(asset: asset)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        view.addSubview(videoViewController.view)
        view.addSubview(tabBar)
        setUpVideoViewController()
        setUpSlider()
        setUpTabBar()
    }
    
     deinit {
         NotificationCenter.default.removeObserver(self)
     }
     
     private func setUpTabBar() {
         tabBar.delegate = self
         tabBar.translatesAutoresizingMaskIntoConstraints = false
         tabBar.setContentHuggingPriority(.required, for: .vertical)
         tabBar.setContentCompressionResistancePriority(.required, for: .vertical)
         NSLayoutConstraint.activate([
             tabBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
             tabBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
             tabBar.trailingAnchor.constraint(equalTo: view.trailingAnchor)
         ])
     }
    
    func setUpSlider() {
        slider.translatesAutoresizingMaskIntoConstraints = false
        videoViewController.view.addSubview(slider)
        NSLayoutConstraint.activate ([
            slider.leadingAnchor.constraint(equalTo: videoViewController.view.leadingAnchor, constant: 50),
            slider.trailingAnchor.constraint(equalTo: videoViewController.view.trailingAnchor, constant: -50),
            slider.bottomAnchor.constraint(equalTo: videoViewController.view.bottomAnchor, constant: -40)])
        slider.minimumValue = 0
        slider.maximumValue = trackDuration
        slider.addTarget(self, action: #selector(self.sliderAction), for: .valueChanged)
    }
    
    func setUpVideoViewController() {
        videoViewController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate ([
            videoViewController.view.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            videoViewController.view.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            videoViewController.view.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            videoViewController.view.bottomAnchor.constraint(equalTo: tabBar.topAnchor)
        ])
    }
    
    @objc func sliderAction() {
        videoViewController.player.seek(
            to: CMTime(
                seconds: Double(slider.value),
                preferredTimescale: 1
            ),
            toleranceBefore: CMTime.zero,
            toleranceAfter: CMTime.zero
        )
    }
}

extension AdjustViewController: UITabBarDelegate {
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {

    }
}
