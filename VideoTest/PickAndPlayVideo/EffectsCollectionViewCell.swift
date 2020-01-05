import UIKit

class EffectsCollectionViewCell: UICollectionViewCell {
    let stackView = UIStackView()
    let previewImageView = UIImageView(image: UIImage(named: "placeholder"))
    let effectName = UILabel()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(stackView)
        stackView.addArrangedSubview(previewImageView)
        stackView.addArrangedSubview(effectName)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor)
        ])
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.axis = .vertical
        stackView.spacing = 8
        effectName.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        effectName.text = "WOW Effect"
        effectName.font = UIFont.systemFont(ofSize: 10)
        effectName.numberOfLines = 1
        effectName.textColor = .green
        previewImageView.contentMode = .scaleAspectFill
        previewImageView.clipsToBounds = true
        }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
