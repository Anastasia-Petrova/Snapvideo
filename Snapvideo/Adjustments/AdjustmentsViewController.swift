//
//  ToolEditingViewController.swift
//  Snapvideo
//
//  Created by Anastasia Petrova on 13/02/2020.
//  Copyright © 2020 Anastasia Petrova. All rights reserved.
//

import UIKit
import AVFoundation

final class AdjustmentsViewController: UIViewController {
    let asset: AVAsset
    let videoViewController: VideoViewController
    let listView: ParameterListView
    let tabBar = TabBar(items: "✕", "✓")
    lazy var resumeImageView = UIImageView(image: UIImage(named: "playCircle")?.withRenderingMode(.alwaysTemplate))
    
    var previousTranslationY: CGFloat = 0
    
    lazy var panGestureRecognizer = UIPanGestureRecognizer(
        target: self,
        action: #selector(handlePanGesture)
    )
    
    var trackDuration: Float {
        guard let trackDuration = videoViewController.player.currentItem?.asset.duration else {
            return 0
        }
        return Float(CMTimeGetSeconds(trackDuration))
    }
    
    init(url: URL, tool: AnyTool) {
        asset = AVAsset(url: url)
        videoViewController = VideoViewController(asset: asset)
        listView = ParameterListView(parameters: [
            ParameterListView.Parameter(name: "Hello", value: "10"),
            ParameterListView.Parameter(name: "World World World", value: "20"),
            ParameterListView.Parameter(name: "Hello", value: "10"),
            ParameterListView.Parameter(name: "World World World", value: "20"),
            ParameterListView.Parameter(name: "Hello", value: "10"),
            ParameterListView.Parameter(name: "World World World", value: "20"),
            ParameterListView.Parameter(name: "Hello", value: "10"),
            ParameterListView.Parameter(name: "World World World", value: "20"),
        ]) { _ in }
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(videoViewController.view)
        view.addSubview(listView)
        view.addSubview(tabBar)
        
        setUpVideoViewController()
        setUpParameterListView()
        setUpTabBar()
        setUpPanGestureRecognizer()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func setUpParameterListView() {
        listView.isHidden = true
        listView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            listView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),
            listView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            listView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
        ])
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
    
    private func setUpVideoViewController() {
        videoViewController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate ([
            videoViewController.view.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            videoViewController.view.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            videoViewController.view.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            videoViewController.view.bottomAnchor.constraint(equalTo: tabBar.topAnchor)
        ])
    }
    
    private func setUpPanGestureRecognizer() {
        videoViewController.view.addGestureRecognizer(panGestureRecognizer)
    }
    
    @objc func handlePanGesture(_ recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: videoViewController.view)
        let deltaY = previousTranslationY - translation.y
        previousTranslationY = translation.y
        listView.translateY(deltaY)
        switch recognizer.state {
        case .began:
            listView.isHidden = false
        case .ended:
            listView.isHidden = true
            previousTranslationY = 0
        default: break
        }
    }
}

extension AdjustmentsViewController: UITabBarDelegate {
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
    }
}
