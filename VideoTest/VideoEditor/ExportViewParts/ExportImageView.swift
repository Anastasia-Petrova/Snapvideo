import UIKit

class ExportImageView: UIImageView {
    init(imageName: String) {
        let image = UIImage(named: imageName)?.withRenderingMode(.alwaysTemplate)
        super.init(image: image)
        self.contentMode = .scaleAspectFit
        self.tintColor = .darkGray
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
