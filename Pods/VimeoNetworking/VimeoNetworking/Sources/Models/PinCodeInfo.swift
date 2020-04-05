//
//  PinCodeInfo.swift
//  VimeoNetworking
//
//  Created by Huebner, Rob on 5/9/16.
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

public class PinCodeInfo: VIMModelObject {
    @objc dynamic public private(set) var deviceCode: String?
    @objc dynamic public private(set) var userCode: String?
    @objc dynamic public private(set) var authorizeLink: String?
    @objc dynamic public private(set) var activateLink: String?
    
    // TODO: These are non-optional Ints with -1 invalid sentinel values because
    // an optional Int can't be represented in Objective-C and can't be marked
    // dynamic, which leads to it not getting parsed by VIMObjectMapper [RH]
    @objc dynamic public private(set) var expiresIn: Int = -1
    @objc dynamic public private(set) var interval: Int = -1
}
