//
//  VimeoUploadClient.swift
//  Snapvideo
//
//  Created by Anastasia Petrova on 23/04/2020.
//  Copyright © 2020 Anastasia Petrova. All rights reserved.
//

import Foundation
import VimeoNetworking

final class VimeoUploadClient {
    enum Endpoints {
        static let base = "https://api.vimeo.com/me/videos"
    }
    
    enum NetworkError: LocalizedError {
        case noData
        case wrongAPIResponse
        
        var errorDescription: String? {
            switch self {
            case .noData, .wrongAPIResponse: return "Something went wrong. Try again later."
            }
        }
    }
    
    class func getUploadLinkRequest(accessToken: String, size: Int) -> URLRequest {
        var request = URLRequest(url: URL(string: Endpoints.base)!)
        request.httpMethod = "POST"
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/vnd.vimeo.*+json;version=3.4", forHTTPHeaderField: "Accept")
        let body = UploadBody(name: "Hello!", upload: .init(approach: "tus", size: "\(size)"))
        request.httpBody = try! JSONEncoder().encode(body)
        return request
    }
    
    class func getUploadLinkTask(
        session: URLSession = .shared,
        request: URLRequest,
        completion: @escaping (Swift.Result<VimeoUploadLinkResponse, Error>) -> Void) -> URLSessionDataTask {
        return session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let _ = response as? HTTPURLResponse, let data = data else {
                completion(.failure(NetworkError.wrongAPIResponse))
                return
            }
            do {
                
                let uploadResponse = try JSONDecoder().decode(VimeoUploadLinkResponse.self, from: data)
                completion(.success(uploadResponse))
            } catch {
//                let json = try! JSONSerialization.jsonObject(with: data, options: .allowFragments)
                completion(.failure(error))
            }
        }
    }
    
    class func performGetUploadLinkRequest(
        accessToken: String,
        size: Int,
        completion: @escaping (Swift.Result<VimeoUploadLinkResponse, Error>) -> Void
    ) {
        let request = getUploadLinkRequest(accessToken: accessToken, size: size)
        let task = getUploadLinkTask(request: request, completion: completion)

        task.resume()
    }
    
    class func getUploadRequest(uploadLink: String, uploadOffset: Int) -> URLRequest {
        var request = URLRequest(url: URL(string: uploadLink)!)
        request.httpMethod = "PATCH"
        request.addValue("1.0.0", forHTTPHeaderField: "Tus-Resumable")
//TODO: 0 for the initial request; the stated upload offset for subsequent requests???
        request.addValue("\(uploadOffset)", forHTTPHeaderField: "Upload-Offset")
        request.addValue("application/offset+octet-stream", forHTTPHeaderField: "Content-Type")
        request.addValue("application/vnd.vimeo.*+json;version=3.4", forHTTPHeaderField: "Accept")
        return request
    }
    
    class func getUploadTask(
        session: URLSession = .shared,
        request: URLRequest,
        videoData: Data,
        completion: @escaping (Swift.Result<HTTPURLResponse, Error>) -> Void
    ) -> URLSessionDataTask {
        return session.uploadTask(with: request, from: videoData) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let response = response as? HTTPURLResponse, let data = data else {
                completion(.failure(NetworkError.wrongAPIResponse))
                return
            }
            do {
//                let uploadResponse = try JSONDecoder().decode(VimeoUploadResponse.self, from: data)
                completion(.success(response))
            } catch {
                let json = try! JSONSerialization.jsonObject(with: data, options: .allowFragments)
                completion(.failure(error))
            }
            
        }
    }
    
    class func performUploadRequest(
        uploadLink: String,
        uploadOffset: Int = 0,
        videoData: Data,
        completion: @escaping (Swift.Result<HTTPURLResponse, Error>) -> Void
    ) {
        let request = getUploadRequest(uploadLink: uploadLink, uploadOffset: uploadOffset)
        let task = getUploadTask(request: request, videoData: videoData, completion: completion)
        task.resume()
    }
    
    
    class func getHeadUploadRequest(uploadLink: String) -> URLRequest {
        var request = URLRequest(url: URL(string: uploadLink)!)
        request.httpMethod = "HEAD"
        request.addValue("1.0.0", forHTTPHeaderField: "Tus-Resumable")
        request.addValue("application/vnd.vimeo.*+json;version=3.4", forHTTPHeaderField: "Accept")
        return request
    }
    
    class func getHeadUploadTask(
        session: URLSession = .shared,
        request: URLRequest,
        completion: @escaping (Swift.Result<HTTPURLResponse, Error>) -> Void
    ) -> URLSessionDataTask {
        return session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let response = response as? HTTPURLResponse, let data = data else {
                completion(.failure(NetworkError.wrongAPIResponse))
                return
            }
            do {
                completion(.success(response))
            } catch {
                //                let json = try! JSONSerialization.jsonObject(with: data, options: .allowFragments)
                completion(.failure(error))
            }
        }
    }
    
    class func performHeadUploadRequest(
        uploadLink: String,
        completion: @escaping (Swift.Result<HTTPURLResponse, Error>) -> Void
    ) {
        let request = getHeadUploadRequest(uploadLink: uploadLink)
        let task = getHeadUploadTask(request: request, completion: completion)
        task.resume()
    }
}

struct UploadBody: Codable {
    struct Upload: Codable {
        let approach: String
        let size: String
    }
    let name: String
    let upload: Upload
}
