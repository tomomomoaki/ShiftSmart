//
//  Event.swift
//  ShiftSmart
//
//  Created by 大島友陽 on 2021/01/04.
//

import FirebaseFirestore

class Event {
    
    let memberName: String
    let startTime: String
    let finishTime: String
    let createdAt: Timestamp
    
    init(dic: [String: Any]) {
        self.memberName = dic["memberName"] as? String ?? ""
        self.startTime = dic["startTime"] as? String ?? ""
        self.finishTime = dic["finishTime"] as? String ?? ""
        self.createdAt = dic["createdAt"] as? Timestamp ?? Timestamp()
    }
    
}


