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
        titleLabel.do {
            $0.attributedText = UILabel.setupAttributedText(for: SuiteStyle.body3, color: .gray600)
        }
    }
    
    override func setupHierarchy() {
        self.addSubviews(imageView, titleLabel)
    }
    
    override func setupLayout() {
        imageView.snp.makeConstraints {
            $0.size.equalTo(32)
            $0.centerX.equalToSuperview()
        }
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(self.snp.centerY).inset(2)
        }
    }
}

extension MypageHankkiCollectionViewCell {
    func dataBind(_ model: Model) {
        self.imageView.image = model.image
        self.titleLabel.text = model.title
    }
}
