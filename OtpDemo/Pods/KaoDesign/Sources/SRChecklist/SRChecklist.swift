//
//  SRChecklist.swift
//  KaoDesign
//
//  Created by Augustius on 16/12/2019.
//

import Foundation

public struct SRTask: Decodable {
    public let text: String
}

public extension SRTask {
    init?(json: [String: Any]) {
        guard let text = json["text"] as? String else { return nil }

        self.text = text
    }

    static func initList(json: Any?) -> [SRTask] {
        guard let arrayDictionary = json as? [[String: Any]] else {
            return []
        }
        return arrayDictionary.compactMap({ SRTask(json: $0) ?? nil })
    }
}

public struct SRChecklist: Decodable {
    public let id: Int
    public let title: String
    public let tasks: [SRTask]

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case tasks = "question_set_checklist_tasks"
    }
}

public extension SRChecklist {
    init?(json: [String: Any]) {
        guard
            let id = json["id"] as? Int,
            let title = json["title"] as? String
            else { return nil }

        self.id = id
        self.title = title
        self.tasks = SRTask.initList(json: json["question_set_checklist_tasks"])
    }

    static func initList(json: Any?) -> [SRChecklist] {
        guard let arrayDictionary = json as? [[String: Any]] else {
            return []
        }
        return arrayDictionary.compactMap({ SRChecklist(json: $0) ?? nil })
    }
}
