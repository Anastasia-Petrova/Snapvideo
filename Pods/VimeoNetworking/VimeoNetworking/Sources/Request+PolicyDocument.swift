//
//  Request+PolicyDocument.swift
//  VimeoNetworking
//
//  Created by Westendorf, Mike on 11/9/16.
//  Copyright © 2016 Vimeo. All rights reserved.
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

import Foundation

/// `Request` returning a single `VIMPolicyDocument`
public typealias PolicyDocumentRequest = Request<VIMPolicyDocument>

public extension Request {
    private static var TermsOfServiceURI: String { return "/documents/termsofservice" }
    private static var PrivacyURI: String { return "/documents/privacy" }
    
    /**
     Create a request to get the Terms of Service document
     
     - returns: a new `Request`
     */
    public static func getTermsOfServiceRequest() -> Request {
        return Request(path: TermsOfServiceURI)
    }

    /**
     Create a request to get the Privacy document
     
     - returns: a new `Request`
     */
    public static func getPrivacyRequest() -> Request {
        return Request(path: PrivacyURI)
    }
}
