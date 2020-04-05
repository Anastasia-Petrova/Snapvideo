//
//  VIMReviewPage.swift
//  VimeoNetworking
//
//  Created by Lim, Jennifer on 3/19/18.
//

/// VIMReviewPage stores all information related to review a video
public class VIMReviewPage: VIMModelObject {
    /// Represents whether the review page is active for this video
    @objc dynamic public private(set) var isActive: NSNumber?
    
    /// Represents the review page link
    @objc dynamic public private(set) var link: String?
    
    public override func getObjectMapping() -> Any {
        return ["active" : "isActive"]
    }
}
