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
    
    static let minOffset: CGFloat = 0.0
    
    var parameters: [Parameter]
    let stackView = UIStackView()
    let container = UIView()
    private let selectionFeedbackGenerator = UISelectionFeedbackGenerator()
    private let selectedParameterRow: ParameterRow
    
    var selectedParameterIndex = 0 {
        didSet {
            guard selectedParameterIndex != oldValue else { return }
            
            selectionFeedbackGenerator.selectionChanged()
            updateParameterLabelsVisibility(selectedIndex: selectedParameterIndex, deselectedIndex: oldValue)
            selectedParameterRow.setParameter(parameters[selectedParameterIndex])
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
        return BorderView.borderHeight
    }
    
    var maxOffset: CGFloat {
        container.frame.height - rowHeight - borderHeight * 2.0
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
        bottomConstraint?.constant = Self.minOffset + verticalOffset
        
        selectedParameterIndex = Self.calculateSelectedRowIndex(offset: Int(verticalOffset - ParameterListView.minOffset), rowHeight: Int(rowHeight))
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
    
    func setUpStackView() {
        stackView.addArrangedSubview(BorderView(direction: .up))
        parameters
            .map(ParameterRow.init)
            .forEach(stackView.addArrangedSubview)
        stackView.addArrangedSubview(BorderView(direction: .down))
        
        container.layer.cornerRadius = 3.0
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
    
    func updateParameterLabelsVisibility(selectedIndex: Int, deselectedIndex: Int) {
        func setParameterRow(_ view: UIView, isHidden: Bool) {
            guard let row = view as? ParameterRow else { return }
            row.nameLabel.alpha = isHidden ? 0.0 : 1.0
            row.valueLabel.alpha = isHidden ? 0.0 : 1.0
        }
        
        let parameters = stackView.arrangedSubviews
        setParameterRow(parameters[deselectedIndex + 1], isHidden: false)
        setParameterRow(parameters[selectedIndex + 1], isHidden: true)
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
            nameLabel.setText(parameter.name, animationDuration: 0.2)
            valueLabel.setText(parameter.value, animationDuration: 0.2)
        }
        
        private func setUpLabels(_ button: UIButton) {
            nameLabel.font = .systemFont(ofSize: 15)
            valueLabel.font = .systemFont(ofSize: 15)
            nameLabel.textColor = UIColor.init(white: 80.0/255.0, alpha: 1)
            valueLabel.textColor = UIColor.init(white: 80.0/255.0, alpha: 1)
            
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
                stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
                trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: 32),
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
