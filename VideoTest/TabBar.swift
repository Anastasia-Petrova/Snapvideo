import Foundation
import UIKit

class TabBar: UITabBar {
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
    
    init(items: [String]) {
        let itemsArray = items.map { title in
            TabBarItem(title: title)
        }
        super.init(frame: .zero)
        self.setItems(itemsArray, animated: false)
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
