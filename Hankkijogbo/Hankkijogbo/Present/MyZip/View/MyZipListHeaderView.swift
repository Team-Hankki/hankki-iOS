//
//  MyZipListHeaderView.swift
//  Hankkijogbo
//
//  Created by 서은수 on 7/8/24.
//

import UIKit

final class MyZipListHeaderView: UICollectionReusableView {
        
    // MARK: - UI Properties
    
    private let headerLabel = UILabel()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupHierarchy()
        setupLayout()
        setupStyle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension MyZipListHeaderView {
    
    // MARK: - Private Func
    
    func setupHierarchy() {
        self.addSubview(headerLabel)
    }
    
    func setupLayout() {
        headerLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(17)
            $0.leading.equalToSuperview().inset(22)
        }
    }
    
    func setupStyle() {
        headerLabel.do {
            $0.attributedText = UILabel.setupAttributedText(
                for: PretendardStyle.caption1,
                withText: "족보 목록",
                color: .gray500
            )
        }
    }
}
