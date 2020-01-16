import UIKit

class SaveOptionsLabel: UILabel {
    init() {
        super.init(frame: .zero)
        self.font = .systemFont(ofSize: 22, weight: .medium)
        self.numberOfLines = 0
        self.textColor = .darkGray
        self.textAlignment = .left
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
