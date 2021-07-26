//
//  STReview.swift
//  KaoDesign
//
//  Created by Kelvin Tan on 10/30/19.
//

import Foundation

public protocol BasicReview: Decodable {
	var avatarUrl: String? { get set }
	var rating: Int? { get set }
	var comment: String { get set }
	var name: String { get set }
	var reviewTags: [SelectedReviewTag] { get set }
	var createdAtStr: String { get set }
	var description: String? { get set }
	var canReply: Bool? { get set }
	var reply: ReplyReview? { get set }
	var businessName: String? { get set }
}

public struct STReview: BasicReview {
    public var description: String?
    public var avatarUrl: String?
	public var rating: Int?
	public var comment: String
	public var name: String
	public var reviewTags: [SelectedReviewTag]
	public var createdAtStr: String
    public var canReply: Bool?
    public var reply: ReplyReview?
    public var businessName: String?

	public enum CodingKeys: String, CodingKey {
		case description
		case avatarUrl = "avatar_url"
		case rating
		case comment
		case name = "created_at"
		case reviewTags = "review_tags"
		case createdAtStr = "created_at_string"
		case canReply = "can_reply"
		case reply
		case businessName = "business_profile_name"
	}
}
