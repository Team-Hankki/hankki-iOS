//
//  MypageZipCollectionViewCell.swift
//  Hankkijogbo
//
//  Created by 심서현 on 7/9/24.
//

import UIKit

extension MypageHankkiCollectionViewCell {
    struct Model {
        let title: String
        let image: UIImage
    }
}

final class MypageHankkiCollectionViewCell: BaseCollectionViewCell {
    
    // MARK: - Properties
    
    // MARK: - UI Properties

    private let imageView: UIImageView = UIImageView()
    private let titleLabel: UILabel = UILabel()
    
    // MARK: - Set UI
    override func setupStyle() {
        self.do {
            $0.backgroundColor = .gray50
            $0.makeRoundBorder(cornerRadius: 12, borderWidth: 1, borderColor: .gray200)
        }
        
        titleLabel.do {
            $0.attributedText = UILabel.setupAttributedText(for: PretendardStyle.body3, withText: " ", color: .gray900)
        }
    }
    
    override func setupHierarchy() {
        self.addSubviews(imageView, titleLabel)
    }
    
    override func setupLayout() {
        imageView.snp.makeConstraints {
            $0.size.equalTo(31)
            $0.bottom.equalTo(self.snp.centerY)
            $0.centerX.equalToSuperview()
        }
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(self.snp.centerY).offset(9)
        }
    }
}

extension MypageHankkiCollectionViewCell {
    func dataBind(_ model: Model) {
        self.imageView.image = model.image
        self.titleLabel.text = model.title
    }
}
