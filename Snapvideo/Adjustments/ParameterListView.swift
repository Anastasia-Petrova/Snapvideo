//
//  ParameterListView.swift
//  Snapvideo
//
//  Created by Anastasia Petrova on 23/02/2020.
//  Copyright © 2020 Anastasia Petrova. All rights reserved.
//

import UIKit

final class ParameterListView: UIView {
    typealias DidSelectParameterCallback = (Parameter) -> Void
    static let rowVerticalSpacing: CGFloat = 8.0
    
    var parameters: [Parameter]
    let stackView = UIStackView()
    let container = UIView()
    let selectedParameterView: ParameterView
    
    let callback: DidSelectParameterCallback
    private var topConstraint: NSLayoutConstraint?
    private var bottomConstraint: NSLayoutConstraint?
    
    var offset: CGFloat = 0.0 { didSet { setNeedsLayout() } }
  
    var rowHeight: CGFloat {
        let heightNoSpacings = container.frame.height - CGFloat(parameters.count - 1) * Self.rowVerticalSpacing
        return heightNoSpacings / CGFloat(parameters.count)
    }
    
    var maxOffset: CGFloat {
      container.frame.height - rowHeight
    }
    
    let minOffset: CGFloat = 0.0
    
    init(parameters: [Parameter], callback: @escaping DidSelectParameterCallback) {
        self.parameters = parameters
        self.callback = callback
        selectedParameterView = ParameterView(parameter: parameters.first ?? Parameter(name: "", value: "")) //TODO: use NonEmpty array
        super.init(frame: .zero)
        setUpStackView()
        setUpSelectedParameterView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        topConstraint?.constant = maxOffset - offset
        bottomConstraint?.constant = minOffset + offset
    }
    
    func setUpStackView() {
        parameters
            .map(ParameterView.init)
            .forEach(stackView.addArrangedSubview)
        
        container.backgroundColor = UIColor.white.withAlphaComponent(0.6)
        container.translatesAutoresizingMaskIntoConstraints = false
        addSubview(container)
        
        stackView.axis = .vertical
        stackView.spacing = Self.rowVerticalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(stackView)
        
        let topConstraint = container.topAnchor.constraint(equalTo: topAnchor)
        let bottomConstraint = bottomAnchor.constraint(equalTo: container.bottomAnchor)
        NSLayoutConstraint.activate([
            topConstraint,
            bottomConstraint,
            leadingAnchor.constraint(equalTo: container.leadingAnchor),
            trailingAnchor.constraint(equalTo: container.trailingAnchor),
            container.topAnchor.constraint(equalTo: stackView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: container.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: container.trailingAnchor),
        ])
        self.bottomConstraint = bottomConstraint
        self.topConstraint = topConstraint
    }

    func setUpSelectedParameterView() {
        selectedParameterView.backgroundColor = .blue
        selectedParameterView.labels.forEach { $0.textColor = .white }
        
        selectedParameterView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(selectedParameterView)
        NSLayoutConstraint.activate([
            centerYAnchor.constraint(equalTo: selectedParameterView.centerYAnchor),
            leadingAnchor.constraint(equalTo: selectedParameterView.leadingAnchor),
            trailingAnchor.constraint(equalTo: selectedParameterView.trailingAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func translateY(_ translation: CGFloat) {
        let newOffsetY = offset + translation
        
        guard newOffsetY < maxOffset else {
            offset = maxOffset
            return
        }
        guard newOffsetY > minOffset else {
            offset = minOffset
            return
        }
        offset = offset + translation
    }
}

extension ParameterListView {
    struct Parameter: Equatable {
        let name: String
        var value: String
    }
}

extension ParameterListView {
    final class ParameterView: UIView {
        var labels: [UILabel] {
            [nameLabel, valueLabel]
        }
        
        let nameLabel = UILabel()
        let valueLabel = UILabel()
        
        init(parameter: Parameter) {
            super.init(frame: .zero)
            
            let stackView = UIStackView()
            let button = UIButton()
            
            nameLabel.text = parameter.name
            nameLabel.font = .systemFont(ofSize: 18)
            valueLabel.text = parameter.value
            valueLabel.font = .systemFont(ofSize: 18)
            
            stackView.addArrangedSubview(nameLabel)
            stackView.addArrangedSubview(valueLabel)
            stackView.distribution = .equalSpacing
            stackView.spacing = 16
            
            button.translatesAutoresizingMaskIntoConstraints = false
            stackView.translatesAutoresizingMaskIntoConstraints = false
            addSubview(stackView)
            addSubview(button)
            
            NSLayoutConstraint.activate([
                stackView.topAnchor.constraint(equalTo: topAnchor),
                stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
                stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
                stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
                button.topAnchor.constraint(equalTo: topAnchor),
                button.bottomAnchor.constraint(equalTo: bottomAnchor),
                button.leadingAnchor.constraint(equalTo: leadingAnchor),
                button.trailingAnchor.constraint(equalTo: trailingAnchor),
            ])
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
}
