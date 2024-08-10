//
//  SelectImageCollectionViewCell.swift
//  Hankkijogbo
//
//  Created by 서은수 on 7/9/24.
//

import UIKit

final class SelectImageCollectionViewCell: BaseCollectionViewCell {
    
    // MARK: - UI Properties
    
    private let recommendGuideLabel: UILabel = UILabel()
    let selectImageButton: UIButton = UIButton()
        
    // MARK: - Set UI
    
    override func setupHierarchy() {
        contentView.addSubviews(recommendGuideLabel, selectImageButton)
    }
    
    override func setupLayout() {
        recommendGuideLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
        }
        selectImageButton.snp.makeConstraints {
            $0.top.equalTo(recommendGuideLabel.snp.bottom).offset(32)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(58)
        }
    }
    
    override func setupStyle() {
        recommendGuideLabel.do {
            $0.attributedText = UILabel.setupAttributedText(
                for: PretendardStyle.body4,
                withText: StringLiterals.Report.addMenuSubtitle,
                color: .gray400
            )
        }
        selectImageButton.do {
            $0.backgroundColor = .gray100
            $0.makeRoundBorder(cornerRadius: 10, borderWidth: 1, borderColor: .gray200)
            $0.setImage(.icAddPhoto, for: .normal)
            $0.setAttributedTitle(UILabel.setupAttributedText(
                for: PretendardStyle.body3,
                withText: StringLiterals.Report.addImage,
                color: .gray500
            ), for: .normal)
            $0.configuration = .plain()
            $0.configuration?.titleAlignment = .center
            $0.configuration?.imagePadding = 6
        }
    }
}
