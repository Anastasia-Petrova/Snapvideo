//
//  SpeedViewController.swift
//  Snapvideo
//
//  Created by Anastasia Petrova on 13/11/2021.
//  Copyright © 2021 Anastasia Petrova. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

final class SpeedViewController: UIViewController {
  let toolBar = UIToolbar(
    frame: CGRect(origin: .zero, size: CGSize(width: 320, height: 44))
  )
  let asset: AVAsset
  let videoViewController: VideoViewController
  let completion: (URL?) -> Void
  
  lazy var resumeImageView = UIImageView(image: UIImage(named: "playCircle")?
                                          .withRenderingMode(.alwaysTemplate))
  lazy var slowDownItem = getBarButtonItem("backward.fill", action: #selector(slowDown))
  lazy var speedUpItem = getBarButtonItem("forward.fill", action: #selector(speedUp))
  lazy var doneItem = getBarButtonItem("checkmark", action: #selector(applySpeedUp))
  let speedLabel = UILabel()
  
  let defaultSpeed = 1.0
  let maxSpeed = 2.00
  let minSpeed = 0.25
  let step = 0.25
  
  var currentSpeed: Double = 1.0 {
    didSet {
      speedLabel.text = "Speed: \(currentSpeed)"
      slowDownItem.isEnabled = isSlowDownEnabled
      speedUpItem.isEnabled = isSpeedUpEnabled
      doneItem.isEnabled = currentSpeed != defaultSpeed
    }
  }

  var isSpeedUpEnabled: Bool {
    currentSpeed < maxSpeed
  }
  
  var isSlowDownEnabled: Bool {
    currentSpeed > minSpeed
  }
  
  init(url: URL, didFinishWithVideoURL completion: @escaping (URL?) -> Void) {
    self.completion = completion
    asset = AVAsset(url: url)
    videoViewController = VideoViewController(asset: asset)
    
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    view.addSubview(videoViewController.view)
    view.addSubview(toolBar)
    
    setUpVideoViewController()
    setUpToolBar()
    setUpSpeedLabel()
    currentSpeed = defaultSpeed
  }
  
  deinit {
    NotificationCenter.default.removeObserver(self)
  }
  
  private func setUpToolBar() {
    toolBar.translatesAutoresizingMaskIntoConstraints = false
    func spacer() -> UIBarButtonItem {
      UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    }
    
    let cancelItem = getBarButtonItem("multiply", action: #selector(cancelAdjustment))
    
    let items = [cancelItem, spacer(), slowDownItem, spacer(), speedUpItem, spacer(), doneItem]
    slowDownItem.isEnabled = isSlowDownEnabled
    speedUpItem.isEnabled = isSpeedUpEnabled
    
    toolBar.tintColor = .darkGray
    toolBar.setItems(items, animated: false)
    
    NSLayoutConstraint.activate([
      toolBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
      toolBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      toolBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      toolBar.heightAnchor.constraint(equalToConstant: 44)
    ])
  }
  
  private func getBarButtonItem(_ imageName: String, action: Selector) -> UIBarButtonItem {
    UIBarButtonItem(
      image: UIImage(systemName: imageName),
      style: .plain,
      target: self,
      action: action
    )
  }
  
  private func setUpSpeedLabel() {
    let speedValueView = ParameterValueView(label: speedLabel)
    speedValueView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(speedValueView)
    
    NSLayoutConstraint.activate ([
      speedValueView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
      speedValueView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor)
    ])
  }
  
  private func setUpVideoViewController() {
    videoViewController.view.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate ([
      videoViewController.view.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
      videoViewController.view.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
      videoViewController.view.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
      videoViewController.view.bottomAnchor.constraint(equalTo: toolBar.topAnchor)
    ])
  }
  
  private func getSpeedMode(_ speed: Double) -> SpeedMode {
    if speed > defaultSpeed {
      let scale = Int64((speed - defaultSpeed) / step)
      return .speedUp(scale: scale)
    } else {
      let scale = Int64((defaultSpeed - speed) / step)
      return .slowDown(scale: scale)
    }
  }
  
  @objc private func cancelAdjustment() {
    dismiss(animated: true, completion: nil)
  }
  
  @objc func speedUp() {
    guard isSpeedUpEnabled else { return }
    currentSpeed += step
  }
  
  @objc func slowDown() {
    guard isSlowDownEnabled else { return }
    currentSpeed -= step
  }
  
  @objc private func applySpeedUp() {
    videoViewController.isActivityIndicatorVisible = true
    guard let playerItem = videoViewController.player.currentItem else { return }
    let asset = playerItem.asset
    guard let mutableComposition = VideoEditor.setUpMutableComposition(
      asset: asset,
      mode: getSpeedMode(currentSpeed)
    ) else {
      return
    }
    VideoEditor.performExportWithMutableComposition(asset: asset, composition: mutableComposition) { url in
      DispatchQueue.main.async {
        self.dismiss(animated: true) {
          self.completion(url)
        }
      }
    }
  }
}
