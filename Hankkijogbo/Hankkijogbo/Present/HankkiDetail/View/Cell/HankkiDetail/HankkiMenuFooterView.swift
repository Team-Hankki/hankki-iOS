//
//  HankkiMenuFooterView.swift
//  Hankkijogbo
//
//  Created by 서은수 on 7/15/24.
//

import UIKit

final class HankkiMenuFooterView: BaseCollectionReusableView {
    
    // MARK: - Properties
    
    // MARK: - UI Components
    
    lazy var editButton: UIButton = UIButton()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupAddTarget()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup UI
    
    override func setupHierarchy() {
        addSubview(editButton)
    }
    
    override func setupLayout() {
        editButton.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0.38)
            $0.height.equalToSuperview()
        }
    }
    
    override func setupStyle() {
        editButton.do {
            $0.configuration = .plain()
            $0.configuration?.image = .icEditMenu
            $0.configuration?.imagePadding = 4
            if let attributedTitle = UILabel.setupAttributedText(
                for: PretendardStyle.body5,
                withText: StringLiterals.HankkiDetail.editMenu,
                color: .gray600
            ) {
                $0.setAttributedTitle(attributedTitle, for: .normal)
            }
            $0.configuration?.titleAlignment = .center
            $0.backgroundColor = .gray100
            $0.makeRoundCorners(radius: 8)
        }
    }
}

private extension HankkiMenuFooterView {
    
    func setupAddTarget() {
        editButton.addTarget(self, action: #selector(test), for: .touchUpInside)
    }
    
    @objc func test() {
        print("Edit")
    }
}
