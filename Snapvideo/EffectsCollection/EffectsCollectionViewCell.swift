import UIKit

class EffectsCollectionViewCell: UICollectionViewCell {
    let stackView = UIStackView()
    let previewImageView = UIImageView(image: UIImage(named: "placeholder"))
    let effectName = UILabel()
    
    override var isSelected: Bool {
        didSet {
            if self.isSelected {
                effectName.textColor = .blue
            } else {
                effectName.textColor = .gray
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        previewImageView.image = UIImage(named: "placeholder")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(stackView)
        stackView.addArrangedSubview(previewImageView)
        stackView.addArrangedSubview(effectName)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            previewImageView.heightAnchor.constraint(equalTo: previewImageView.widthAnchor)
        ])
        stackView.alignment = .center
        stackView.axis = .vertical
        stackView.spacing = 6
        effectName.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        effectName.font = UIFont.systemFont(ofSize: 9)
        effectName.numberOfLines = 1
        previewImageView.contentMode = .scaleAspectFill
        previewImageView.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
