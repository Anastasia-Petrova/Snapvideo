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
  static func setUpComposition(choosenFilter: Filter, asset: AVAsset ) -> AVVideoComposition {
    return AVVideoComposition(asset: asset) { request in
      let filteredImage = choosenFilter.apply(image: request.sourceImage)
      request.finish(with: filteredImage, context: nil)
    }
  }
  
  static func saveEditedVideo(choosenFilter: Filter, asset: AVAsset, completion: @escaping () -> Void) {
    let composition = setUpComposition(choosenFilter: choosenFilter, asset: asset)
    performExport(asset: asset, composition: composition) { exportUrl in
      guard let exportUrl = exportUrl else {
        completion()
        return
      }
      saveToPhotoLibrary(exportUrl, completion: completion)
    }
  }
  
  static func saveToPhotoLibrary(_ exportUrl: URL, completion: @escaping () -> Void) {
    PHPhotoLibrary.shared().performChanges({
      PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: exportUrl)
    }) { saved, error in
      let title: String
      let body: String
      if saved && error == nil {
        title = "Success!"
        body = "Video was saved."
      } else {
        title = "Error!"
        body = "Video was not saved. Try again."
      }
      AppDelegate().scheduleNotification(title: title, body: body)
      completion()
    }
  }
  
  static func composeVideo(choosenFilter: Filter, asset: AVAsset, completion: @escaping (URL?) -> Void ) {
    let composition = setUpComposition(choosenFilter: choosenFilter, asset: asset)
    performExport(asset: asset, composition: composition) { exportPath in
      completion(exportPath)
    }
  }
  
  static func performExport(
    asset: AVAsset,
    composition: AVVideoComposition,
    completion: @escaping (URL?) -> Void
  ) {
    guard let export = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetHighestQuality) else {
      completion(nil)
      return
    }
    export.outputFileType = AVFileType.mov
    let exportUrl = getExportURL()
    export.outputURL = exportUrl
    export.videoComposition = composition
    export.exportAsynchronously {
      completion(exportUrl)
    }
  }
  
  static func getVideoSize(url: URL) -> Int {
    guard let data = try? Data(contentsOf: url) else {
      return 0
    }
    return data.count
  }
  
  static func setUpMutableComposition(
    asset: AVAsset,
    mode: SpeedMode
  ) -> AVMutableComposition? {
    let scaledVideoDuration = getScaledVideoDuration(asset: asset, mode: mode)
    let timeRange = CMTimeRangeMake(start: CMTime.zero, duration: asset.duration)
    guard let videoTrack = asset.tracks(withMediaType: AVMediaType.video).first else {
      return nil
    }
    
    let mixComposition = AVMutableComposition()
    let compositionVideoTrack = mixComposition.addMutableTrack(withMediaType: AVMediaType.video, preferredTrackID: kCMPersistentTrackID_Invalid)
    let audioTracks = asset.tracks(withMediaType: AVMediaType.audio)
    
    if let audioTrack = audioTracks.first {
      let compositionAudioTrack = mixComposition.addMutableTrack(withMediaType: AVMediaType.audio, preferredTrackID: kCMPersistentTrackID_Invalid)
      do {
        try compositionAudioTrack?.insertTimeRange(timeRange, of: audioTrack, at: CMTime.zero)
        compositionAudioTrack?.scaleTimeRange(timeRange, toDuration: scaledVideoDuration)
      } catch {
        print(error.localizedDescription)
        return nil
      }
    }
    
    do {
      try compositionVideoTrack?.insertTimeRange(timeRange, of: videoTrack, at: CMTime.zero)
      compositionVideoTrack?.scaleTimeRange(timeRange, toDuration: scaledVideoDuration)
      compositionVideoTrack?.preferredTransform = videoTrack.preferredTransform
    } catch let error {
      print(error.localizedDescription)
      return nil
    }
    return mixComposition
  }
  
  static func getScaledVideoDuration(asset: AVAsset, mode: SpeedMode) -> CMTime {
    let videoDuration: Int64
    switch mode {
    case let .slowDown(scale):
      videoDuration = asset.duration.value * scale
    case let .speedUp(scale):
      videoDuration = asset.duration.value / scale
    }
    return CMTimeMake(value: videoDuration, timescale: asset.duration.timescale)
  }
  
  static func performExportWithMutableComposition(
    asset: AVAsset,
    composition: AVMutableComposition,
    completion: @escaping (URL?) -> Void
  ) {
    guard let export = AVAssetExportSession(asset: composition, presetName: AVAssetExportPresetHighestQuality) else {
      completion(nil)
      return
    }
    export.outputFileType = AVFileType.mov
    let exportUrl = getExportURL()
    export.outputURL = exportUrl
    export.exportAsynchronously {
      completion(exportUrl)
    }
  }
  
  static func trimVideo(
    asset: AVAsset,
    startTime: Double,
    endTime: Double,
    completion: @escaping (URL?) -> Void
  ) {
    guard let export = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetHighestQuality) else {
      completion(nil)
      return
    }
    let start = CMTime(seconds: startTime, preferredTimescale: 1000)
    let end = CMTime(seconds: endTime, preferredTimescale: 1000)
    export.outputFileType = AVFileType.mov
    let exportUrl = getExportURL()
    export.outputURL = exportUrl
    export.timeRange = CMTimeRange(start: start, end: end)
    export.exportAsynchronously {
      completion(exportUrl)
    }
  }
  
  static func getExportURL() -> URL {
    let exportPath = NSTemporaryDirectory().appendingFormat("/\(UUID().uuidString).mov")
    return URL(fileURLWithPath: exportPath)
  }
}

enum SpeedMode {
  case slowDown(scale: Int64)
  case speedUp(scale: Int64)
}
