import UIKit
import AVKit
import MobileCoreServices

class HomeViewController: UIViewController {
    var addVideoButton = UIButton()
    
    let app = App.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setUpAddVideoButton()
    }
 
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.setNavigationBarHidden(true, animated: animated)
  }
    
    func setUpAddVideoButton() {
        addVideoButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(addVideoButton)
        NSLayoutConstraint.activate([
            addVideoButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            addVideoButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            addVideoButton.heightAnchor.constraint(equalToConstant: 100),
            addVideoButton.widthAnchor.constraint(equalToConstant: 100)
        ])
        addVideoButton.setImage(UIImage(named: "addButton"), for: .normal)
//            ?.withRenderingMode(.alwaysTemplate), for: .normal)
//        addVideoButton.tintColor = .white
        addVideoButton.addTarget(self, action: #selector(self.addVideo), for: .touchUpInside)
    }
    
    @objc func addVideo() {
        VideoHelper.startMediaBrowser(delegate: self, sourceType: .savedPhotosAlbum)
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
        let vc = VideoEditorViewController(url: url, filters: self.app.filters)
        self.present(vc, animated: true)
    }
  }
}

extension HomeViewController: UINavigationControllerDelegate {
  
}
