//
//  ZipCollectionViewCell.swift
//  Hankkijogbo
//
//  Created by 심서현 on 7/10/24.
//

import UIKit

final class HankkiCollectionViewCell: BaseCollectionViewCell {
    // MARK: - Properties
    // MARK: - UI Properties
    
    private let cellStackView = UIStackView()
    
    private let imageView = UIImageView()
    private let infoStackView = UIStackView()
    
    private let tagChipView = UIView()
    private let tagLabel = UILabel()
    
    private let titleLabel = UILabel()
    
    private let subInfoStackView = UIStackView()
    private let subInfoImageView = UIImageView()
    
    private let line = UIView()

    // MARK: - Life Cycle
    // MARK: - setup UI
    
    override func setupStyle() {
        cellStackView.do {
            $0.backgroundColor = .hankkiWhite
            $0.axis = .horizontal
            $0.spacing = 12
            $0.layoutMargins = UIEdgeInsets(top: 16, left: 22, bottom: 16, right: 22)
            $0.isLayoutMarginsRelativeArrangement = true
        }
        
        imageView.do {
            $0.layer.cornerRadius = 8
            $0.backgroundColor = .red
        }
        
        infoStackView.do {
            $0.axis = .vertical
            $0.spacing = 2
            $0.alignment = .leading
        }
        
        tagChipView.do {
            $0.layer.cornerRadius = 10
            $0.backgroundColor = .hankkiRedLight
        }
        
        tagLabel.do {
            $0.attributedText = UILabel.setupAttributedText(for: PretendardStyle.caption2, withText: "#한식", color: .hankkiRed)
        }
        titleLabel.do {
            $0.attributedText = UILabel.setupAttributedText(for: SuiteStyle.subtitle, withText: "한끼네 한정식", color: .gray900)
        }
        
        subInfoStackView.do {
            $0.axis = .horizontal
            $0.spacing = 0
        }
        
        subInfoImageView.do {
            $0.backgroundColor = .red
        }
        
        line.do {
            $0.backgroundColor = .gray200
        }
    }
    
    override func setupHierarchy() {
        self.addSubviews(cellStackView, line)
        cellStackView.addArrangedSubviews(imageView, infoStackView)
        infoStackView.addArrangedSubviews(tagChipView, titleLabel, subInfoStackView)
        tagChipView.addSubview(tagLabel)
    }
    
    override func setupLayout() {
        createSubInfoView("7,500원")
        subInfoStackView.addArrangedSubview(subInfoImageView)
        createSubInfoView("3wretqw")
        
        cellStackView.snp.makeConstraints {
            $0.width.equalToSuperview()
        }
        
        imageView.snp.makeConstraints {
            $0.size.equalTo(72)
        }
        
        tagLabel.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(8)
            $0.verticalEdges.equalToSuperview().inset(1.5)
        }
        
        subInfoImageView.snp.makeConstraints {
            $0.width.equalTo(10)
            $0.height.equalTo(18)
        }
        
        line.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.height.equalTo(1)
            $0.horizontalEdges.equalToSuperview().inset(22)
        }
    }
}

extension HankkiCollectionViewCell {
    func dataBind() {
    }
}

private extension HankkiCollectionViewCell {
    func createSubInfoView(_ text: String) {
        let subInfoView = UIView()
        let subInfoImageView = UIImageView()
        let subInfoLabel = UILabel()
        
        subInfoImageView.do {
            $0.backgroundColor = .red
        }
        
        subInfoLabel.do {
            $0.attributedText = UILabel.setupAttributedText(for: PretendardStyle.button, withText: text, color: .gray500)
        }
        
        subInfoStackView.addArrangedSubview(subInfoView)
        subInfoView.addSubviews(subInfoImageView, subInfoLabel)
        
        subInfoImageView.snp.makeConstraints {
            $0.size.equalTo(16)
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview()
        }
        
        subInfoLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(18)
            $0.trailing.top.bottom.equalToSuperview()
        }
    }
    
}
