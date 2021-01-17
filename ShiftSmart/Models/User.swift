//
//  Guest.swift
//  ShiftSmart
//
//  Created by 大島友陽 on 2021/01/14.
//

import Foundation
import Firebase
import FirebaseFirestore

class User {
    
    let userName: String
    let email: String
    let createdAt: Timestamp
    let profileImageUrl: String
    let admin: Bool
    
    var uid: String?
    
    init(dic: [String: Any]) {
        self.userName = dic["userName"] as? String ?? ""
        self.email = dic["email"] as? String ?? ""
        self.profileImageUrl = dic["profileImageUrl"] as? String ?? ""
        self.createdAt = dic["createdAt"] as? Timestamp ?? Timestamp()
        self.admin = dic["admin"] as? Bool ?? false
    }
    
}

