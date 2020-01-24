import UIKit
import AVKit
import MobileCoreServices

final class HomeViewController: UIViewController {
    var addVideoButton = UIButton()
    let app = App.shared
    let tabBar = TabBar(items: "LOOKS", "TOOLS", "EXPORT")
    var childViewController: UIViewController?
    var previouslySelectedIndex: Int?
    
    var isLooksButtonSelected: Bool = false {
        didSet {
            guard let childVC = childViewController as? VideoEditorViewController else { return }
            
            if isLooksButtonSelected {
                childVC.openEffects()
            } else {
                childVC.closeEffects()
            }
        }
    }
    
    var isExportButtonSelected: Bool = false {
        didSet {
            guard let childVC = childViewController as? VideoEditorViewController else { return }

            if isExportButtonSelected {
                childVC.openExportMenu()
            } else {
                childVC.closeExportMenu()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.delegate = self
        self.view.backgroundColor = .white
        self.navigationController?.navigationBar.barTintColor = .white
        self.navigationController?.hideHairline()
        setUpStackView()
        setUpAddVideoButton()
        setUpTabBar()
        setUpOpenButton()
        tabBar.isHidden = true
    }
    
    private func setUpTabBar() {
        tabBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tabBar)
        NSLayoutConstraint.activate([
            tabBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tabBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tabBar.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    func setUpOpenButton() {
        let openButton = UIBarButtonItem(title: "OPEN", style: .plain, target: self, action: #selector(handleAddVideoTap))
        openButton.setTitleTextAttributes([NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15, weight: .semibold), NSAttributedString.Key.foregroundColor : UIColor.gray], for: .normal)
        navigationItem.leftBarButtonItem = openButton
    }
    
    private func setUpStackView() {
        let imageView = UIImageView(image: UIImage(named: "addButton")?.withRenderingMode(.alwaysTemplate))
        imageView.tintColor = .lightGray
        
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.numberOfLines = 0
        label.text = "Tap anywhere to choose a video"
        label.textColor = .lightGray
        label.textAlignment = .center
        
        let stackView = UIStackView()
        stackView.alignment = .center
        stackView.axis = .vertical
        stackView.spacing = 32
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(label)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        NSLayoutConstraint.activate ([
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            view.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: 16),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setUpAddVideoButton() {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        NSLayoutConstraint.activate ([
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            button.topAnchor.constraint(equalTo: view.topAnchor),
            button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
        button.addTarget(self, action: #selector(self.handleAddVideoTap), for: .touchUpInside)
    }
    
    @objc private func handleAddVideoTap() {
         VideoBrowser.startMediaBrowser(delegate: self, sourceType: .savedPhotosAlbum)
    }
    
    private func embed(_ videoEditorVC: UIViewController) {
        self.childViewController = videoEditorVC
        videoEditorVC.view.translatesAutoresizingMaskIntoConstraints = false
        addChild(videoEditorVC)
        view.insertSubview(videoEditorVC.view, belowSubview: tabBar)
        NSLayoutConstraint.activate([
            videoEditorVC.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            videoEditorVC.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            videoEditorVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            videoEditorVC.view.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        videoEditorVC.didMove(toParent: self)
        videoEditorVC.view.isHidden = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            videoEditorVC.view.isHidden = false
            self.tabBar.isHidden = false
        }
    }
    
    func removeEmbeddedViewController() {
        guard let childVC = childViewController else { return }
        childVC.removeFromParent()
        childVC.view.removeFromSuperview()
        if previouslySelectedIndex != nil {
            tabBar.selectedItem = nil
            tabBar.previouslySelectedItem = nil
            previouslySelectedIndex = nil
        }
    }
}

extension HomeViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let mediaType = info[UIImagePickerController.InfoKey.mediaType] as? String,
            mediaType == (kUTTypeMovie as String),
            let url = info[UIImagePickerController.InfoKey.mediaURL] as? URL else {
                return
        }
        dismiss(animated: true) {
            self.removeEmbeddedViewController()
            self.embed(VideoEditorViewController(url: url, filters: self.app.filters, presentedFilter: { [weak self] pressedFilter in
                self?.tabBar.isHidden = pressedFilter
//                self?.tabBar.selectedItem = nil
//                self?.tabBar.previouslySelectedItem = nil
//                self?.previouslySelectedIndex = nil
            }))
        }
    }
}

extension HomeViewController: UINavigationControllerDelegate {}

extension HomeViewController: UITabBarDelegate {
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        guard let selectedIndex = tabBar.items?.firstIndex(of: item) else { return }
        
        isLooksButtonSelected = selectedIndex == 0 && previouslySelectedIndex != selectedIndex
        
        isExportButtonSelected = selectedIndex == 2 && previouslySelectedIndex != selectedIndex
        
        if previouslySelectedIndex == selectedIndex {
            previouslySelectedIndex = nil
        } else {
            previouslySelectedIndex = selectedIndex
        }
    }
}

extension UINavigationController {
    func hideHairline() {
        if let hairline = findHairlineImageViewUnder(navigationBar) {
            hairline.isHidden = true
        }
    }

    func findHairlineImageViewUnder(_ view: UIView) -> UIImageView? {
        if view is UIImageView && view.bounds.size.height <= 1.0 {
            return view as? UIImageView
        }
        for subview in view.subviews {
            if let imageView = self.findHairlineImageViewUnder(subview) {
                return imageView
            }
        }
        return nil
    }
}
