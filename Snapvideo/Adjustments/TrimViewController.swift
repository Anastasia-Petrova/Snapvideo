//
//  CutViewController.swift
//  Snapvideo
//
//  Created by Anastasia Petrova on 14/11/2021.
//  Copyright © 2021 Anastasia Petrova. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

final class TrimViewController: UIViewController {
  let toolBar = UIToolbar(
    frame: CGRect(origin: .zero, size: CGSize(width: 320, height: 44))
  )
  
  let asset: AVAsset
  let maxVideoDuration: Double
  let videoViewController: VideoViewController
  let sliderView: AdjustmentSliderView
  
  let completion: (URL?) -> Void
  
  let doneItem = UIBarButtonItem(
    image: UIImage(systemName: "checkmark"),
    style: .plain,
    target: self,
    action: #selector(applyTrim)
  )
  
  lazy var resumeImageView = UIImageView(image: UIImage(named: "playCircle")?
                                          .withRenderingMode(.alwaysTemplate))
  
  var previousTranslation: CGPoint = .zero
  var isVerticalPan = false
  var currentVideoDuration: Double {
    didSet {
      doneItem.isEnabled = currentVideoDuration != maxVideoDuration
    }
  }
  
  lazy var panGestureRecognizer = UIPanGestureRecognizer(
    target: self,
    action: #selector(handlePanGesture)
  )
  
  init(url: URL, didFinishWithVideoURL completion: @escaping (URL?) -> Void) {
    self.completion = completion
    asset = AVAsset(url: url)
    videoViewController = VideoViewController(asset: asset)
    maxVideoDuration = asset.duration.seconds
    sliderView = AdjustmentSliderView(
      name: "Cut",
      value: maxVideoDuration,
      minPercent: 0.0
    )
    currentVideoDuration = maxVideoDuration
    super.init(nibName: nil, bundle: nil)
    sliderView.didChangeValue = { [weak self] value in
      self?.updateCurrentDuration(value)
    }
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    view.addSubview(videoViewController.view)
    view.addSubview(sliderView)
    view.addSubview(toolBar)
    
    setUpVideoViewController()
    setUpSliderView()
    setUpToolBar()
    setUpPanGestureRecognizer()
  }
  
  deinit {
    NotificationCenter.default.removeObserver(self)
  }
  
  private func setUpSliderView() {
    sliderView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      sliderView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
      sliderView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
      sliderView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10)
    ])
  }
  
  private func setUpToolBar() {
    toolBar.translatesAutoresizingMaskIntoConstraints = false
    func spacer() -> UIBarButtonItem {
      UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    }
    
    let cancelItem = UIBarButtonItem(image: UIImage(systemName: "multiply"), style: .plain, target: self, action: #selector(cancelAdjustment))
    
    let items = [cancelItem, spacer(), doneItem]
    toolBar.tintColor = .darkGray
    toolBar.setItems(items, animated: false)
    
    NSLayoutConstraint.activate([
      toolBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
      toolBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      toolBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      toolBar.heightAnchor.constraint(equalToConstant: 44)
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
  
  private func setUpPanGestureRecognizer() {
    videoViewController.view.addGestureRecognizer(panGestureRecognizer)
  }
  
  @objc private func handlePanGesture(_ recognizer: UIPanGestureRecognizer) {
    let translation = recognizer.translation(in: videoViewController.view)
    
    if recognizer.state == .began {
      let velocity = recognizer.velocity(in: self.view)
      isVerticalPan = abs(velocity.y) > abs(velocity.x) ? true : false
    }
    if isVerticalPan {
      //TODO: CLEAN UP
    } else {
      updateSlider(translation: translation, state: recognizer.state)
    }
  }
  
  private func updateCurrentDuration(_ value: Double) {
    currentVideoDuration = value
  }
  
  private func updateSlider(translation: CGPoint, state: UIGestureRecognizer.State) {
    let deltaX = previousTranslation.x - translation.x
    previousTranslation.x = translation.x
    sliderView.setDelta(deltaX)
    switch state {
    case .ended:
      previousTranslation = .zero
    default: break
    }
  }
  
  @objc private func cancelAdjustment() {
    dismiss(animated: true, completion: nil)
  }
  
  @objc private func applyTrim() {
    videoViewController.isActivityIndicatorVisible = true
    guard let asset = videoViewController.player.currentItem?.asset,
          let session = VideoEditor.trimSession(asset: asset, startTime: 0.0, endTime: 2.0) else {
      dismiss(animated: true) {
        self.completion(nil)
      }
      return
    }
    
    session.export { result in
      DispatchQueue.main.async {
        self.dismiss(animated: true) {
          switch result {
          case let .success(url):
            self.completion(url)
          case .failure:
            self.completion(nil)
          }
        }
      }
    }
  }
}



