//
//  MypageZipCollectionViewCell.swift
//  Hankkijogbo
//
//  Created by 심서현 on 7/9/24.
//

import UIKit

struct MypageOptionCollectionViewCellStruct {
    var title: String
    var onTab: () -> Void
}

final class MypageOptionCollectionViewCell: BaseCollectionViewCell {
    var onTab: (() -> Void)?
    
    // MARK: - UI Properties

    let iconImageView: UIImageView = UIImageView()
    let titleLabel: UILabel = UILabel()
    let lineView: UIView = UIView()
    
    override func setupStyle() {
        iconImageView.do {
            $0.backgroundColor = .gray500
        }
        
        titleLabel.do {
            $0.attributedText = UILabel.setupAttributedText(
                for: PretendardStyle.body3,
                withText: "",
                color: .gray900
            )
        }
        
        lineView.do {
            $0.backgroundColor = .gray200
        }
    }
    
    override func setupHierarchy() {
        self.addSubviews(titleLabel, iconImageView, lineView)
    }
    
    override func setupLayout() {
        iconImageView.snp.makeConstraints {
            $0.width.height.equalTo(24)
            $0.trailing.equalToSuperview()
            $0.top.equalToSuperview().inset(18)
        }
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.top.equalToSuperview().inset(18)
        }
        
        lineView.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalTo(1)
        }
    }
}

extension MypageOptionCollectionViewCell {
    func dataBind(data: MypageOptionCollectionViewCellStruct) {
        onTab = data.onTab
        titleLabel.text = data.title
    }
}
