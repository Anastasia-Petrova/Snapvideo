import UIKit

class SaveCopyVideoButton: UIButton {
    override var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? UIColor.lightGray.withAlphaComponent(0.1) : UIColor.clear
        }
    }
}
