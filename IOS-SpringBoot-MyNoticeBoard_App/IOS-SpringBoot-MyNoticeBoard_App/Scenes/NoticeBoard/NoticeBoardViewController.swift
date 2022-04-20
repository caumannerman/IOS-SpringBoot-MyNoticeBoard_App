//
//  PostsViewController.swift
//  IOS-SpringBoot-MyNoticeBoard_App
//
//  Created by 양준식 on 2022/04/14.
//

import UIKit
import SnapKit

class NoticeBoardViewController: UITableViewController {
//    private var posts: [Post] = [Post(id: 1, title: "제 첫 게시글 입니다.", content: "첫 번쨰 dummy게시글입니다.", userNickName: "nickname1", time: "12:31", hashTag: ["첫게시물","첫 게시","선팔"]),
//                                 Post(id: 2, title: "제 두번째 게시글 입니다.", content: "두 번쨰 dummy게시글입니다.", userNickName: "nickname2", time: "21:07", hashTag: ["두번째 게시물","첫 게시","선팔"]),
//                                 Post(id: 3, title: "제 3 게시글 입니다.", content: "세 번쨰 dummy게시글입니다.", userNickName: "nickname3", time: "15:14", hashTag: ["세 번째 게시물","3 게시","333","3"]),
//                                 Post(id: 4, title: "제 4 게시글 입니다.", content: "네 번쨰 dummy게시글입니다.", userNickName: "nickname4", time: "11:16", hashTag: ["네번째 게시물","4 게시","four"]),
//                                 Post(id: 5, title: "제 5 게시글 입니다.", content: "다섯 번쨰 dummy게시글입니다.", userNickName: "nickname5", time: "09:57", hashTag: ["dummy","미라","이집트","피라미드"]),
//                                 Post(id: 6, title: "제 6 게시글 입니다.", content: "여섯 번쨰 dummy게시글입니다.", userNickName: "nickname6", time: "03:22", hashTag: ["게시물","소통"]),
//                                 Post(id: 7, title: "제 7 게시글 입니다.", content: "일곱 번쨰 dummy게시글입니다.", userNickName: "nickname7", time: "19:36", hashTag: ["마지막 게시물","마지막","선팔","맞팔","소통"])]
    var postList: [Post] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 당겨서 새로고침을 위함  tableView는 ScrollView를 상속받고, 이는 RefreshControl을 멤버로 갖고있다.
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        tableView.register(NoticeBoardViewCell.self, forCellReuseIdentifier: "NoticeBoardViewCell")
        tableView.rowHeight = 100.0
        
        getAllPosts()
        
    }
    
}


extension NoticeBoardViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postList.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NoticeBoardViewCell", for: indexPath) as? NoticeBoardViewCell else { return UITableViewCell()}
       
        cell.setup(with: postList[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let noticeBoardDetailView = NoticeBoardDetailViewController()
        noticeBoardDetailView.post = postList[indexPath.row]
        //self.show(noticeBoardDetailView, sender: nil)
        self.navigationController?.pushViewController(noticeBoardDetailView, animated: true)
    }
}


extension NoticeBoardViewController{
   @objc func getAllPosts() {
        guard let url = URL(string: "http://localhost:9090/api/posts/") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let dataTask = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard error == nil,
                  let self = self,
                  let response = response as? HTTPURLResponse,
                  let data = data,
                  let posts = try? JSONDecoder().decode([Post].self, from : data) else {
                print("ERROR: URLSession data task \(error?.localizedDescription ?? "")")
                return
            }
            
            switch response.statusCode{
            case(200...299)://성공
                self.postList += posts
                
                //UI작업은 main스레드에서 하도록
                DispatchQueue.main.async{
                    self.tableView.reloadData()
                }
            case(400...499)://클라이언트 에러
                print("""
ERROR: Client ERROR \(response.statusCode)
Response: \(response)
""")
            case(500...599)://서버에러
                print("""
ERROR: Server ERROR \(response.statusCode)
Response: \(response)
""")
            default://이외
                print("""
ERROR: ERROR \(response.statusCode)
Response: \(response)
""")
                
            }
        }
        dataTask.resume() // 해당 task를 실행
    }
    
    @objc private func refreshData(){
        //데이터를 다시 로드하므로, 기존 데이터 다 지우고 다시 받아옴
        postList.removeAll()
        getAllPosts()
        //다시 받아온 데이터로 테이블 뷰 업데이트
        self.tableView?.reloadData()
        self.tableView.refreshControl?.endRefreshing()
    }
}
