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
        collectionView.register(VimeoCollectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "VimeoCollectionHeader")
        collectionView.register(VideoCell.self, forCellWithReuseIdentifier: cellIndentifier)
    }
    
    var videos: [VIMVideo] = [] {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    var images: [URL: UIImage] = [:] {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    func fetchVideos() {
        let requestMyVideo = Request<[VIMVideo]>(path: "me/videos", useCache: false)
        
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
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        collectionView.backgroundView?.isHidden = !videos.isEmpty
        return videos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "VimeoCollectionHeader", for: indexPath) as! VimeoCollectionHeader
            headerView.callback = {
                guard let token = vimeoClient.currentAccount?.accessToken else {
                    print("NO TOKEN!!!!")
                    return
                }
                VimeoUploadClient.performGetUploadLinkRequest(accessToken: token, size: 1024 * 10) { response in
                    print(response)
                }
            }
            return headerView
            
        default:  fatalError("Unexpected element kind")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIndentifier, for: indexPath) as! VideoCell
        let video = videos[indexPath.item]
        
        guard let urlString = video.pictureCollection?.picture(forWidth: 300)?.link,
            let url = URL(string: urlString) else {
            return cell
        }
        
        let cellImage: UIImage
        if let image = images[url] {
            cellImage = image
        } else {
            cellImage = UIImage(named: "placeholder")!.withRenderingMode(.alwaysTemplate)
            loadRemoteImage(url, indexPath: indexPath)
        }
        
        cell.imageView.image = cellImage
        return cell
    }
}

extension VideoDataSource {
    enum Error: Swift.Error {
        case badData
        case noData
        case taskError
    }
    
    func loadRemoteImage(_ url: URL, indexPath: IndexPath) {
        loadImage(url: url) { result in
            DispatchQueue.main.async {
                switch result {
                case let .success(image):
                    self.images[url] = image
                case .failure(let error):
                    print(error.localizedDescription)
                    break
                }
                self.collectionView.reloadData()
            }
        }
    }
    
    private func loadImage(url: URL, completion: @escaping (Swift.Result<UIImage, Error>) -> Void) {
        let loadRequest = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: loadRequest) { (data, response, error) in
            if error != nil {
                DispatchQueue.main.async {
                    completion(.failure(Error.taskError))
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(Error.noData))
                }
                return
            }
            
            let image = UIImage(data: data)
            
            DispatchQueue.main.async {
                if let image = image {
                    completion(.success(image))
                } else {
                    completion(.failure(Error.badData))
                }
            }
        }
        task.resume()
    }
}
