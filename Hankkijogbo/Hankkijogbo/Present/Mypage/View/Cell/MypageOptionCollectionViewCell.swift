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
    
    override func setupStyle() {
        iconImageView.do {
            $0.image = .icArrowRight
        }
        
        titleLabel.do {
            $0.attributedText = UILabel.setupAttributedText(
                for: PretendardStyle.body6,
                color: .gray600
            )
        }
    }
    
    override func setupHierarchy() {
        self.addSubviews(titleLabel, iconImageView)
    }
    
    override func setupLayout() {
        iconImageView.snp.makeConstraints {
            $0.size.equalTo(24)
            $0.trailing.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
    }
}

extension MypageOptionCollectionViewCell {
    func dataBind(_ model: Model) {
        titleLabel.text = model.title
    }
}
