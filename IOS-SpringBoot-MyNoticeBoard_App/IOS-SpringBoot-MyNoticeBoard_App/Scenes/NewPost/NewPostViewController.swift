//
//  NewPostViewController.swift
//  IOS-SpringBoot-MyNoticeBoard_App
//
//  Created by 양준식 on 2022/04/14.
//

import UIKit
import SnapKit

enum PostEditMode{
    case new
    case edit( Post)
}

class NewPostViewController: UIViewController {
    
    var postEditMode: PostEditMode = .new
    
    private lazy var titleTextField: UITextField = {
        let textField = UITextField()
        textField.font = .systemFont(ofSize: 17.0, weight: .bold)
        textField.textColor = .black
      
        textField.layer.borderWidth = 1.5
        textField.layer.cornerRadius = 10.0
        textField.layer.borderColor = UIColor(red: 70/255, green: 205/255, blue: 170/255, alpha: 1.0).cgColor
        
        textField.placeholder = "제목을 입력해주세요."
       
        return textField
    }()

    private lazy var contentsTextView: UITextView = {
        let textView = UITextView()
        textView.font = .systemFont(ofSize: 17.0, weight: .bold)
        textView.textColor = .lightGray
        
        textView.layer.borderWidth = 2.5
        textView.layer.cornerRadius = 10.0
        textView.layer.borderColor = UIColor(red: 70/255, green: 205/255, blue: 170/255, alpha: 1.0).cgColor
        
        
        textView.text = "내용을 입력해주세요."
        
        return textView
    }()
    
    private lazy var hashtagTextField: UITextField = {
        let textField = UITextField()
        textField.font = .systemFont(ofSize: 17.0, weight: .bold)
        textField.textColor = .black
        
        
        textField.layer.borderWidth = 2.5
        textField.layer.cornerRadius = 10.0
        textField.layer.borderColor = UIColor(red: 70/255, green: 205/255, blue: 170/255, alpha: 1.0).cgColor
        
        textField.placeholder = "해시태그를 입력하세요."
       
        return textField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        switch postEditMode {
        case .new:
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "등록", style: .plain, target: self , action: #selector(createPost))
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "임시저장", style: .plain, target: self, action: nil)
        case .edit(_):
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "수정", style: .plain, target: self, action: nil)
        }
       
        setupSubview()
        placeholderSetting()
        configureEditMode()
       
        
    }
                                                                     
    @objc func createPost(){
        print("pressed")
        guard let url = URL(string: "http://localhost:8080/api/posts/") else {
            print("ERROR: Cannot create URL")
            return
        }
        
        let newPost: Post = Post(id: nil, title: titleTextField.text, content: contentsTextView.text, userNickName: "new닉네임s", time: "13:31", hashTag: hashtagTextField.text)

        guard let jsonData = try? JSONEncoder().encode(newPost) else {
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
            guard let posts = try? JSONDecoder().decode(Post.self, from : data) else {
                print("ERROR: URLSession data task \(error?.localizedDescription ?? "")")
                return
            }

            switch response.statusCode{
            case(200...299)://성공
                print("post 성공")
                print(posts)

                //UI작업은 main스레드에서 하도록
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
    
    private func placeholderSetting(){
        contentsTextView.delegate = self
        contentsTextView.text = "내용을 입력해주세요."
        contentsTextView.textColor = .lightGray
    }
    
    //edit모드일 시, 가져온 post의 title, content를 뿌려줌
    private func configureEditMode(){
        switch postEditMode {
        case .edit(let post):
            self.titleTextField.text = post.title
            self.contentsTextView.text = post.content
            self.contentsTextView.textColor = .black
            self.hashtagTextField.text = post.hashTag
           
        default:
            break
        }
        }
}

private extension NewPostViewController{
    func setupSubview(){
        [titleTextField, contentsTextView, hashtagTextField].forEach{
            view.addSubview($0)
        }
        
        titleTextField.snp.makeConstraints{
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(10.0)
            $0.leading.trailing.equalToSuperview().inset(12.0)
            $0.height.equalTo(50)
        }
        
        contentsTextView.snp.makeConstraints{
            $0.leading.trailing.equalToSuperview().inset(12.0)
            $0.top.equalTo(titleTextField.snp.bottom).offset(10)
            $0.height.equalTo(300)
        }
        
        hashtagTextField.snp.makeConstraints{
            $0.leading.trailing.equalToSuperview().inset(12.0)
            $0.top.equalTo(contentsTextView.snp.bottom).offset(10)
            $0.height.equalTo(35)
            
        }
    }
}

// textView의 placeholder지정을 위한 protocol구현
extension NewPostViewController: UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
        if contentsTextView.textColor == .lightGray{
            contentsTextView.text = nil
            contentsTextView.textColor = .black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if contentsTextView.text.isEmpty{
            contentsTextView.text = "내용을 입력해주세요."
            contentsTextView.textColor = .lightGray
        }
        
    }
}
