//
//  NoticeBoardDetailViewController.swift
//  IOS-SpringBoot-MyNoticeBoard_App
//
//  Created by 양준식 on 2022/04/15.
//

import UIKit
import SnapKit
import Kingfisher

class NoticeBoardDetailViewController: UIViewController {
    
    var post: Post?
    private var commentList: [Comment] = []
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        
        scrollView.layer.borderWidth = 2.0
        scrollView.layer.borderColor = UIColor.green.cgColor
        
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let contentView = UIView()
        
        return contentView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20.0, weight: .bold)
        label.textColor = .black
        
        return label
        
    }()
    
    private lazy var hashTagLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 10.0, weight: .semibold)
        label.textColor = .systemMint
        
        return label
    }()
    
    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .green
        
        return imageView
    }()
    
    private lazy var nickNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12.0, weight: .medium)
        label.textColor = .lightGray
        
        return label
    }()
    
    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12.0, weight: .medium)
        label.textColor = .lightGray
        
        return label
    }()
    
    //자신의 글일 때만 보이는 수정 버튼
    private lazy var menuButton: UIButton = {
        let button = UIButton()
        
        button.layer.borderWidth = 2.0
        button.layer.cornerRadius = 15.0
        button.layer.borderColor = UIColor(red: 70/255, green: 205/255, blue: 170/255, alpha: 1.0).cgColor
      
        button.setTitle("...", for: .normal)
        button.setTitleColor(.systemMint, for: .normal)
        
        button.addTarget(self, action: #selector(onTapButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var contentsTextView: UITextView = {
        let textView = UITextView()
        textView.font = .systemFont(ofSize: 17.0, weight: .bold)
        textView.textColor = .black
        
        textView.layer.borderWidth = 1.0
        textView.layer.cornerRadius = 10.0
        textView.layer.borderColor = UIColor(red: 70/255, green: 205/255, blue: 170/255, alpha: 1.0).cgColor
        textView.isEditable = false
        
        return textView
    }()
    

    
    //댓글을 표시할 collectionView
    private lazy var commentsCollectionView: UICollectionView = {
        //UICollectionView는 항상 layout이 필요하다
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
         collectionView.delegate = self
         collectionView.dataSource = self
       // collectionView.backgroundColor = .systemBackground
        collectionView.register(CommentCollectionViewCell.self, forCellWithReuseIdentifier: "CommentCollectionViewCell")
        //headerView 등록
        collectionView.register(CommentCollectionHeaderView.self,
                            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "CommentCollectionHeaderView")
        
        // 지울 것
        collectionView.layer.borderWidth = 1.0
        collectionView.layer.borderColor = UIColor.systemMint.cgColor
        collectionView.layer.cornerRadius = 20.0
        return collectionView
    }()
    //댓글 작성 버튼
    private lazy var newCommentButton: UIButton = {
      
        let button = UIButton()
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor.cyan.cgColor
        button.layer.cornerRadius = 20.0
        
        button.setImage(UIImage(systemName: "pencil"), for: .normal)
        
        button.setTitle(" 댓글쓰기", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.tintColor = .systemMint
        button.addTarget(self, action: #selector(tapNCButton), for: .touchUpInside)
        
        
        return button
    }()
    

    @objc func tapNCButton(){
        
        let alert = UIAlertController(title: "댓글을 등록하시겠습니까?", message: nil, preferredStyle: .alert)
        
        //버튼(Action을 위한)을 UIAlertAction객체로 생성 , 해당 버튼을 누르면 일어날 기능을 handler에 클로저로 넣어줌/ 아무 일도 안 일어날거면 nil
        let registerButton = UIAlertAction( title: "등록", style: .default, handler: { [weak self] _ in
            debugPrint("\( alert.textFields?[0].text )")
            
            //textFields는  title, message처럼 UIAlertController가 갖고있는 perperty임 ( UITextField의 배열)
            //여기서는 UITextField에 입력된 값이 있다면 tasks 배열에 추가하는 것
            guard let content = alert.textFields?[0].text else { return }
            guard let pid = self?.post?.id else { return }
          //사용자가 입력하고 추가한 내용을 토대로 로그인 정보를 구현하기 전까지 임시로 Comment 구조체 인스턴스를 만든다
            let dto = Comment(id: nil, content: content, userNickName: "새댓글 닉네임", time: "20:22", postId: pid )
            // DB에 날려서 댓글을 저장하고, 다시 fetch하여 collectionView를 갱신한다.
//            self?.tasks.append(task)
//            self?.tableView.reloadData()
            // TODO:  여기에 api메서드 구현
            self?.postComment(newComment: dto)
            
        } )
        
        let cancelButton = UIAlertAction(title: "취소", style: .cancel, handler: nil)// 취소 버튼 클릭 시, 별다른 것 하지 않기때문에 handelr에 nil
        
        //addAction은 최대 두개까지 된다.
        alert.addAction(cancelButton)
        alert.addAction(registerButton)
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "댓글 내용을 입력해주세요"
        })
      
        self.present(alert, animated: true, completion: nil)
    }
    //보이지않는 fake textField
//    private lazy var fakeTextField: UITextField = {
//        let textField = UITextField()
//        textField.layer.borderWidth = 1.0
//        textField.layer.borderColor = UIColor.cyan.cgColor
//        textField.layer.cornerRadius = 10.0
//        textField.isHidden = true
//
//        return textField
//    }()
    
    //툴바 안에 들어갈 textField
//    private lazy var tbTextField: UITextField = {
//        let textField = UITextField()
//        textField.layer.borderWidth = 1.0
//        textField.layer.borderColor = UIColor.cyan.cgColor
//        textField.layer.cornerRadius = 10.0
//        textField.frame = CGRect(x:0, y: 0, width: view.frame.size.width - 100, height: 44)
//        return textField
//    }()
    
    
    
    @objc func onTapButton(){
        let alert = UIAlertController(title: "변경하시겠습니까?", message: nil, preferredStyle: .actionSheet)
        
        let reviseButton = UIAlertAction(title: "글 수정하기", style: .default, handler: {[weak self] _ in
            debugPrint("수정버튼 클릭")
            let viewController = NewPostViewController()
            guard let post = self?.post else {return}
            viewController.postEditMode = .edit(post)
            self?.navigationController?.pushViewController(viewController, animated: true)
            
        })
        let deleteButton = UIAlertAction(title: "글 삭제하기", style: .default, handler: {[weak self] _ in
            
           // debugPrint("삭제버튼 클릭")
            //self?.dismiss(animated:true)
            self?.deleteForReal()
        })
       
        
        let cancelButton = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alert.addAction(reviseButton)
        alert.addAction(deleteButton)
        alert.addAction(cancelButton)
        
        self.present(alert, animated: true, completion: nil)
    }
    
  
    
    
    
    //정말 삭제하겠냐고 되묻는 alert
    private func deleteForReal(){
        let alert = UIAlertController(title: "정말 삭제하시겠습니까?", message: nil, preferredStyle: .alert)
        
        let deleteButton = UIAlertAction(title: "삭제", style: .default){ [weak self] _ in
            //api
            self?.deletePost()
        }// 취소 버튼 클릭 시, 별다른 것 하지 않기때문에 handelr에 nil
        
        let cancelButton = UIAlertAction(title: "취소", style: .cancel, handler: nil)//
        
        alert.addAction(deleteButton)
        alert.addAction(cancelButton)
        self.present(alert, animated: true, completion: nil)
    }
    
 
    override func viewDidLoad() {
        super.viewDidLoad()
       
        //backbutton
        //navi 제목
        
        configContents()
        
//        let toolBar = UIToolbar(frame: CGRect(x:0, y: 0, width: view.frame.size.width, height: 50))
//        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
//
//        let doneButton = UIBarButtonItem(title: "done", style: .done, target: self, action: #selector(didTapDone))
//        toolBar.items = [flexibleSpace, doneButton]
//        toolBar.sizeToFit()
//
//
//       fakeTextField.inputAccessoryView = toolBar
        
        //받아온 데이터로 collectionView에 흩뿌려진다.
        fetchComments()
    }
//    @objc func didTapDone(){
//        print("clickkkk")
//        fakeTextField.resignFirstResponder()
//    }
    
    private func configContents(){
        configSubView()
        
     
        //가져온 post데이터를 뿌려줌
        self.titleLabel.text = self.post?.title
        self.hashTagLabel.text = post?.hashTag
        let imageURL = URL(string: "https://www.google.com/imgres?imgurl=http%3A%2F%2Fwww.bigtanews.co.kr%2Fnews%2Fphoto%2F201809%2F69_63_2923.jpg&imgrefurl=http%3A%2F%2Fwww.bigtanews.co.kr%2Fnews%2FarticleView.html%3Fidxno%3D69&tbnid=puF4je26H2YtsM&vet=12ahUKEwjWpriz7pX3AhUK35QKHaUNARgQMygGegUIARDfAQ..i&docid=RackHfu4Lwy0DM&w=550&h=366&q=중앙대&client=safari&ved=2ahUKEwjWpriz7pX3AhUK35QKHaUNARgQMygGegUIARDfAQ" ?? "")
        profileImageView.kf.setImage(with: imageURL, placeholder: UIImage(systemName: "beer_icon") )
        self.nickNameLabel.text = self.post?.userNickName
        self.timeLabel.text =  self.post?.time
        self.contentsTextView.text = self.post?.content
    }
    
   
    
}

