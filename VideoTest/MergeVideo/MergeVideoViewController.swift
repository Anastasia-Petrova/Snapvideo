import UIKit
import MobileCoreServices
import MediaPlayer
import Photos

class MergeVideoViewController: UIViewController {
  
  var firstAsset: AVAsset?
  var secondAsset: AVAsset?
  var audioAsset: AVAsset?
  var loadingAssetOne = false
  
  @IBOutlet var activityMonitor: UIActivityIndicatorView!
  
  func savedPhotosAvailable() -> Bool {
    guard !UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) else { return true }
    
    let alert = UIAlertController(title: "Not Available", message: "No Saved Album found", preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil))
    present(alert, animated: true, completion: nil)
    return false
  }
  
  func exportDidFinish(_ session: AVAssetExportSession) {
    
    activityMonitor.stopAnimating()
    firstAsset = nil
    secondAsset = nil
    audioAsset = nil
    
    guard
      session.status == AVAssetExportSession.Status.completed,
      let outputURL = session.outputURL
      else {
        return
    }
    
    let saveVideoToPhotos = {
      PHPhotoLibrary.shared().performChanges({
        PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: outputURL)
      }) { saved, error in
        let success = saved && (error == nil)
        let title = success ? "Success" : "Error"
        let message = success ? "Video saved" : "Failed to save video"
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
      }
    }
    
    if PHPhotoLibrary.authorizationStatus() != .authorized {
      PHPhotoLibrary.requestAuthorization { status in
        if status == .authorized {
          saveVideoToPhotos()
        }
      }
    } else {
      saveVideoToPhotos()
    }
  }
  
  @IBAction func loadAssetOne(_ sender: Any) {
    if savedPhotosAvailable() {
      loadingAssetOne = true
      VideoHelper.startMediaBrowser(delegate: self, sourceType: .savedPhotosAlbum)
    }
  }
  
  @IBAction func loadAssetTwo(_ sender: Any) {
    if savedPhotosAvailable() {
      loadingAssetOne = false
      VideoHelper.startMediaBrowser(delegate: self, sourceType: .savedPhotosAlbum)
    }
  }
  
  @IBAction func loadAudio(_ sender: Any) {
    let mediaPickerController = MPMediaPickerController(mediaTypes: .any)
    mediaPickerController.delegate = self
    mediaPickerController.prompt = "Select Audio"
    present(mediaPickerController, animated: true, completion: nil)
  }
  
  
  @IBAction func merge(_ sender: Any) {
    guard
      let firstAsset = firstAsset,
      let secondAsset = secondAsset
      else {
        return
    }

    activityMonitor.startAnimating()

    let mixComposition = AVMutableComposition()

    guard
      let firstTrack = mixComposition.addMutableTrack(withMediaType: AVMediaType.video,
                                                      preferredTrackID: Int32(kCMPersistentTrackID_Invalid))
      else {
        return
    }
    do {
      try firstTrack.insertTimeRange(CMTimeRangeMake(start: CMTime.zero, duration: firstAsset.duration),
                                     of: firstAsset.tracks(withMediaType: AVMediaType.video)[0],
                                     at: CMTime.zero)
    } catch {
//      print("Failed to load first track")
      return
    }

    guard
      let secondTrack = mixComposition.addMutableTrack(withMediaType: AVMediaType.video,
                                                       preferredTrackID: Int32(kCMPersistentTrackID_Invalid))
      else {
        return
    }
//    print("firstAsset.duration is \(firstAsset.duration)")
//    print("secondAsset duration is \(secondAsset.duration)")
    do {
      try secondTrack.insertTimeRange(CMTimeRangeMake(start: .zero, duration: secondAsset.duration),
                                      of: secondAsset.tracks(withMediaType: AVMediaType.video)[0],
                                      at: firstAsset.duration)
    } catch {
      print("Failed to load second track")
      return
    }

    let mainInstruction = AVMutableVideoCompositionInstruction()
    mainInstruction.timeRange = CMTimeRangeMake(start: .zero, duration: CMTimeAdd(firstAsset.duration, secondAsset.duration))
    let firstInstruction = VideoHelper.videoCompositionInstruction(firstTrack, asset: firstAsset)
    firstInstruction.setOpacity(0.0, at: firstAsset.duration)
    let secondInstruction = VideoHelper.videoCompositionInstruction(secondTrack, asset: secondAsset)
    mainInstruction.layerInstructions = [firstInstruction, secondInstruction]
    let mainComposition = AVMutableVideoComposition()
    mainComposition.instructions = [mainInstruction]
    mainComposition.frameDuration = CMTimeMake(value: 1, timescale: 30)
    mainComposition.renderSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
    
    if let loadedAudioAsset = audioAsset {
      let audioTrack = mixComposition.addMutableTrack(withMediaType: AVMediaType.audio, preferredTrackID: 0)
      do {
        try audioTrack?.insertTimeRange(CMTimeRangeMake(start: .zero,
                                                        duration: CMTimeAdd(firstAsset.duration,
                                                                  secondAsset.duration)),
                                        of: loadedAudioAsset.tracks(withMediaType: AVMediaType.audio)[0] ,
                                        at: CMTime.zero)
      } catch {
        print("Failed to load Audio track")
      }
    }

    guard let documentDirectory = FileManager.default.urls(for: .documentDirectory,
                                                           in: .userDomainMask).first else {
      return
    }
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .long
    dateFormatter.timeStyle = .short
    let date = dateFormatter.string(from: Date())
    let url = documentDirectory.appendingPathComponent("mergeVideo-\(date).mov")

    guard let exporter = AVAssetExportSession(asset: mixComposition,
                                              presetName: AVAssetExportPresetHighestQuality) else {
      return
    }
    exporter.outputURL = url
    exporter.outputFileType = AVFileType.mov
    exporter.shouldOptimizeForNetworkUse = true
    exporter.videoComposition = mainComposition

    exporter.exportAsynchronously() {
      DispatchQueue.main.async {
        self.exportDidFinish(exporter)
      }
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.setNavigationBarHidden(false, animated: animated)
  }
}

