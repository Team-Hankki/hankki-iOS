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
    
    override func setupStyle() {
        imageView.do {
            $0.layer.cornerRadius = 12
            $0.backgroundColor = .gray400
        }
    }
    
    override func setupHierarchy() {
        self.addSubview(imageView)
    }
    
    override func setupLayout() {
        imageView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo(72)
        }
    }
}
