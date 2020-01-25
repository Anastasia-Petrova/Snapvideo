import UIKit
import AVKit
import Photos

class PlayerVideoViewController: UIViewController {
  var videoURL: URL!
  private var player: AVPlayer!
  private var playerLayer: AVPlayerLayer!
  
  @IBOutlet var saveVideoButton: UIButton!
  @IBOutlet var videoView: UIView!
  
  @IBAction func saveVideo(_ sender: Any) {
    PHPhotoLibrary.requestAuthorization { [weak self] status in
      switch status {
      case .authorized:
        self?.saveVideoToPhotos()
      default:
        print("Photos permissions not granted.")
        return
      }
    }
  }
  
  private func saveVideoToPhotos() {
    DispatchQueue.main.async {
      self.saveVideoButton.isEnabled = false
//      self.navigationItem.hidesBackButton = true
    }
    
    PHPhotoLibrary.shared().performChanges({ PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: self.videoURL)
    }) { [weak self] (isSaved, error) in
//      let title = isSaved ? "Success" : "Error"
//      let message = isSaved ? "Video was saved" : "Video failed to save"
//      let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
//      alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel, handler: { _ in
//        self?.navigationController?.popViewController(animated: true)
//      }))

      DispatchQueue.main.async {
        self?.navigationController?.popViewController(animated: true)
      }
    }
  }
  
  override func viewDidLoad() {
        super.viewDidLoad()
    player = AVPlayer(url: videoURL)
    playerLayer = AVPlayerLayer(player: player)
    playerLayer.bounds = videoView.bounds
    videoView.layer.addSublayer(playerLayer)
    player.play()
    NotificationCenter.default.addObserver(
      forName: .AVPlayerItemDidPlayToEndTime,
      object: nil,
      queue: nil) { [weak self] _ in self?.restart() }
    }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    playerLayer.frame = videoView.bounds
  }
  
  private func restart() {
    player.seek(to: .zero)
    player.play()
  }

  deinit {
    NotificationCenter.default.removeObserver(
      self,
      name: .AVPlayerItemDidPlayToEndTime,
      object: nil)
  }
}

