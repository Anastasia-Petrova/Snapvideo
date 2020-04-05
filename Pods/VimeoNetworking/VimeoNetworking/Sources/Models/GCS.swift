//
//  GCS.swift
//  Vimeo
//
//  Created by Nguyen, Van on 11/8/18.
//  Copyright © 2018 Vimeo. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

public class GCS: VIMModelObject {
    public enum Connection: String {
        case uploadAttempt = "upload_attempt"
    }
    
    @objc public private(set) var startByte: NSNumber?
    @objc public private(set) var endByte: NSNumber?
    @objc public private(set) var uploadLink: String?
    @objc internal private(set) var metadata: [String: Any]?
    
    public private(set) var connections = [Connection: VIMConnection]()
    
    override public func didFinishMapping() {
        guard let metadata = self.metadata, let connections = metadata["connections"] as? [String: Any] else {
            return
        }
        
        let uploadAttemptDict = connections[Connection.uploadAttempt.rawValue] as? [String: Any]
        let uploadAttemptConnection = VIMConnection(keyValueDictionary: uploadAttemptDict)
        
        self.connections[.uploadAttempt] = uploadAttemptConnection
    }
}
