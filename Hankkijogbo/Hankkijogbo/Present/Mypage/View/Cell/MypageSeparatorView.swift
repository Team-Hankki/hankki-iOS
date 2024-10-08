//
//  MypageQuitFooterView.swift
//  Hankkijogbo
//
//  Created by 심서현 on 10/8/24.
//

import AuthenticationServices
import UIKit

import Then
import SnapKit

final class MypageSeparatorView: BaseCollectionViewCell {
    private let separator: UIView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupStyle() {
        separator.backgroundColor = .gray50
    }
    
    override func setupHierarchy() {
        self.addSubview(separator)
    }
    
    override func setupLayout() {
        separator.snp.makeConstraints{
            $0.width.equalToSuperview()
            $0.height.equalTo(10)
        }
    }
}
