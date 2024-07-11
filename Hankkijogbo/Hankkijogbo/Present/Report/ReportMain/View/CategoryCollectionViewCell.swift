//
//  CategoryCollectionViewCell.swift
//  Hankkijogbo
//
//  Created by 서은수 on 7/9/24.
//

import UIKit

final class CategoryCollectionViewCell: BaseCollectionViewCell {
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                self.backgroundColor = .hankkiRedLight
                self.layer.borderColor = UIColor.hankkiRed.cgColor
                self.categoryLabel.textColor = .gray700
            } else {
                self.backgroundColor = .hankkiWhite
                self.layer.borderColor = UIColor.gray200.cgColor
                self.categoryLabel.textColor = .gray400
            }
        }
    }
    
    // MARK: - UI Properties
    
    let categoryImageView = UIImageView()
    let categoryLabel = UILabel()
    
    // MARK: - Set UI
    
    override func setupHierarchy() {
        addSubviews(categoryImageView, categoryLabel)
    }
    
    override func setupLayout() {
        categoryImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(8)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(28)
        }
        categoryLabel.snp.makeConstraints {
            $0.leading.equalTo(categoryImageView.snp.trailing).offset(2)
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(10)
        }
    }
    
    override func setupStyle() {
        self.do {
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 18
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.gray200.cgColor
        }
        categoryImageView.do {
            $0.image = .icHeart
        }
        categoryLabel.do {
            $0.textAlignment = .left
        }
    }
}

extension CategoryCollectionViewCell {
    func dataBind(_ text: String) {
        categoryLabel.do {
            $0.attributedText = UILabel.setupAttributedText(
                for: PretendardStyle.body4,
                withText: text,
                color: .gray400
            )
        }
    }
}
