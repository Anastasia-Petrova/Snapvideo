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
    static let minOffset: CGFloat = 0.0
    
    var parameters: [Parameter]
    let stackView = UIStackView()
    let container = UIView()
    private let selectedParameterRow: ParameterRow
    
    let callback: DidSelectParameterCallback
    private var topConstraint: NSLayoutConstraint?
    private var bottomConstraint: NSLayoutConstraint?
    
    var verticalOffset: CGFloat = ParameterListView.minOffset { didSet { setNeedsLayout() } }
  
    var rowHeight: CGFloat {
        let heightNoSpacings = container.frame.height - CGFloat(parameters.count - 1) * Self.rowVerticalSpacing
        return heightNoSpacings / CGFloat(parameters.count)
    }
    
    var maxOffset: CGFloat {
      container.frame.height - rowHeight
    }
    
    init(parameters: [Parameter], callback: @escaping DidSelectParameterCallback) {
        self.parameters = parameters
        self.callback = callback
        selectedParameterRow = ParameterRow(parameter: parameters.first ?? Parameter(name: "", value: "")) //TODO: use NonEmpty array
        super.init(frame: .zero)
        setUpStackView()
        setUpSelectedParameterRow()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        topConstraint?.constant = maxOffset - verticalOffset
        bottomConstraint?.constant = Self.minOffset + verticalOffset
    }
    
    func setUpStackView() {
        parameters
            .map(ParameterRow.init)
            .forEach(stackView.addArrangedSubview)
        
        container.backgroundColor = UIColor.white.withAlphaComponent(0.7)
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

    func setUpSelectedParameterRow() {
        selectedParameterRow.backgroundColor = .systemBlue
        selectedParameterRow.labels.forEach { $0.textColor = .white }
        
        selectedParameterRow.translatesAutoresizingMaskIntoConstraints = false
        addSubview(selectedParameterRow)
        NSLayoutConstraint.activate([
            centerYAnchor.constraint(equalTo: selectedParameterRow.centerYAnchor),
            leadingAnchor.constraint(equalTo: selectedParameterRow.leadingAnchor),
            trailingAnchor.constraint(equalTo: selectedParameterRow.trailingAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func translateY(_ translationY: CGFloat) {
        let newVerticalOffset = verticalOffset + translationY
        
        guard newVerticalOffset < maxOffset else {
            verticalOffset = maxOffset
            return
        }
        guard newVerticalOffset > Self.minOffset else {
            verticalOffset = Self.minOffset
            return
        }
        verticalOffset = newVerticalOffset
    }
}

extension ParameterListView {
    struct Parameter: Equatable {
        let name: String
        var value: String
    }
}

extension ParameterListView {
    final private class ParameterRow: UIView {
        var labels: [UILabel] {
            [nameLabel, valueLabel]
        }
        
        let nameLabel = UILabel()
        let valueLabel = UILabel()
        
        init(parameter: Parameter) {
            super.init(frame: .zero)
            
            let button = UIButton()
            
            nameLabel.text = parameter.name
            nameLabel.font = .systemFont(ofSize: 18)
            nameLabel.textColor = UIColor.init(white: 50.0/255.0, alpha: 1)
            valueLabel.text = parameter.value
            valueLabel.font = .systemFont(ofSize: 18)
            valueLabel.textColor = UIColor.init(white: 50.0/255.0, alpha: 1)
            
            let stackView = UIStackView(arrangedSubviews: [nameLabel, valueLabel])
            stackView.distribution = .equalSpacing
            stackView.spacing = 16
            
            button.translatesAutoresizingMaskIntoConstraints = false
            stackView.translatesAutoresizingMaskIntoConstraints = false
            addSubview(stackView)
            addSubview(button)
            
            NSLayoutConstraint.activate([
                stackView.topAnchor.constraint(equalTo: topAnchor),
                stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
                stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
                trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: 16),
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
