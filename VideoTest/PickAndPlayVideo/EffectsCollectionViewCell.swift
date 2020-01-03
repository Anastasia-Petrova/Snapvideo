import UIKit

class EffectsCollectionViewCell: UICollectionViewCell {
    let stackView = UIStackView()
    let previewImageView = UIImageView(image: UIImage(named: "placeholder")?.withRenderingMode(.alwaysTemplate))
    let effectName = UILabel()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        previewImageView.translatesAutoresizingMaskIntoConstraints = false
        effectName.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(stackView)
        stackView.addArrangedSubview(previewImageView)
        stackView.addArrangedSubview(effectName)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor)
        ])
        stackView.axis = .vertical
        stackView.spacing = 8
        effectName.text = "Effect name"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
