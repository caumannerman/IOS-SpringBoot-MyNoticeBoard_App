//
//  CommentCollectionHeaderView.swift
//  IOS-SpringBoot-MyNoticeBoard_App
//
//  Created by 양준식 on 2022/04/21.
//

import UIKit
import SnapKit

final class CommentCollectionHeaderView: UICollectionReusableView{
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "댓글"
        label.font = .systemFont(ofSize: 14.0, weight: .semibold)
        label.textColor = .secondaryLabel
        
        return label
    }()
    
    private lazy var refreshButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "alarm"), for: .normal)
        
        return button
    }()
    
    func setupViews(){
        [titleLabel, refreshButton].forEach{ addSubview($0)}
        
        titleLabel.snp.makeConstraints{
            $0.leading.equalToSuperview().inset(12.0)
            $0.top.equalToSuperview().inset(12.0)
        }
        
        refreshButton.snp.makeConstraints{
            $0.trailing.equalToSuperview().inset(12.0)
            $0.top.equalToSuperview().inset(12.0)
        }
    }
}

