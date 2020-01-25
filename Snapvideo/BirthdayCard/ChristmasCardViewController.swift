import UIKit
import MobileCoreServices
import AVKit

class ChristmasCardViewController: UIViewController {
  private let editor = Editor()

  @IBOutlet var image: UIImageView!
  @IBOutlet var activityIndicator: UIActivityIndicatorView!
  @IBOutlet var nameTextField: UITextField!
  @IBOutlet var pickVideoButton: UIButton!
  @IBAction func pickVideo(_ sender: Any) {
    VideoHelper.startMediaBrowser(delegate: self, sourceType: .savedPhotosAlbum)
  }
  
  override func viewDidLoad() {
        super.viewDidLoad()
    activityIndicator.isHidden = true
    nameTextField.addTarget(self, action: #selector(nameTextFieldChanged), for: .editingChanged)
    nameTextField.delegate = self
    nameTextField.returnKeyType = .done
    pickVideoButton.isEnabled = false
    }
  
  @objc private func nameTextFieldChanged(_ textField: UITextField) {
    let text = textField.text ?? ""
    if text.isEmpty {
      pickVideoButton.isEnabled = false
    } else {
      pickVideoButton.isEnabled = true
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.setNavigationBarHidden(false, animated: animated)
  }
  
  private var pickedURL: URL?
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     guard
       let url = pickedURL,
       let destination = segue.destination as? PlayerVideoViewController
       else {
         return
     }
     
     destination.videoURL = url
   }
  
  private func showInProgress() {
    activityIndicator.isHidden = false
    activityIndicator.startAnimating()
    image.alpha = 0.3
    pickVideoButton.isEnabled = false
  }
  
  private func showCompleted() {
    activityIndicator.stopAnimating()
    activityIndicator.isHidden = true
    image.alpha = 1
    pickVideoButton.isEnabled = true
  }
  
}

extension ChristmasCardViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    guard
      let url = info[.mediaURL] as? URL,
      let name = nameTextField.text
      else {
        print("Cannot get video URL")
        return
    }
    showInProgress()
    dismiss(animated: true) {
      self.editor.makeBirthdayCard(fromVideoAt: url, forName: name) { exportedUrl in
        self.showCompleted()
        guard let exportedUrl = exportedUrl else {
          return
        }
        self.pickedURL = exportedUrl
        self.performSegue(withIdentifier: "showVideo", sender: nil)
      }
    }
  }
}

extension ChristmasCardViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
}
