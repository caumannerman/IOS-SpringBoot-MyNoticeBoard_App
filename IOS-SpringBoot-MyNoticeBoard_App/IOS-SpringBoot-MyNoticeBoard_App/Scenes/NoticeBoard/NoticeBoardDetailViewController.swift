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
        
        return button
    }()
    
    
    
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
        
        //받아온 데이터로 collectionView에 흩뿌려진다.
        fetchComments()
    }
    
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
}
extension NoticeBoardDetailViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width - 12.0
        return CGSize(width: width, height: 60)
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
    
}
