//
//  Comment.swift
//  IOS-SpringBoot-MyNoticeBoard_App
//
//  Created by 양준식 on 2022/04/21.
//

import Foundation


struct Comment: Codable{
    let id: Int?
    let content, userNickName: String?
    let time: String?
    
    let postId: Int?

    enum CodingKeys: String, CodingKey {
        case id, content, time, postId
        case userNickName = "user_nickname"
    }
    
}
