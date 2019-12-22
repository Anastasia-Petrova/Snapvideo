//
//  PlayVideoViewController.swift
//  VideoTest
//
//  Created by Anastasia Petrova on 19/12/2019.
//  Copyright © 2019 Anastasia Petrova. All rights reserved.
//

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
      let player = AVPlayer(url: url)
      let vcPlayer = AVPlayerViewController()
      vcPlayer.player = player
      self.present(vcPlayer, animated: true, completion: nil)
    }
  }
}

extension PlayVideoViewController: UINavigationControllerDelegate {
  
}