extension MergeVideoViewController: UIImagePickerControllerDelegate {
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    dismiss(animated: true, completion: nil)
    
    guard let mediaType = info[UIImagePickerController.InfoKey.mediaType] as? String,
      mediaType == (kUTTypeMovie as String),
      let url = info[UIImagePickerController.InfoKey.mediaURL] as? URL
      else { return }
    
    let avAsset = AVAsset(url: url)
    var message = ""
    if loadingAssetOne {
      message = "Video one loaded"
      firstAsset = avAsset
    } else {
      message = "Video two loaded"
      secondAsset = avAsset
    }
    let alert = UIAlertController(title: "Asset Loaded", message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil))
    present(alert, animated: true, completion: nil)
  }
  
}

extension MergeVideoViewController: UINavigationControllerDelegate {
  
}

extension MergeVideoViewController: MPMediaPickerControllerDelegate {
  func mediaPicker(_ mediaPicker: MPMediaPickerController, didPickMediaItems mediaItemCollection: MPMediaItemCollection) {
    dismiss(animated: true) {
      let selectedSong = mediaItemCollection.items
      guard let song = selectedSong.first else {
        return
      }
      
      let url = song.value(forProperty: MPMediaItemPropertyAssetURL) as? URL
      self.audioAsset = (url == nil) ? nil : AVAsset(url: url!)
      let title = (url == nil) ? "Asset Not Available" : "Asset Loaded"
      let message = (url == nil) ? "Audio Not Loaded" : "Audio Loaded"
      let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
      self.present(alert, animated: true, completion: nil)
    }
  }
  
  func mediaPickerDidCancel(_ mediaPicker: MPMediaPickerController) {
    dismiss(animated: true, completion: nil)
  }
}

