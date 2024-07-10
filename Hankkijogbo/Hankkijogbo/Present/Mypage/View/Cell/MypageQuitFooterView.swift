//
//  MypageQuitFooterView.swift
//  Hankkijogbo
//
//  Created by 심서현 on 7/9/24.
//

import UIKit

import Then
import SnapKit

final class MypageQuitFooterView: UICollectionReusableView {
    // MARK: - Properties
    
    var quitButtonHandler: (() -> Void)?
    
    // MARK: - UI Properties
    let buttonStackVIew: UIStackView = UIStackView()
    let buttonLabel: UILabel = UILabel()
    let buttonImage: UIImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupStyle()
        setupHierarchy()
        setupLayout()
        
        setupAction()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupStyle() {
        buttonStackVIew.do {
            $0.axis = .horizontal
            $0.alignment = .center
            $0.spacing = 2
            $0.layoutMargins = UIEdgeInsets(top: 14, left: 2, bottom: 14, right: 2)
            $0.isLayoutMarginsRelativeArrangement = true
        }
        
        buttonLabel.do {
            $0.attributedText = UILabel.setupAttributedText(
                for: PretendardStyle.body4,
                withText: "탈퇴하기",
                color: .gray400
            )
        }
        buttonImage.do {
            $0.backgroundColor = .gray400
        }
    }
    
    private func setupHierarchy() {
        self.addSubviews(buttonStackVIew)
        buttonStackVIew.addArrangedSubviews(buttonLabel, buttonImage)
    }
    
    private func setupLayout() {
        buttonStackVIew.snp.makeConstraints {
            $0.trailing.equalToSuperview()
        }
        buttonImage.snp.makeConstraints {
            $0.width.height.equalTo(16)
        }
    }
}

extension MypageQuitFooterView {
    @objc func quitButtonDidTap () {
        if let quitButtonHandler {
            quitButtonHandler()
        } else {
            return
        }
    }
    
    func setupAction () {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(quitButtonDidTap))
        buttonStackVIew.addGestureRecognizer(tapGesture)
    }
}