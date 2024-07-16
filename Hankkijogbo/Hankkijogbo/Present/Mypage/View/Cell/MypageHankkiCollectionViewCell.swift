//
//  MypageZipCollectionViewCell.swift
//  Hankkijogbo
//
//  Created by 심서현 on 7/9/24.
//

import UIKit

final class MypageHankkiCollectionViewCell: BaseCollectionViewCell {
    
    // MARK: - Properties
    
    // MARK: - UI Properties

    private let imageView: UIImageView = UIImageView()
    private let titleLabel: UILabel = UILabel()
    
    // MARK: - Set UI
    override func setupStyle() {
        self.do {
            $0.backgroundColor = .gray50
            $0.layer.borderColor = UIColor.gray200.cgColor
            $0.layer.borderWidth = 1
            $0.makeRounded(radius: 12)
        }
        
        titleLabel.do {
            $0.attributedText = UILabel.setupAttributedText(for: PretendardStyle.body3, withText: "내가 제보한 식당", color: .gray900)
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
    func dataBind(_ data: DataStruct) {
        self.imageView.image = data.image
        self.titleLabel.text = data.title
    }
    
    struct DataStruct {
        let image: UIImage
        let title: String
    }
}
