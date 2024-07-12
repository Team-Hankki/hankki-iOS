//
//  MyZipListCollectionViewCell.swift
//  Hankkijogbo
//
//  Created by 서은수 on 7/7/24.
//

import UIKit

final class MyZipListCollectionViewCell: BaseCollectionViewCell {
        
    // MARK: - UI Properties
    
    private let thumbnailImageView = UIImageView()
    private let zipTitleLabel = UILabel()
    private let firstHashtagLabel = UILabel()
    private let secondHashtagLabel = UILabel()
    private let addZipButton = UIButton()
    
    // MARK: - Set UI
    
    override func setupHierarchy() {
        contentView.addSubviews(
            thumbnailImageView,
            zipTitleLabel,
            firstHashtagLabel,
            secondHashtagLabel,
            addZipButton
        )
    }
    
    override func setupLayout() {
        thumbnailImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(22)
            $0.top.equalToSuperview().inset(6)
            $0.width.height.equalTo(56)
        }
        zipTitleLabel.snp.makeConstraints {
            $0.leading.equalTo(thumbnailImageView.snp.trailing).offset(12)
            $0.top.equalTo(thumbnailImageView).offset(5.5)
        }
        firstHashtagLabel.snp.makeConstraints {
            $0.leading.equalTo(zipTitleLabel)
            $0.top.equalTo(zipTitleLabel.snp.bottom).offset(6)
        }
        secondHashtagLabel.snp.makeConstraints {
            $0.leading.equalTo(firstHashtagLabel.snp.trailing).offset(4)
            $0.top.equalTo(firstHashtagLabel)
        }
        addZipButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(37)
            $0.centerY.equalToSuperview()
        }
    }
    
    override func setupStyle() {
        thumbnailImageView.do {
            $0.layer.cornerRadius = 10
            $0.backgroundColor = .gray
        }
        zipTitleLabel.do {
            $0.attributedText = UILabel.setupAttributedText(
                for: PretendardStyle.body2,
                withText: "학교 5년째 다니는 화석의 추천",
                color: .gray800
            )
        }
        firstHashtagLabel.do {
            $0.attributedText = UILabel.setupAttributedText(
                for: PretendardStyle.button,
                withText: "#미친가성비",
                color: .gray400
            )
        }
        secondHashtagLabel.do {
            $0.attributedText = UILabel.setupAttributedText(
                for: PretendardStyle.button,
                withText: "#꼭가보세요",
                color: .gray400
            )
        }
        addZipButton.do {
            $0.setImage(.btnAddLined, for: .normal)
        }
    }
}
