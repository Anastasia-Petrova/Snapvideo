//
//  AdjustmentSliderView.swift
//  Snapvideo
//
//  Created by Anastasia Petrova on 28/03/2020.
//  Copyright © 2020 Anastasia Petrova. All rights reserved.
//

import UIKit

final class AdjustmentSliderView: UIView {
    private let sliderLayer = CAShapeLayer()
    let separatorLayer = CAShapeLayer()
    private let valueLabel = UILabel()
    var name: String {
        didSet {
            setNeedsLayout()
        }
    }
    
    var value: CGFloat {
        didSet {
            setNeedsLayout()
        }
    }
    
    var isPositive: Bool {
        value >= 0
    }
    
    init(name: String, value: CGFloat) {
        self.name = name
        self.value = value
        super.init(frame: .zero)
        backgroundColor = .clear
        setUpViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setSeparatorSliderPosition()
        updateValueSlider()
        updateValueLabel()
    }
    
    private func setUpViews() {
        let sliderView = makeSliderView()
        
        valueLabel.font = .systemFont(ofSize: 14, weight: .medium)
        valueLabel.textColor = .darkGray
        valueLabel.numberOfLines = 1
        valueLabel.textAlignment = .center
        
        let labelContainer = UIView()
        labelContainer.backgroundColor = UIColor.white.withAlphaComponent(0.7)
        labelContainer.addSubview(valueLabel)
        labelContainer.layer.cornerRadius = 12.0
        labelContainer.layer.masksToBounds = true
        
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        let verticalOffset: CGFloat = 6
        let horizontalOffset: CGFloat = 12
        NSLayoutConstraint.activate ([
            valueLabel.leadingAnchor.constraint(equalTo: labelContainer.leadingAnchor, constant: horizontalOffset),
            valueLabel.trailingAnchor.constraint(equalTo: labelContainer.trailingAnchor, constant: -horizontalOffset),
            valueLabel.topAnchor.constraint(equalTo: labelContainer.topAnchor, constant: verticalOffset),
            valueLabel.bottomAnchor.constraint(equalTo: labelContainer.bottomAnchor, constant: -verticalOffset)
        ])
        
        let labelStackView = UIStackView(arrangedSubviews: [labelContainer])
        labelStackView.axis = .vertical
        labelStackView.alignment = .center
        
        let stackView = UIStackView(arrangedSubviews: [sliderView, labelStackView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 10
        addSubview(stackView)
        
        NSLayoutConstraint.activate ([
            sliderView.heightAnchor.constraint(equalToConstant: 6),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func updateValueSlider() {
        let path = UIBezierPath(
            rect: CGRect(
                origin: .zero,
                size: CGSize(
                    width: isPositive ? value : -value,
                    height: 6
                )
            )
        ).cgPath
        let center = bounds.width/2.0
        let position = CGPoint(
            x: isPositive ? center : center - -value,
            y: 0
        )
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        sliderLayer.path = path
        sliderLayer.position = position
        CATransaction.commit()
    }
    
    private func updateValueLabel() {
        valueLabel.text = name + " " + "\(isPositive ? "+" : "")" + "\(Int(value))"
    }
    
    private func makeSliderView() -> UIView {
        let sliderView = UIView()
        sliderView.backgroundColor = .white
        
        sliderLayer.lineWidth = 0.0
        sliderLayer.strokeColor = UIColor.clear.cgColor
        sliderLayer.fillColor = UIColor.systemBlue.cgColor
        sliderView.layer.addSublayer(sliderLayer)
        
        separatorLayer.lineWidth = 0.0
        separatorLayer.strokeColor = UIColor.clear.cgColor
        separatorLayer.fillColor = UIColor.red.cgColor
        sliderView.layer.addSublayer(separatorLayer)
        
        return sliderView
    }
    
    private func setSeparatorSliderPosition() {
        let path = UIBezierPath(
            rect: CGRect(
                origin: .zero,
                size: CGSize(
                    width: 1,
                    height: 12
                )
            )
        ).cgPath
        let center = bounds.width/2.0
        let position = CGPoint(
            x: center,
            y: 0
        )
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        separatorLayer.path = path
        separatorLayer.position = position
        CATransaction.commit()
    }
}
