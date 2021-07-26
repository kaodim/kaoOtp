//
//  Review.swift
//  KaoDesign
//
//  Created by augustius cokroe on 13/04/2019.
//

import Foundation

public struct Review: BasicReview {
    public let id: Int?
    public var description: String?
    public let createdAt: String?
	public var createdAtStr: String
	public var rating: Int?
	public var comment: String
    public let serviceMatchId: Int?
	public var name: String
    public var avatarUrl: String?
    public var businessName: String?
    public let serviceTypeName: String?
    public let serviceAreaName: String?
	public var reviewTags: [SelectedReviewTag]
    public var canReply: Bool?
    public var reply: ReplyReview?
}

public extension Review {

	public enum CodingKeys: String, CodingKey {
		case id
		case description
		case createdAt = "created_at"
		case createdAtStr = "created_at_string"
		case rating
		case comment
		case serviceMatchId = "service_match_id"
		case name
		case avatarUrl = "avatar_url"
		case businessName = "business_profile_name"
		case serviceTypeName = "service_type_name"
		case serviceAreaName = "service_area_name"
		case reviewTags = "review_tags"
		case canReply = "can_reply"
		case reply
	}
}

public extension Review {

    init?(json: [String: Any]) {
        guard
            let id = json["id"] as? Int,
            let createdAt = json["created_at"] as? String,
            let rating = json["rating"] as? Int,
            let comment = json["comment"] as? String,
            let serviceMatchId = json["service_match_id"] as? Int,
            let name = json["name"] as? String,
            let serviceTypeName = json["service_type_name"] as? String,
            let serviceAreaName = json["service_area_name"] as? String
            else { return nil }

        self.id = id
        self.description = json["description"] as? String ?? ""
        self.createdAt = createdAt
        self.createdAtStr = json["created_at_string"] as? String ?? ""
        self.rating = rating
        self.comment = comment
        self.serviceMatchId = serviceMatchId
        self.name = name
        self.avatarUrl = json["avatar_url"] as? String ?? ""
        self.businessName = json["business_profile_name"] as? String ?? ""
        self.serviceTypeName = serviceTypeName
        self.serviceAreaName = serviceAreaName
        self.reviewTags = SelectedReviewTag.initList(json: json["review_tags"]) ?? []
        self.canReply = json["can_reply"] as? Bool
        if let replyPayload = json["reply"] as? [String : Any] {
            self.reply = ReplyReview(json: replyPayload)
        } else {
            self.reply = nil
        }
    }
}

public extension Review {
	static func initList(json: Any?) -> [Review]? {
        guard let arrayDictionary = json as? [[String: Any]] else { return nil }
        return arrayDictionary.compactMap({ Review(json: $0) })
    }
}

public extension Review {
	static func initEmpty() -> Review {
		return Review(id: nil, description: "", createdAt: "", createdAtStr: "", rating: nil, comment: "", serviceMatchId: nil, name: "", avatarUrl: "", businessName: nil, serviceTypeName: "", serviceAreaName: "", reviewTags: [], canReply: nil, reply: nil)
    }
}