extension NoticeBoardDetailViewController {
    private func configSubView(){
    
        self.view.addSubview(scrollView)
        
        scrollView.snp.makeConstraints{
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
        scrollView.addSubview(contentView)
        
        contentView.snp.makeConstraints{
            $0.edges.equalTo(0)
            $0.width.equalTo(view.frame.width)
            $0.height.equalTo(view.frame.height+600)
        }
        
        [ titleLabel, hashTagLabel, profileImageView, nickNameLabel, timeLabel, menuButton, contentsTextView, commentsCollectionView, newCommentButton].forEach{
            contentView.addSubview($0)
        }
        
        titleLabel.snp.makeConstraints{
            $0.leading.top.equalToSuperview().inset(6.0)
            $0.height.equalTo(40.0)
        }
        
        hashTagLabel.snp.makeConstraints{
            $0.leading.equalTo(titleLabel.snp.leading)
            $0.top.equalTo(titleLabel.snp.bottom)
        }
        
        profileImageView.snp.makeConstraints{
            $0.leading.equalTo(titleLabel.snp.leading)
            $0.top.equalTo(hashTagLabel.snp.bottom).offset(6.0)
            $0.width.equalTo(40.0)
            $0.height.equalTo(40.0)
        }
        
        nickNameLabel.snp.makeConstraints{
            $0.top.equalTo(profileImageView.snp.top).offset(3.0)
            $0.leading.equalTo(profileImageView.snp.trailing).offset(8.0)
            
        }
        
        timeLabel.snp.makeConstraints{
            $0.bottom.equalTo(profileImageView.snp.bottom).inset(5.0)
            $0.leading.equalTo(profileImageView.snp.trailing).offset(8.0)
            
        }
        
        menuButton.snp.makeConstraints{
            $0.top.equalTo(hashTagLabel.snp.bottom).offset(10.0)
           // $0.leading.equalTo(nickNameLabel.snp.trailing).offset(20.0)
            $0.trailing.equalToSuperview().inset(12.0)
            $0.height.equalTo(32.0)
            $0.width.equalTo(64.0)
        }
        
        contentsTextView.snp.makeConstraints{
            $0.leading.equalTo(scrollView.snp.leading).inset(12.0)
            $0.trailing.equalTo(scrollView.snp.trailing).inset(12.0)
            $0.top.equalTo(profileImageView.snp.bottom).offset(10)
            $0.height.equalTo(700.0)
        }
        
        commentsCollectionView.snp.makeConstraints{
            $0.top.equalTo(contentsTextView.snp.bottom).offset(18.0)
            $0.leading.trailing.equalToSuperview().inset(12.0)
            $0.height.equalTo(350.0)
        }
        
        newCommentButton.snp.makeConstraints{
            $0.top.equalTo(commentsCollectionView.snp.bottom).offset(14.0)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(100.0)
            $0.height.equalTo(40.0)
        }
        
//        fakeTextField.snp.makeConstraints{
//            $0.top.equalTo(newCommentButton.snp.bottom).offset(10.0)
//
//            $0.leading.trailing.equalToSuperview().inset(12.0)
//        }
        
    }
}

extension NoticeBoardDetailViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return commentList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CommentCollectionViewCell", for: indexPath) as? CommentCollectionViewCell else { return UICollectionViewCell() }
        
