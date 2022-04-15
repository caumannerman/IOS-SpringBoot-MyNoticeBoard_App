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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        switch postEditMode {
        case .new:
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "등록", style: .plain, target: self, action: nil)
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "임시저장", style: .plain, target: self, action: nil)
        case .edit(_):
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "수정", style: .plain, target: self, action: nil)
        }
       
        setupSubview()
        placeholderSetting()
        configureEditMode()
        
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
        default:
            break
        
        }
           
        }
    
}

private extension NewPostViewController{
    func setupSubview(){
        [titleTextField, contentsTextView].forEach{
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
