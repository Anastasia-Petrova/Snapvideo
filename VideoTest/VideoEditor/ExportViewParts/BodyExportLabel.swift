import UIKit

final class BodyExportLabel: UILabel {
    init() {
        super.init(frame: .zero)
        self.font = .systemFont(ofSize: 10, weight: .medium)
        self.numberOfLines = 0
        self.textColor = .lightGray
        self.textAlignment = .left
//        self.setContentCompressionResistancePriority(.required, for: .vertical)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
