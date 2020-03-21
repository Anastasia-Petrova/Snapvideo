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
    
    static let minOffset: CGFloat = BorderView.borderHeight
    
    var parameters: [Parameter]
    let stackView = UIStackView()
    let container = UIView()
    private let selectionFeedbackGenerator = UISelectionFeedbackGenerator()
    private let selectedParameterRow: ParameterRow
    
    var selectedParameterIndex = 0 {
        didSet {
            if selectedParameterIndex != oldValue {
                selectionFeedbackGenerator.selectionChanged()
                selectedParameterRow.setParameter(parameters[selectedParameterIndex])
            }
        }
    }
    
    let callback: DidSelectParameterCallback
    private var topConstraint: NSLayoutConstraint?
    private var bottomConstraint: NSLayoutConstraint?
    
    var verticalOffset: CGFloat = ParameterListView.minOffset { didSet { setNeedsLayout() } }
  
    var rowHeight: CGFloat {
        return (container.frame.height - borderHeight * 2.0) / CGFloat(parameters.count)
    }
    
    var borderHeight: CGFloat {
        return Self.minOffset
    }
    
    var maxOffset: CGFloat {
      container.frame.height - rowHeight - borderHeight
    }
    
    init(parameters: [Parameter], callback: @escaping DidSelectParameterCallback) {
        self.parameters = parameters
        self.callback = callback
        selectedParameterRow = ParameterRow(parameter: parameters[selectedParameterIndex])
        super.init(frame: .zero)
        setUpStackView()
        setUpSelectedParameterRow()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        topConstraint?.constant = maxOffset - verticalOffset
        bottomConstraint?.constant = verticalOffset
        
        selectedParameterIndex = Self.calculateSelectedRowIndex(offset: Int(verticalOffset - ParameterListView.minOffset), rowHeight: Int(rowHeight))
    }
    
    func setUpStackView() {
        stackView.addArrangedSubview(BorderView(direction: .up))
        parameters
            .map(ParameterRow.init)
            .forEach(stackView.addArrangedSubview)
        stackView.addArrangedSubview(BorderView(direction: .down))
        
        container.backgroundColor = UIColor.white.withAlphaComponent(0.7)
        container.translatesAutoresizingMaskIntoConstraints = false
        addSubview(container)
        
        stackView.axis = .vertical
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
            centerYAnchor.constraint(equalTo: selectedParameterRow.centerYAnchor, constant: ParameterListView.minOffset / 2),
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
    
    static func calculateSelectedRowIndex(offset: Int, rowHeight: Int) -> Int {
        let realIndex = offset/rowHeight
        let realPartition = offset % rowHeight
        let halfRowPartition = rowHeight/2
        
        return realPartition > halfRowPartition ? realIndex + 1 : realIndex
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
            
            setUpLabels(button)
            setParameter(parameter)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func setParameter(_ parameter: Parameter) {
            nameLabel.text = parameter.name
            valueLabel.text = parameter.value
        }
        
        private func setUpLabels(_ button: UIButton) {
            nameLabel.font = .systemFont(ofSize: 18)
            valueLabel.font = .systemFont(ofSize: 18)
            nameLabel.textColor = UIColor.init(white: 50.0/255.0, alpha: 1)
            valueLabel.textColor = UIColor.init(white: 50.0/255.0, alpha: 1)
            
            let stackView = UIStackView(arrangedSubviews: [nameLabel, valueLabel])
            stackView.distribution = .equalSpacing
            stackView.spacing = 16
            
            button.translatesAutoresizingMaskIntoConstraints = false
            stackView.translatesAutoresizingMaskIntoConstraints = false
            addSubview(stackView)
            addSubview(button)
            
            NSLayoutConstraint.activate([
                button.heightAnchor.constraint(equalToConstant: 50),
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
    }
}

extension ParameterListView {
    final private class BorderView: UIView {
        static let borderHeight: CGFloat = 20.0
        
        enum Direction: Equatable {
            case up, down
            
            var image: UIImage {
                switch self {
                case .up:
                    return UIImage(systemName: "chevron.compact.up")!
                case .down:
                    return UIImage(systemName: "chevron.compact.down")!
                }
            }
        }
        
        init(direction: Direction) {
            super.init(frame: .zero)
            setUpChevron(direction: direction)
        }
        
        private func setUpChevron(direction: Direction) {
            let chevron = UIImageView()
            chevron.image = direction.image
            
            chevron.translatesAutoresizingMaskIntoConstraints = false
            addSubview(chevron)
            NSLayoutConstraint.activate([
                chevron.heightAnchor.constraint(equalToConstant: Self.borderHeight),
                chevron.centerXAnchor.constraint(equalTo: centerXAnchor),
                chevron.topAnchor.constraint(equalTo: topAnchor),
                chevron.bottomAnchor.constraint(equalTo: bottomAnchor),
            ])
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
}
