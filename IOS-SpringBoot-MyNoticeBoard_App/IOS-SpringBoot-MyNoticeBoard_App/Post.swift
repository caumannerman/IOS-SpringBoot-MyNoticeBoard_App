//
//  Post.swift
//  IOS-SpringBoot-MyNoticeBoard_App
//
//  Created by 양준식 on 2022/04/14.
//

import Foundation

struct Post: Codable{
    let id: Int?
    let title, content, userNickName: String?
    let time: Date?
    let hashTag: [String]?

    enum CodingKeys: String, CodingKey {
        case id, title, content, time
        case userNickName = "user_nickname"
        case hashTag = "hashtag"
    }
    
}
