//
//  SpeedControllBar.swift
//  Snapvideo
//
//  Created by Anastasia Petrova on 09/11/2021.
//  Copyright © 2021 Anastasia Petrova. All rights reserved.
//

import UIKit

final class SpeedControllBar: UIView {
  typealias DidChangeSpeedCallback = (Double) -> Void
  let speedLabel = UILabel()
  let speedUpButton = UIButton()
  let slowDownButton = UIButton()
  let minSpeed = 0.25
  let maxSpeed = 2.00
  let step = 0.25
  var didChangeSpeed: DidChangeSpeedCallback?
  var speed: Double = 1.0 {
    didSet {
      speedLabel.text = "\(speed)"
    }
  }

  var isSpeedUpEnabled: Bool {
    speed < maxSpeed
  }
  
  var isSlowDownEnabled: Bool {
    speed > minSpeed
  }
  
  init() {
    super.init(frame: .zero)
    backgroundColor = .clear
    setUpSpeedUpButton()
    setUpSlowDownButton()
    setUpSpeedLabel()
    setUpStackView()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setUpStackView() {
    let stackView = UIStackView(arrangedSubviews: [slowDownButton, speedLabel, speedUpButton])
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.axis = .horizontal
    stackView.spacing = 32
    stackView.alignment = .center
    addSubview(stackView)
    
    NSLayoutConstraint.activate ([
      stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
      stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
      stackView.topAnchor.constraint(equalTo: topAnchor),
      stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
    ])
  }
  
  private func setUpSpeedUpButton() {
    setUpButton(
      button: speedUpButton,
      imageName: "forward.fill",
      action: #selector(self.speedUp),
      isEnabled: isSpeedUpEnabled
    )
  }
  
  private func setUpSlowDownButton() {
    setUpButton(
      button: slowDownButton,
      imageName: "backward.fill",
      action: #selector(self.slowDown),
      isEnabled: isSlowDownEnabled
    )
  }
  
  private func setUpButton(
    button: UIButton,
    imageName: String,
    action: Selector,
    isEnabled: Bool
  ) {
    button.translatesAutoresizingMaskIntoConstraints = false
    let image = UIImage(systemName: imageName)?.withRenderingMode(.alwaysTemplate)
    button.setImage(image, for: .normal)
    button.addTarget(self, action: action, for: .touchUpInside)
    NSLayoutConstraint.activate ([
      button.widthAnchor.constraint(equalToConstant: 40),
      button.heightAnchor.constraint(equalToConstant: 40)
    ])
  }
  
  private func setUpSpeedLabel() {
    speedLabel.font = .systemFont(ofSize: 20, weight: .medium)
    speedLabel.numberOfLines = 1
    speedLabel.textColor = .darkGray
    speedLabel.text = "\(speed)"
  }
  
  @objc func speedUp() {
    guard isSpeedUpEnabled else { return }
    speed += step
    didChangeSpeed?(speed)
  }
  
  @objc func slowDown() {
    guard isSlowDownEnabled else { return }
    speed -= step
    didChangeSpeed?(speed)
  }
}
