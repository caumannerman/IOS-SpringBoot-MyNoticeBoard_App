//
//  CommentCollectionViewCell.swift
//  IOS-SpringBoot-MyNoticeBoard_App
//
//  Created by 양준식 on 2022/04/21.
//

import UIKit
import SnapKit

//content, nickname ,time,   // id랑, postId는 표시할 필요 X
final class CommentCollectionViewCell: UICollectionViewCell {
    private var commentId: Int?
    private var postId: Int?
    
    // 닉네임 라벨
    private lazy var nickNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14.0, weight: .bold)
        label.textColor = .black
        
        return label
    }()
    
    // 댓글 단 시간 나타낼 라벨
    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 10.0, weight: .light)
        label.textColor = .lightGray
        
        return label
    }()
    
    // 댓글 내용 라벨
    private lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12.0, weight: .medium)
        label.textColor = .darkGray
        label.numberOfLines = 0
        
        return label
    }()
    
    private lazy var moreActionButton: UIButton = {
        let button = UIButton()
        
        button.setImage(UIImage(systemName: "pencil"), for: .normal)
        
        button.tintColor = .lightGray
        button.layer.borderColor = UIColor.darkGray.cgColor
        button.layer.borderWidth = 1.0
        button.layer.cornerRadius = 15.0
         
        button.addTarget(self, action: #selector(onTapMoreButton), for: .touchUpInside)
        
        return button
    }()
    
    func setup(comment: Comment){
       
        commentId = comment.id
        postId = comment.postId
        contentView.layer.cornerRadius = 16.0
        contentView.layer.borderWidth = 1.5
        contentView.layer.borderColor = UIColor.lightGray.cgColor
        setupSubViews()
        //우측 꺾쇠모양
        
        nickNameLabel.text = comment.userNickName
        timeLabel.text = comment.time
        contentLabel.text = comment.content
    }
    
    @objc func onTapMoreButton(){
        let alert = UIAlertController(title: "댓글 더보기", message: nil, preferredStyle: .actionSheet)
      
        let reviseButton = UIAlertAction(title: "수정", style: .default, handler: {[weak self] _ in
            debugPrint("수정버튼 클릭")
            let alert = UIAlertController(title: "댓글을 수정하시겠습니까?", message: nil, preferredStyle: .alert)
            
            //버튼(Action을 위한)을 UIAlertAction객체로 생성 , 해당 버튼을 누르면 일어날 기능을 handler에 클로저로 넣어줌/ 아무 일도 안 일어날거면 nil
            let registerButton = UIAlertAction( title: "수정", style: .default, handler: { [weak self] _ in
                debugPrint("\( alert.textFields?[0].text )")
                
                //textFields는  title, message처럼 UIAlertController가 갖고있는 perperty임 ( UITextField의 배열)
                //
                guard let content = alert.textFields?[0].text else { return }
                
              //사용자가 입력하고 추가한 내용을 토대로 로그인 정보를 구현하기 전까지 임시로 Comment 구조체 인스턴스를 만든다
                let dto = Comment(id: self?.commentId, content: content, userNickName: self?.nickNameLabel.text, time:  self?.timeLabel.text, postId: self?.postId )
                // DB에 날려서 댓글을 저장하고, 다시 fetch하여 collectionView를 갱신한다.
    //            self?.tasks.append(task)
    //            self?.tableView.reloadData()
                // TODO:  여기에 api메서드 구현
                self?.updateComment(updatedComment: dto)
                
            } )
            
            let cancelButton = UIAlertAction(title: "취소", style: .cancel, handler: nil)// 취소 버튼 클릭 시, 별다른 것 하지 않기때문에 handelr에 nil
            
            //addAction은 최대 두개까지 된다.
            alert.addAction(cancelButton)
            alert.addAction(registerButton)
            alert.addTextField(configurationHandler: { textField in
                //원래 작성된 내용 넣어줌 . 수정할 수 있도록
                textField.text = self?.contentLabel.text
            })
          
            self?.window?.rootViewController?.present(alert, animated: true, completion: nil)
//            let viewController = NewPostViewController()
//            guard let post = self?.post else {return}
//            viewController.postEditMode = .edit(post)
//            self?.navigationController?.pushViewController(viewController, animated: true)
        })
        
        let deleteButton = UIAlertAction(title: "삭제", style: .default, handler: {[weak self] _ in
//            self?.deleteForReal()
            debugPrint("t삭제버튼 클릭")
            //삭제 api 호출
            self?.deleteComment()
        })
        
        let cancelButton = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alert.addAction(reviseButton)
        alert.addAction(deleteButton)
        alert.addAction(cancelButton)
        self.window?.rootViewController?.present(alert, animated: true, completion: nil)
        //present(alert, animated: true, completion: nil)
    }
    private func onDeleteSuccess(){
        let alert = UIAlertController(title: "댓글 삭제 완료", message: nil, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "확인", style: .default, handler: {[weak self] _ in
//            self?.deleteForReal()
            debugPrint("확인버튼 클릭")
            //삭제 api 호출
          
        })
        
        alert.addAction(okButton)
        self.window?.rootViewController?.present(alert, animated: true, completion: nil)
        
    }
    
    
    
}

