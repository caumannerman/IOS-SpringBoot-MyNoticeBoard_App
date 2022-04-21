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
}
