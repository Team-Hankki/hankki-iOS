//
//  MypageZipCollectionViewCell.swift
//  Hankkijogbo
//
//  Created by 심서현 on 7/9/24.
//

import UIKit
extension MypageOptionCollectionViewCell {
    struct Model {
        var title: String
    }
}

final class MypageOptionCollectionViewCell: BaseCollectionViewCell {

    // MARK: - UI Properties

    private let iconImageView: UIImageView = UIImageView()
    private let titleLabel: UILabel = UILabel()
    private let lineView: UIView = UIView()
    
    override func setupStyle() {
        iconImageView.do {
            $0.image = .icArrowRight
        }
        
        titleLabel.do {
            $0.attributedText = UILabel.setupAttributedText(
                for: PretendardStyle.body3,
                withText: " ",
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
            $0.size.equalTo(24)
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
    func dataBind(_ model: Model) {
        titleLabel.text = model.title
    }
}
