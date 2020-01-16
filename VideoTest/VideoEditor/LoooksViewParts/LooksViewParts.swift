import UIKit

class EffectsViewButton: UIButton {
    init(imageName: String) {
        super.init(frame: .zero)
        self.imageView?.contentMode = .scaleAspectFit
        self.setImage(UIImage(named: imageName)?.withRenderingMode(.alwaysTemplate), for: .normal)
        self.tintColor = .darkGray
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
