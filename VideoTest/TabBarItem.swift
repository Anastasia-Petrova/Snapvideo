import UIKit

class TabBarItem: UITabBarItem {
    init(title: String) {
        super.init()
        self.title = title
        self.setTitleTextAttributes(
            [
                NSAttributedString.Key.font : UIFont.systemFont(ofSize: 12, weight: .semibold),
                NSAttributedString.Key.foregroundColor : UIColor.systemBlue
            ],
            for: .normal
        )
        self.titlePositionAdjustment = .init(horizontal: 0, vertical: -9)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
