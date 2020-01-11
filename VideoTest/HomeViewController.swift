import UIKit
import AVKit
import MobileCoreServices

class HomeViewController: UIViewController {
    var addVideoButton = UIButton()
    let app = App.shared
    let tabBar = TabBar(items: ["FILTERS", "TOOLS", "EXPORT"])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setUpView()
        view.addSubview(tabBar)
        NSLayoutConstraint.activate([
            tabBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tabBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tabBar.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    func setUpView() {
        let stackView = UIStackView()
        self.view.addSubview(stackView)
        let imageView = UIImageView(image: UIImage(named: "addButton"))
        let label = UILabel()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(label)
        
        NSLayoutConstraint.activate ([
            stackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        ])
        
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.axis = .vertical
        stackView.spacing = 16
        label.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        label.font = UIFont.systemFont(ofSize: 20)
        label.numberOfLines = 1
        label.text = "Tap to choose a video"
        label.textColor = .black
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        stackView.addGestureRecognizer(tap)
    }
    
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
         VideoHelper.startMediaBrowser(delegate: self, sourceType: .savedPhotosAlbum)
    }
    
    func embed(_ videoEditorVC: UIViewController) {
        videoEditorVC.view.translatesAutoresizingMaskIntoConstraints = false
        addChild(videoEditorVC)
        view.addSubview(videoEditorVC.view)
        NSLayoutConstraint.activate([
            videoEditorVC.view.topAnchor.constraint(equalTo: view.topAnchor),
            videoEditorVC.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            videoEditorVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            videoEditorVC.view.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        videoEditorVC.didMove(toParent: self)
        videoEditorVC.view.isHidden = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            videoEditorVC.view.isHidden = false
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
            self.embed(VideoEditorViewController(url: url, filters: self.app.filters))
        }
    }
}

extension HomeViewController: UINavigationControllerDelegate {
    
}