private extension CommentCollectionViewCell{
    func setupSubViews(){
        [nickNameLabel, timeLabel, contentLabel, moreActionButton].forEach{
            contentView.addSubview($0)
        }
        
        nickNameLabel.snp.makeConstraints{
            $0.top.leading.equalToSuperview().inset(12.0)
        }
        
        timeLabel.snp.makeConstraints{
            $0.top.equalToSuperview().inset(12.0)
            $0.leading.equalTo(nickNameLabel.snp.trailing).offset(20.0)
        }
        
        contentLabel.snp.makeConstraints{
            $0.bottom.equalToSuperview().inset(12.0)
            $0.leading.equalToSuperview().inset(12.0)
        }
        
        moreActionButton.snp.makeConstraints{
            $0.top.equalToSuperview().inset(12.0)
            $0.trailing.equalToSuperview().inset(12.0)
            $0.width.equalTo(30.0)
            $0.height.equalTo(30.0)
        }
    }
}

private extension CommentCollectionViewCell{
    // 게시글 delete
    func deleteComment(){
          debugPrint("delete button pressed")
        guard let comId = commentId else { return }
        guard let url = URL(string: "http://localhost:9090/api/comments/\(comId)") else {
              print("ERROR: DELETE ERROR creating URL")
              return
          }
          
          var request = URLRequest(url: url)
          request.httpMethod = "DELETE"
          //request.setValue("application/json", forHTTPHeaderField: "Content-Type")
          request.setValue("application/json", forHTTPHeaderField: "Accept")
          
          let dataTask = URLSession.shared.dataTask(with: request) {  data, response, error in
              guard error == nil else{
                  print("ERROR: error calling DELETE")
                  return
              }
              guard let response = response as? HTTPURLResponse else{
                  print("ERROR: Http request failed")
                  return
              }
              guard let data = data else{
                  print("ERROR: Did not receive data")
                  return
              }

              switch response.statusCode{
              case(200...299)://성공
                  debugPrint("delete 성공")
                 
                  //UI작업은 main스레드에서 하도록
                  DispatchQueue.main.async{
                  
                  // 삭제가 잘 됐다는 UIAlertController 보여주기
                  self.onDeleteSuccess()
                      
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
    
     // 댓글 수정 메서드
    func updateComment(updatedComment: Comment){
        debugPrint("update button pressed")
        guard let cid = commentId else { return }
        guard let url = URL(string: "http://localhost:9090/api/comments/\(cid)") else {
            print("ERROR: Cannot create URL")
            return
        }


        guard let jsonData = try? JSONEncoder().encode(updatedComment) else {
            print("ERROR: Trying to convert model to JSON data")
            return
        }

        debugPrint("mymy" )
        debugPrint(jsonData)
        debugPrint("mymy End")


        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        //body에 담아 보낸다
        request.httpBody = jsonData

        let dataTask = URLSession.shared.dataTask(with: request) {  data, response, error in
            guard error == nil else{
                print("ERROR: error calling POST")
                return
            }
            guard let response = response as? HTTPURLResponse else{
                print("ERROR: Http request failed")
                return
            }
            guard let data = data else{
                print("ERROR: Did not receive data")
                return
            }
            guard let updatedComment = try? JSONDecoder().decode(Comment.self, from : data) else {
                print("ERROR: URLSession data task \(error?.localizedDescription ?? "")")
                return
            }

            switch response.statusCode{
            case(200...299)://성공
                print("PATCH 성공")
                print(updatedComment)

                //UI작업은 main스레드에서 하도록
                //글 작성 페이지를 초기화
//                DispatchQueue.main.async{
//                    // 작성이 잘 됐다는 UIAlertController 보여주기
//                    self.onTapReviseButton()
//                }

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

}
