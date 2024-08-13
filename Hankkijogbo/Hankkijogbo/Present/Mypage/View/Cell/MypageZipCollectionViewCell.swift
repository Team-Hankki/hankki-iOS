//
//  MypageZipCollectionViewCell.swift
//  Hankkijogbo
//
//  Created by 심서현 on 7/9/24.
//

import UIKit

final class MypageZipCollectionViewCell: BaseCollectionViewCell {
    
    // MARK: - UI Properties
    
    private let imageView: UIImageView = UIImageView()
    private let titleLabel: UILabel = UILabel()
    
    override func setupStyle() {
        self.do {
            $0.makeRoundBorder(cornerRadius: 12, borderWidth: 0, borderColor: .clear)
            $0.backgroundColor = .red500
        }
        
        titleLabel.do {
            $0.attributedText = UILabel.setupAttributedText(for: PretendardStyle.subtitle1,
                                                            withText: StringLiterals.Mypage.myZipList,
                                                            color: .hankkiWhite)
        }
        
        imageView.do {
            $0.layer.cornerRadius = 12
            $0.image = .imgMyPageMyZipBtn
        }
    }
    
    override func setupHierarchy() {
        self.addSubviews(imageView, titleLabel)
    }
    
    override func setupLayout() {
        imageView.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(32)
            $0.height.equalTo(72)
            $0.width.equalTo(120)
        }
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(30)
            $0.centerY.equalToSuperview()
        }
    }
}