        let comment = commentList[indexPath.item]
        debugPrint("CollectionViewCell에 뿌리기 직전 : "  )
        print(comment)
        cell.setup(comment: comment )
        return cell
    }
    //header, footer 구분해서 작성
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader,
              let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "CommentCollectionHeaderView", for: indexPath) as? CommentCollectionHeaderView else { return UICollectionReusableView() }
        
        header.setupViews()
        
        return header
    }
}
extension NoticeBoardDetailViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width - 12.0
        return CGSize(width: width, height: 60)
    }
    
    //header의 사이즈 설정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        CGSize(width: collectionView.frame.width , height: 50)
    }
}



// NavigationItem UIBarButtonItem Action
extension NoticeBoardDetailViewController{
    func onDeleteSuccess(){
        let alert = UIAlertController(title: "글이 성공적으로 삭제되었습니다.", message: nil, preferredStyle: .alert)
        
        let okButton = UIAlertAction(title: "확인", style: .default, handler: {[weak self] _ in
            debugPrint("목록으로 이동")

            // Todo: 글목록으로 이동해야함
            self?.navigationController?.popViewController(animated: true)
          
//            let viewController = NewPostViewController()
//            guard let post = self?.post else {return}
//            viewController.postEditMode = .edit(post)
//            self?.navigationController?.pushViewController(viewController, animated: true)
            
        })
       
        alert.addAction(okButton)
   
        self.present(alert, animated: true, completion: nil)
    }
}

