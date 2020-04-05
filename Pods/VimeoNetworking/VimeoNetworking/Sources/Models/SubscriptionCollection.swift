//
//  SubscriptionCollection.swift
//  Pods
//
//  Created by Lim, Jennifer on 1/20/17.
//  Copyright (c) 2014-2018 Vimeo (https://vimeo.com)
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

/// Represents all the subscriptions with extra informations
public class SubscriptionCollection: VIMModelObject {
    // MARK: - Properties

    /// Represents the uri
    @objc dynamic public private(set) var uri: String?
    
    /// Represents the subscription
    @objc dynamic public private(set) var subscription: Subscription?
    
    /// Represents the migration that indicates whether the user has migrated from the old system `VIMTrigger` to new new system `Localytics`.
    @objc dynamic public private(set) var migrated: NSNumber?
    
    // MARK: - VIMMappable
    
    public override func getObjectMapping() -> Any {
        return ["subscriptions": "subscription"]
    }
    
    public override func getClassForObjectKey(_ key: String!) -> AnyClass? {
        if key == "subscriptions" {
            return Subscription.self
        }
        
        return nil
    }
}
