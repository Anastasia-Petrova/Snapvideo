//
//  ParameterValueView.swift
//  Snapvideo
//
//  Created by Anastasia Petrova on 13/11/2021.
//  Copyright © 2021 Anastasia Petrova. All rights reserved.
//

import UIKit

final class ParameterValueView: UIView {
  let valueLabel: UILabel
  
  init(label: UILabel) {
    self.valueLabel = label
    super.init(frame: .zero)
    setUpValueView()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setUpValueView() {
    valueLabel.translatesAutoresizingMaskIntoConstraints = false
    valueLabel.font = .systemFont(ofSize: 14, weight: .medium)
    valueLabel.textColor = .darkGray
    valueLabel.numberOfLines = 1
    valueLabel.textAlignment = .center
    
    let labelContainer = UIView()
    labelContainer.translatesAutoresizingMaskIntoConstraints = false
    labelContainer.backgroundColor = UIColor.white.withAlphaComponent(0.7)
    labelContainer.addSubview(valueLabel)
    labelContainer.layer.cornerRadius = 12.0
    labelContainer.layer.masksToBounds = true
    
    let verticalOffset: CGFloat = 6
    let horizontalOffset: CGFloat = 12
    NSLayoutConstraint.activate ([
      valueLabel.leadingAnchor.constraint(equalTo: labelContainer.leadingAnchor, constant: horizontalOffset),
      valueLabel.trailingAnchor.constraint(equalTo: labelContainer.trailingAnchor, constant: -horizontalOffset),
      valueLabel.topAnchor.constraint(equalTo: labelContainer.topAnchor, constant: verticalOffset),
      valueLabel.bottomAnchor.constraint(equalTo: labelContainer.bottomAnchor, constant: -verticalOffset)
    ])
    addSubview(labelContainer)
    NSLayoutConstraint.activate ([
      labelContainer.leadingAnchor.constraint(equalTo: leadingAnchor),
      labelContainer.trailingAnchor.constraint(equalTo: trailingAnchor),
      labelContainer.topAnchor.constraint(equalTo: topAnchor),
      labelContainer.bottomAnchor.constraint(equalTo: bottomAnchor)
    ])
  }
}

