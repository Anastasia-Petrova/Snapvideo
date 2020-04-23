//
//  VimeoUploadClient.swift
//  Snapvideo
//
//  Created by Anastasia Petrova on 23/04/2020.
//  Copyright © 2020 Anastasia Petrova. All rights reserved.
//

import Foundation

final class VimeoUploadClient {
    enum Endpoints {
        static let base = "https://api.vimeo.com/me/videos"
    }
    
    class func getUploadLinkRequest(accessToken: String, size: Float) -> URLRequest {
        var request = URLRequest(url: URL(string: Endpoints.base)!)
        request.httpMethod = "POST"
        request.addValue("bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/vnd.vimeo.*+json;version=3.4", forHTTPHeaderField: "Accept")
        
        request.httpBody =
        """
        {
            "upload": {
                "approach": "tus",
                "size": "\(size)"
            }
        }
        """.data(using: .utf8)!
        
        return request
    }
    
    class func getUploadLinkTask(
        session: URLSession = .shared,
        request: URLRequest,
        completion: @escaping (Bool) -> Void) -> URLSessionDataTask {
        return session.dataTask(with: request) { data, response, error in
            if let error = error {
                print("ERROR: \(error)")
                completion(false)
                return
            }
            guard let data = data else {
                completion(true)
                return
            }
            print("data: \(data)")
        }
    }
    
    class func performGetUploadLinkRequest(
        accessToken: String,
        size: Float,
        completion: @escaping (Bool) -> Void
    ) {
        let request = getUploadLinkRequest(accessToken: accessToken, size: size)
        let task = getUploadLinkTask(request: request, completion: completion)

        task.resume()
    }
}
