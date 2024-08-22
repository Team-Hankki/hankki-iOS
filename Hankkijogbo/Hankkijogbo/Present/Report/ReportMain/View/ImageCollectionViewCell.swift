//
//  ImageCollectionViewCell.swift
//  Hankkijogbo
//
//  Created by 서은수 on 7/9/24.
//

import UIKit

final class ImageCollectionViewCell: BaseCollectionViewCell {

    // MARK: - UI Properties

    private let recommendGuideLabel: UILabel = UILabel()
    let selectedImageView: UIImageView = UIImageView()
    let changeImageButton: UIButton = UIButton()
    let imageXButton: UIButton = UIButton()

    // MARK: - Set UI

    override func setupHierarchy() {
        contentView.addSubviews(
            recommendGuideLabel,
            selectedImageView,
            changeImageButton,
            imageXButton
        )
    }

    override func setupLayout() {
        recommendGuideLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
        }
        selectedImageView.snp.makeConstraints {
            $0.top.equalTo(recommendGuideLabel.snp.bottom).offset(24)
            $0.leading.equalToSuperview()
            $0.size.equalTo(84)
        }
        changeImageButton.snp.makeConstraints {
            $0.leading.equalTo(selectedImageView.snp.trailing).offset(16)
            $0.centerY.equalTo(selectedImageView)
            $0.width.equalTo(57)
            $0.height.equalTo(37)
        }
        imageXButton.snp.makeConstraints {
            $0.top.equalTo(selectedImageView).offset(-11)
            $0.trailing.equalTo(selectedImageView).offset(11)
            $0.size.equalTo(30)
        }
    }

    override func setupStyle() {
        recommendGuideLabel.do {
            $0.attributedText = UILabel.setupAttributedText(
                for: PretendardStyle.body5,
                withText: StringLiterals.Report.addMenuSubtitle,
                color: .gray400
            )
        }
        selectedImageView.do {
            $0.layer.cornerRadius = 10
            $0.layer.masksToBounds = true
        }
        changeImageButton.do {
            $0.backgroundColor = .gray100
            $0.layer.cornerRadius = 8
            $0.setAttributedTitle(UILabel.setupAttributedText(
                for: PretendardStyle.body4,
                withText: StringLiterals.Report.changeImage,
                color: .gray700
            ), for: .normal)
        }
        imageXButton.do {
            $0.setImage(.btnCancle, for: .normal)
        }
    }
}
