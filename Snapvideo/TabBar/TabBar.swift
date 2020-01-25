import UIKit

final class TabBar: UITabBar {
    var previouslySelectedItem: UITabBarItem?
    
    override var selectedItem: UITabBarItem? {
        didSet {
            if previouslySelectedItem == selectedItem  {
                selectedItem = nil
                previouslySelectedItem = nil
            } else {
                previouslySelectedItem = selectedItem
            }
        }
    }
    
    init(items: String...) {
        super.init(frame: .zero)
        self.setItems(items.map(TabBarItem.init), animated: false)
        self.tintColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
