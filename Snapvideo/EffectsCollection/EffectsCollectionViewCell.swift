import UIKit

class EffectsCollectionViewCell: UICollectionViewCell {
    let stackView = UIStackView()
    let previewImageView = UIImageView(image: UIImage(named: "placeholder"))
    let filterName = UILabel()
    
    override var isSelected: Bool {
        didSet {
            if self.isSelected {
                filterName.textColor = .blue
            } else {
                filterName.textColor = .gray
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
        stackView.addArrangedSubview(filterName)
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
        filterName.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        filterName.font = UIFont.systemFont(ofSize: 9)
        filterName.numberOfLines = 1
        previewImageView.contentMode = .scaleAspectFill
        previewImageView.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
