//
//  VideoDataSource.swift
//  Snapvideo
//
//  Created by Anastasia Petrova on 18/04/2020.
//  Copyright © 2020 Anastasia Petrova. All rights reserved.
//

import Foundation
import UIKit
import VimeoNetworking

final class VideoDataSource: NSObject {
    let cellIndentifier = "VideoCell"
    let collectionView: UICollectionView
    
    init(collectionView: UICollectionView) {
        self.collectionView = collectionView
        super.init()
        collectionView.dataSource = self
        collectionView.register(VideoCell.self, forCellWithReuseIdentifier: cellIndentifier)
    }
    
    var videos: [VIMVideo] = [] {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    var images: [VIMVideo: UIImage] = [:] {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    func fetchVideos() {
        let requestMyVideo = Request<[VIMVideo]>(path: "me/videos")
        _ = vimeoClient.request(requestMyVideo) { [weak self] result in
            switch result {
            case let .success(response):
                self?.videos = response.model
            case let .failure(error):
                print("error retrieving video: \(error)")
            }
        }
    }
}

extension VideoDataSource: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return videos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIndentifier, for: indexPath) as! VideoCell
        let video = videos[indexPath.item]
        cell.imageView.image = images[video]
        
        return cell
    }
}
