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
    
    func setup(comment: Comment){
       
        contentView.layer.cornerRadius = 16.0
        contentView.layer.borderWidth = 1.5
        contentView.layer.borderColor = UIColor.lightGray.cgColor
        setupSubViews()
        nickNameLabel.text = comment.userNickName
        timeLabel.text = comment.time
        contentLabel.text = comment.content
    }
    
}

private extension CommentCollectionViewCell{
    func setupSubViews(){
        [nickNameLabel, timeLabel, contentLabel].forEach{
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
    }
}
