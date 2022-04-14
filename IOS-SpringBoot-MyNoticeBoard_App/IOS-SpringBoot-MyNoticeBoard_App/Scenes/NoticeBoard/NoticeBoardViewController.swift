//
//  PostsViewController.swift
//  IOS-SpringBoot-MyNoticeBoard_App
//
//  Created by 양준식 on 2022/04/14.
//

import UIKit
import SnapKit

class NoticeBoardViewController: UITableViewController {
    private var posts: [Post] = [Post(id: 1, title: "제 첫 게시글 입니다.", content: "첫 번쨰 dummy게시글입니다.", userNickName: "nickname1", time: "12:31", hashTag: ["첫게시물","첫 게시","선팔"]),
                                 Post(id: 2, title: "제 두번째 게시글 입니다.", content: "두 번쨰 dummy게시글입니다.", userNickName: "nickname2", time: "21:07", hashTag: ["두번째 게시물","첫 게시","선팔"]),
                                 Post(id: 3, title: "제 첫 게시글 입니다.", content: "세 번쨰 dummy게시글입니다.", userNickName: "nickname3", time: "15:14", hashTag: ["세 번째 게시물","3 게시","333","3"]),
                                 Post(id: 4, title: "제 첫 게시글 입니다.", content: "네 번쨰 dummy게시글입니다.", userNickName: "nickname4", time: "11:16", hashTag: ["네번째 게시물","4 게시","four"]),
                                 Post(id: 5, title: "제 첫 게시글 입니다.", content: "다섯 번쨰 dummy게시글입니다.", userNickName: "nickname5", time: "09:57", hashTag: ["dummy","미라","이집트","피라미드"]),
                                 Post(id: 6, title: "제 첫 게시글 입니다.", content: "여섯 번쨰 dummy게시글입니다.", userNickName: "nickname6", time: "03:22", hashTag: ["게시물","소통"]),
                                 Post(id: 7, title: "제 첫 게시글 입니다.", content: "일곱 번쨰 dummy게시글입니다.", userNickName: "nickname7", time: "19:36", hashTag: ["마지막 게시물","마지막","선팔","맞팔","소통"])]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(NoticeBoardViewCell.self, forCellReuseIdentifier: "NoticeBoardViewCell")
        tableView.rowHeight = 100.0
        
    }
    
}


extension NoticeBoardViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NoticeBoardViewCell", for: indexPath) as? NoticeBoardViewCell else { return UITableViewCell()}
       
        cell.setup(with: posts[indexPath.row])
        return cell
    }
    
   
}
