//
//  Groups.swift
//  ShiftSmart
//
//  Created by 大島友陽 on 2021/01/16.
//

import Foundation
import Firebase

class Group {
    
    let groupName: String
    let groupId: String
    let members: [String]
    let createdAt: Timestamp
    
    var documentId: String?
    
    init(dic: [String: Any]) {
        self.groupName = dic["groupName"] as? String ?? ""
        self.groupId = dic["groupId"] as? String ?? ""
        self.members = dic["members"] as? [String] ?? [String]()
        self.createdAt = dic["createdAt"] as? Timestamp ?? Timestamp()
    }
    
}