// 게시글 delete 메서드, 댓글 fetch 메서드
private extension NoticeBoardDetailViewController{
    
    // 게시글 delete
    func deletePost(){
          debugPrint("delete button pressed")
        guard let url = URL(string: "http://localhost:9090/api/posts/\(post?.id ?? 0)") else {
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
      
    //댓글 fetch 메서드
    func fetchComments(){
        guard let pid = self.post?.id else { return }
        guard let url = URL(string: "http://localhost:9090/api/posts/\(pid)/comments") else {
            debugPrint("ERROR: during Making URL object")
            return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let dataTask = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard error == nil else{
                print("ERROR: error calling GET")
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
            guard let comments = try? JSONDecoder().decode([Comment].self, from : data)  else {
                print("ERROR: URLSession data task \(error?.localizedDescription ?? "")")
                return
            }
        
            
            switch response.statusCode{
            case(200...299)://성공
                debugPrint("댓글 GET 성공!!")
                self?.commentList.removeAll()
                self?.commentList += comments
                debugPrint(self?.commentList)
                
//                //UI작업은 main스레드에서 하도록
//                DispatchQueue.main.async{
//                    self.tableView.reloadData()
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
    
    // 새 댓글 작성 메서드 (Post)
    func postComment(newComment: Comment){
        debugPrint("Post button pressed")
        guard let pid = self.post?.id else {return}
        guard let url = URL(string: "http://localhost:9090/api/posts/\(pid)/comments") else {
            print("ERROR: Cannot create URL")
            return
        }
        
        guard let jsonData = try? JSONEncoder().encode(newComment) else {
            print("ERROR: Trying to convert model to JSON data")
            return
        }
        
        print("mymy" )
        print(jsonData)
        print("mymy End")
        
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
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
            guard let comment = try? JSONDecoder().decode(Comment.self, from : data) else {
                print("ERROR: URLSession data task \(error?.localizedDescription ?? "")")
                return
            }

            switch response.statusCode{
            case(200...299)://성공
                print("post 성공")
                print(comment)
                self.fetchComments()
                //UI작업은 main스레드에서 하도록
                //글 작성 페이지를 초기화
                DispatchQueue.main.async{
               
                    //새로 받아온 데이터로 다시 화면 구성
                    self.commentsCollectionView.reloadData()
                  
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
//     func updateComment(){
//        debugPrint("update button pressed")
//        guard let postId = editModePostId else { return }
//        guard let url = URL(string: "http://localhost:9090/api/posts/\(postId)") else {
//            print("ERROR: Cannot create URL")
//            return
//        }
//
//        let newPost: Post = Post(id: postId, title: titleTextField.text, content: contentsTextView.text, userNickName: "PATCH한 닉네임", time: "13:31", hashTag: hashtagTextField.text)
//
//        guard let jsonData = try? JSONEncoder().encode(newPost) else {
//            print("ERROR: Trying to convert model to JSON data")
//            return
//        }
//
//        debugPrint("mymy" )
//        debugPrint(jsonData)
//        debugPrint("mymy End")
//
//
//        var request = URLRequest(url: url)
//        request.httpMethod = "PATCH"
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.setValue("application/json", forHTTPHeaderField: "Accept")
//        //body에 담아 보낸다
//        request.httpBody = jsonData
//
//        let dataTask = URLSession.shared.dataTask(with: request) {  data, response, error in
//            guard error == nil else{
//                print("ERROR: error calling POST")
//                return
//            }
//            guard let response = response as? HTTPURLResponse else{
//                print("ERROR: Http request failed")
//                return
//            }
//            guard let data = data else{
//                print("ERROR: Did not receive data")
//                return
//            }
//            guard let updatedPost = try? JSONDecoder().decode(Post.self, from : data) else {
//                print("ERROR: URLSession data task \(error?.localizedDescription ?? "")")
//                return
//            }
//
//            switch response.statusCode{
//            case(200...299)://성공
//                print("PATCH 성공")
//                print(updatedPost)
//
//                //UI작업은 main스레드에서 하도록
//                //글 작성 페이지를 초기화
//                DispatchQueue.main.async{
//                // 작성이 잘 됐다는 UIAlertController 보여주기
//                self.onTapReviseButton()
//                }
//
//            case(400...499)://클라이언트 에러
//                print("""
//ERROR: Client ERROR \(response.statusCode)
//Response: \(response)
//""")
//            case(500...599)://서버에러
//                print("""
//ERROR: Server ERROR \(response.statusCode)
//Response: \(response)
//""")
//            default://이외
//                print("""
//ERROR: ERROR \(response.statusCode)
//Response: \(response)
//""")
//
//            }
//        }
//    dataTask.resume() // 해당 task를 실행
//}
//
    
    
}
