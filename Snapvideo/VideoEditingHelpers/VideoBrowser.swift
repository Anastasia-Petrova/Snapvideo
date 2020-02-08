//
//  VideoBrowser.swift
//  Snapvideo
//
//  Created by Anastasia Petrova on 02/02/2020.
//  Copyright © 2020 Anastasia Petrova. All rights reserved.
//

import AVFoundation
import MobileCoreServices
import UIKit

enum VideoBrowser {
  static func startMediaBrowser(delegate: UIViewController & UINavigationControllerDelegate & UIImagePickerControllerDelegate, sourceType: UIImagePickerController.SourceType) {
    guard UIImagePickerController.isSourceTypeAvailable(sourceType) else {
      return
    }
    let mediaUI = UIImagePickerController()
    mediaUI.sourceType = sourceType
    mediaUI.mediaTypes = [kUTTypeMovie as String]
    mediaUI.allowsEditing = true
    mediaUI.delegate = delegate
    delegate.present(mediaUI, animated: true, completion: nil)
  }
}
