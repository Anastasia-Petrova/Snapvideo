import Foundation
import UIKit

class TabBar: UITabBar {
    init() {
        let item = UITabBarItem(title: "LOOKS", image: nil, selectedImage: nil)
        item.setTitleTextAttributes(
            [
                NSAttributedString.Key.font : UIFont.systemFont(ofSize: 12, weight: .semibold),
                NSAttributedString.Key.foregroundColor : UIColor.systemBlue
            ],
            for: .normal
        )
        item.titlePositionAdjustment = .init(horizontal: 0, vertical: -9)
        let item2 = UITabBarItem(title: "TOOLS", image: nil, selectedImage: nil)
        item2.setTitleTextAttributes(
            [
                NSAttributedString.Key.font : UIFont.systemFont(ofSize: 12, weight: .semibold),
                NSAttributedString.Key.foregroundColor : UIColor.systemBlue
            ],
            for: .normal
        )
        item2.titlePositionAdjustment = .init(horizontal: 0, vertical: -9)
        let item3 = UITabBarItem(title: "EXPORT", image: nil, selectedImage: nil)
        item3.setTitleTextAttributes(
            [
                NSAttributedString.Key.font : UIFont.systemFont(ofSize: 12, weight: .semibold),
                NSAttributedString.Key.foregroundColor : UIColor.systemBlue
            ],
            for: .normal
        )
        item3.titlePositionAdjustment = .init(horizontal: 0, vertical: -9)
        super.init(frame: .zero)
        self.setItems([item, item2, item3], animated: false)
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
