//
//  VideoEditor.swift
//  Snapvideo
//
//  Created by Anastasia Petrova on 02/02/2020.
//  Copyright © 2020 Anastasia Petrova. All rights reserved.
//

import Foundation
import AVFoundation
import Photos

struct VideoEditor {
  static func saveEditedVideo(filter: Filter, asset: AVAsset, completion: @escaping () -> Void) {
    exportSession(filter: filter, asset: asset)?
      .export { result in
        switch result {
        case let .success(url):
          self.saveToPhotoLibrary(url, completion: completion)
        case .failure:
          completion()
        }
    }
  }
  
  static func saveToPhotoLibrary(_ exportUrl: URL, completion: @escaping () -> Void) {
    PHPhotoLibrary.shared().performChanges({
      PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: exportUrl)
    }) { saved, error in
      let title: String
      let body: String
      if saved && error == nil {
        title = "Saved Successfully"
        body = "Tap to open"
      } else {
        title = "Couldn't save the video"
        body = "Please try again"
      }
      AppDelegate().scheduleNotification(title: title, body: body)
      completion()
    }
  }
  
  static func exportSession(
    filter: Filter,
    asset: AVAsset
  ) -> AVAssetExportSession? {
    guard let session = exportSession(asset: asset) else {
      return nil
    }
    session.videoComposition = setUpComposition(choosenFilter: filter, asset: asset)
    return session
  }
  
  static func trimSession(
    asset: AVAsset,
    startTime: Double,
    endTime: Double
  ) -> AVAssetExportSession? {
    guard let session = exportSession(asset: asset) else {
      return nil
    }
    session.timeRange = CMTimeRange(
      start: CMTime(seconds: startTime, preferredTimescale: 1000),
      end: CMTime(seconds: endTime, preferredTimescale: 1000)
    )
    return session
  }
  
  static var exportURL: URL {
    let exportPath = NSTemporaryDirectory().appendingFormat("/\(UUID().uuidString).mov")
    return URL(fileURLWithPath: exportPath)
  }
  
  static func exportSession(asset: AVAsset) -> AVAssetExportSession? {
    let session = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetHighestQuality)
    session?.outputFileType = AVFileType.mov
    session?.outputURL = exportURL
    return session
  }
  
  private static func setUpComposition(choosenFilter: Filter, asset: AVAsset ) -> AVVideoComposition {
    AVVideoComposition(asset: asset) { request in
      let filteredImage = choosenFilter.apply(image: request.sourceImage)
      request.finish(with: filteredImage, context: nil)
    }
  }
}

enum SpeedMode: Equatable {
  case slowDown(scale: Int64)
  case speedUp(scale: Int64)
}

extension AVAsset {
  func adjustedSpeed(mode: SpeedMode) -> AVMutableComposition? {
    guard let videoTrack = tracks(withMediaType: AVMediaType.video).first else {
      return nil
    }
    let mixComposition = AVMutableComposition()
    guard let compositionVideoTrack = mixComposition.addMutableTrack(withMediaType: AVMediaType.video, preferredTrackID: kCMPersistentTrackID_Invalid) else {
      return nil
    }
    
    let scaledVideoDuration = getScaledVideoDuration(mode: mode)
    let timeRange = CMTimeRangeMake(start: CMTime.zero, duration: duration)
   
    do {
      try compositionVideoTrack.insertTimeRange(timeRange, of: videoTrack, at: CMTime.zero)
      compositionVideoTrack.scaleTimeRange(timeRange, toDuration: scaledVideoDuration)
      compositionVideoTrack.preferredTransform = videoTrack.preferredTransform
    } catch let error {
      print(error.localizedDescription)
      return nil
    }
    
    if let audioTrack = tracks(withMediaType: AVMediaType.audio).first,
       let compositionAudioTrack = mixComposition.addMutableTrack(withMediaType: AVMediaType.audio, preferredTrackID: kCMPersistentTrackID_Invalid) {
        do {
          try compositionAudioTrack.insertTimeRange(timeRange, of: audioTrack, at: CMTime.zero)
          compositionAudioTrack.scaleTimeRange(timeRange, toDuration: scaledVideoDuration)
        } catch {
          print(error.localizedDescription)
          return nil
        }
    }
    
    return mixComposition
  }
  
  func getScaledVideoDuration(mode: SpeedMode) -> CMTime {
    let videoDuration: Int64
    switch mode {
    case let .slowDown(scale):
      videoDuration = duration.value * scale
    case let .speedUp(scale):
      videoDuration = duration.value / scale
    }
    return CMTimeMake(value: videoDuration, timescale: duration.timescale)
  }
}

extension AVAssetExportSession {
  enum `Error`: Swift.Error {
    case cancelled
    case failed(Swift.Error)
    case unknown
  }
  
  func export(completion: @escaping (Result<URL, Error>) -> Void) {
    exportAsynchronously { [weak self] in
      guard let self = self else {
        completion(.failure(.cancelled))
        return
      }
      
      switch (self.status, self.outputURL, self.error) {
      case let (.completed, .some(url), .none):
        completion(.success(url))
        
      case (.cancelled, _, _):
        completion(.failure(.cancelled))
        
      case let (.failed, _, .some(error)):
        completion(.failure(.failed(error)))
        
      default:
        completion(.failure(.unknown))
      }
    }
  }
}
