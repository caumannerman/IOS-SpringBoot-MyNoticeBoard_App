//
//  NoticeBoardViewCell.swift
//  IOS-SpringBoot-MyNoticeBoard_App
//
//  Created by 양준식 on 2022/04/14.
//

import UIKit
import SnapKit


final class NoticeBoardViewCell : UITableViewCell {
    
    private lazy var idLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14.0, weight: .bold)
        label.textColor = .black
  
        
        return label
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17.0, weight: .bold)
        label.textColor = .black
   
        return label
    }()
    
    private lazy var hashTagLabel: UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 9.0, weight: .medium)
        label.textColor = .cyan
        
        return label
    }()
    
    private lazy var nicknameLabel: UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 12.0, weight: .medium)
        label.textColor = .darkGray

        
        return label
    }()
    
    private lazy var timeLabel: UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 12.0, weight: .medium)
        label.textColor = .lightGray
        
        return label
    }()
    
    func setup(with post: Post){
        setupSubView()
        
        idLabel.text = String(post.id!)
        titleLabel.text = post.title
        print("lslsl")
        hashTagLabel.text = "#haha # hohoh #llkkkkk"
        nicknameLabel.text = post.userNickName
        timeLabel.text = post.time
        
    }
}


private extension NoticeBoardViewCell {
    func setupSubView(){
        //, hashTagLabel, nicknameLabel, timeLabel
        [idLabel, titleLabel, hashTagLabel,nicknameLabel, timeLabel].forEach{
            addSubview($0)
        }
        
        idLabel.snp.makeConstraints{
            $0.leading.top.equalToSuperview().inset(8.0)
            $0.height.equalTo(50.0)
            $0.width.equalTo(50.0)
        }
        
        titleLabel.snp.makeConstraints{
            $0.leading.equalTo(idLabel.snp.trailing).offset(10.0)
            $0.trailing.equalToSuperview().inset(12.0)
            $0.top.equalToSuperview().inset(12.0)
            $0.height.equalTo(30)

        }

        hashTagLabel.snp.makeConstraints{
            $0.top.equalTo(titleLabel.snp.bottom).offset(4.0)
            $0.leading.equalTo(idLabel.snp.trailing).offset(10.0)
            $0.trailing.equalToSuperview()
            $0.bottom.equalTo(idLabel.snp.bottom)
        }

        nicknameLabel.snp.makeConstraints{
            $0.leading.bottom.equalToSuperview().inset(8.0)
            $0.top.equalTo(idLabel.snp.bottom).offset(5.0)
        }

        timeLabel.snp.makeConstraints{
            $0.leading.equalTo(nicknameLabel.snp.trailing).offset(15.0)
            $0.top.equalTo(idLabel.snp.bottom).offset(5.0)
            $0.bottom.equalToSuperview().inset(8.0)
            $0.trailing.equalToSuperview().inset(12.0)
        }
        
    }
}
