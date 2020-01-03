import UIKit
import AVKit
import MobileCoreServices

class PlayVideoViewController: UIViewController {

  @IBAction func playVideo(_ sender: Any) {
    VideoHelper.startMediaBrowser(delegate: self, sourceType: .savedPhotosAlbum)
  }
  
  override func viewDidLoad() {
        super.viewDidLoad()

    }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.setNavigationBarHidden(false, animated: animated)
  }
}

extension PlayVideoViewController: UIImagePickerControllerDelegate {
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    guard let mediaType = info[UIImagePickerController.InfoKey.mediaType] as? String,
      mediaType == (kUTTypeMovie as String),
      let url = info[UIImagePickerController.InfoKey.mediaURL] as? URL else {
        return
    }
    dismiss(animated: true) {
        let vc = VideoEditorViewController(url: url)
        self.present(vc, animated: true)
//      let player = AVPlayer(url: url)
//      let vcPlayer = AVPlayerViewController()
//      vcPlayer.player = player
//      self.present(vcPlayer, animated: true, completion: nil)
    }
  }
}

extension PlayVideoViewController: UINavigationControllerDelegate {
  
}
