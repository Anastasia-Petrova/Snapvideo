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
    enum HTTPMethod {
        static let POST = "POST"
        static let PATCH = "PATCH"
        static let HEAD = "HEAD"
    }
    enum Header {
        enum Key {
            static let auth = "Authorization"
            static let contentType = "Content-Type"
            static let accept = "Accept"
            static let uploadOffset = "Upload-Offset"
            static let tusResumable = "Tus-Resumable"
        }
        enum Value {
            static func auth(_ token: String) -> String { "Bearer \(token)"}
            static let contentJSON = "application/json"
            static let contentVimeoJSON = "application/vnd.vimeo.*+json;version=3.4"
            static let contentStream = "application/offset+octet-stream"
            static let tusVersion = "1.0.0"
        }
    }
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
        request.httpMethod = HTTPMethod.POST
        request.setValue(Header.Value.auth(accessToken), forHTTPHeaderField: Header.Key.auth)
        request.addValue(Header.Value.contentJSON, forHTTPHeaderField: Header.Key.contentType)
        request.addValue(Header.Value.contentVimeoJSON, forHTTPHeaderField: Header.Key.accept)
        let body = UploadBody(upload: .init(approach: "tus", size: "\(size)"))
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
        request.httpMethod = HTTPMethod.PATCH
        request.addValue(Header.Value.tusVersion, forHTTPHeaderField: Header.Key.tusResumable)
        request.addValue("\(uploadOffset)", forHTTPHeaderField: Header.Key.uploadOffset)
        request.addValue(Header.Value.contentStream, forHTTPHeaderField: Header.Key.contentType)
        request.addValue(Header.Value.contentVimeoJSON, forHTTPHeaderField: Header.Key.accept)
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
            guard let response = response as? HTTPURLResponse,  data != nil else {
                completion(.failure(NetworkError.wrongAPIResponse))
                return
            }
                completion(.success(response))
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
        request.addValue(Header.Value.tusVersion, forHTTPHeaderField: Header.Key.tusResumable)
        request.addValue(Header.Value.contentVimeoJSON, forHTTPHeaderField: Header.Key.accept)
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
            guard let response = response as? HTTPURLResponse, data != nil else {
                completion(.failure(NetworkError.wrongAPIResponse))
                return
            }
            completion(.success(response))
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
    let upload: Upload
}
