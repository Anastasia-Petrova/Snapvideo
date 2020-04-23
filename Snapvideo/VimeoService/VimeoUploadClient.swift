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
    
//    class func getUploadLinkRequestVimeo(size: Float) -> Request<VimeoUploadLinkResponseModel> {
//        return .init(method: <#T##VimeoClient.Method#>, path: <#T##String#>, parameters: <#T##Any?#>, modelKeyPath: <#T##String?#>, useCache: <#T##Bool#>, cacheResponse: <#T##Bool#>, retryPolicy: <#T##RetryPolicy?#>)
//    }
    
    class func getUploadLinkRequest(accessToken: String, size: Float) -> URLRequest {
        var request = URLRequest(url: URL(string: Endpoints.base)!)
        request.httpMethod = "POST"
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/vnd.vimeo.*+json;version=3.4", forHTTPHeaderField: "Accept")
        
//        let clientID = vimeoClient.configuration!.clientIdentifier
//        let clientSecret = vimeoClient.configuration!.clientSecret
        
//        let authString = "\(clientID):\(clientSecret)"
//        let authData = authString.data(using: String.Encoding.utf8)
//        let base64String = authData?.base64EncodedString(options: [])
//
//        if let base64String = base64String {
//            let headerValue = "Basic \(base64String)"
//            request.setValue(headerValue, forHTTPHeaderField: Constants.AuthorizationHeaderKey)
//        }
        let body = UploadBody(upload: .init(approach: "tus", size: "102400"))
        
        request.httpBody = try! JSONEncoder().encode(body)
//        """
//        {
//            "upload": {
//                "approach": "tus",
//                "size": "\(size)"
//            }
//        }
//        """.data(using: .utf8)!
        
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
                let json = try! JSONSerialization.jsonObject(with: data, options: .allowFragments)
                completion(.failure(error))
            }
        }
    }
    
    class func performGetUploadLinkRequest(
        accessToken: String,
        size: Float,
        completion: @escaping (Swift.Result<VimeoUploadLinkResponse, Error>) -> Void
    ) {
        let request = getUploadLinkRequest(accessToken: accessToken, size: size)
        let task = getUploadLinkTask(request: request, completion: completion)

        task.resume()
    }
    
    class func makeUploadRequest(uploadLink: String) -> URLRequest {
        var request = URLRequest(url: URL(string: uploadLink)!)
        request.httpMethod = "PATCH"
        
        
        
        request.addValue("application/offset+octet-stream", forHTTPHeaderField: "Content-Type")
        request.addValue("application/vnd.vimeo.*+json;version=3.4", forHTTPHeaderField: "Accept")
        return request
    }
    
}

struct UploadBody: Codable {
    struct Upload: Codable {
        let approach: String
        let size: String
    }
    
    let upload: Upload
}