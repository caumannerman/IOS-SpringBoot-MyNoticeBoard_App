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
    private lazy var reviseButton: UIButton = {
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
    
    @objc func onTapButton(){
        let alert = UIAlertController(title: "변경하시겠습니까?", message: nil, preferredStyle: .actionSheet)
        
        let reviseButton = UIAlertAction(title: "글 수정하기", style: .default, handler: {[weak self] _ in
            debugPrint("수정버튼 클릭")
            let viewController = NewPostViewController()
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
        
        let deleteButton = UIAlertAction(title: "삭제", style: .default, handler: nil)// 취소 버튼 클릭 시, 별다른 것 하지 않기때문에 handelr에 nil
        
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
        
    }
    
    private func configContents(){
        configSubView()
        //가져온 post데이터를 뿌려줌
        self.titleLabel.text = self.post?.title
        self.hashTagLabel.text = "#hahaha #hoho #kkk"
        let imageURL = URL(string: "https://www.google.com/imgres?imgurl=http%3A%2F%2Fwww.bigtanews.co.kr%2Fnews%2Fphoto%2F201809%2F69_63_2923.jpg&imgrefurl=http%3A%2F%2Fwww.bigtanews.co.kr%2Fnews%2FarticleView.html%3Fidxno%3D69&tbnid=puF4je26H2YtsM&vet=12ahUKEwjWpriz7pX3AhUK35QKHaUNARgQMygGegUIARDfAQ..i&docid=RackHfu4Lwy0DM&w=550&h=366&q=중앙대&client=safari&ved=2ahUKEwjWpriz7pX3AhUK35QKHaUNARgQMygGegUIARDfAQ" ?? "")
        profileImageView.kf.setImage(with: imageURL, placeholder: UIImage(systemName: "beer_icon") )
        self.nickNameLabel.text = self.post?.userNickName
        self.timeLabel.text = "13:31"
        self.contentsTextView.text = self.post?.content
      
    }
    
    
    
}

extension NoticeBoardDetailViewController {
    private func configSubView(){
    
        [ titleLabel, hashTagLabel, profileImageView, nickNameLabel, timeLabel, reviseButton, contentsTextView].forEach{
            view.addSubview($0)
        }
        
        titleLabel.snp.makeConstraints{
            $0.leading.top.equalTo(view.safeAreaLayoutGuide).inset(6.0)
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
        
        reviseButton.snp.makeConstraints{
            $0.top.equalTo(hashTagLabel.snp.bottom).offset(10.0)
           // $0.leading.equalTo(nickNameLabel.snp.trailing).offset(20.0)
            $0.trailing.equalToSuperview().inset(12.0)
            $0.height.equalTo(32.0)
            $0.width.equalTo(64.0)
        }
        
        contentsTextView.snp.makeConstraints{
            $0.leading.trailing.equalToSuperview().inset(12.0)
            $0.top.equalTo(profileImageView.snp.bottom).offset(10)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(12.0)
            
        }
        
        
    }
}
