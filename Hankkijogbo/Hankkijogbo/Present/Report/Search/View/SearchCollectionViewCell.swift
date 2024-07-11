//
//  SearchCollectionViewCell.swift
//  Hankkijogbo
//
//  Created by 서은수 on 7/11/24.
//

import UIKit

final class SearchCollectionViewCell: BaseCollectionViewCell {
    
    // MARK: - Properties
    
    var selectedHankkiNameString: String? {
        didSet {
            print(selectedHankkiNameString ?? "")
        }
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                if selectedHankkiNameString != nil {
                    hankkiNameLabel.textColor = .gray850
                    checkButton.setImage(nil, for: .normal)
                    self.backgroundColor = .hankkiWhite
                    self.selectedHankkiNameString = nil
                } else {
                    hankkiNameLabel.textColor = .hankkiRed
                    checkButton.setImage(.btnCheckFilled, for: .normal)
                    self.backgroundColor = .hankkiRedLight
                    self.selectedHankkiNameString = hankkiNameLabel.text
                }
            } else {
                hankkiNameLabel.textColor = .gray850
                checkButton.setImage(nil, for: .normal)
                self.backgroundColor = .hankkiWhite
                self.selectedHankkiNameString = nil
            }
        }
    }

    // MARK: - UI Properties
    
    private let hankkiNameLabel: UILabel = UILabel()
    private let addressLabel: UILabel = UILabel()
    private let checkButton: UIButton = UIButton()
    private let separatorView: UIView = UIView()
    
    // MARK: - Setup UI
    
    override func setupHierarchy() {
        addSubviews(
            hankkiNameLabel,
            addressLabel,
            checkButton,
            separatorView
        )
    }
    
    override func setupLayout() {
        hankkiNameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(24)
            $0.leading.equalToSuperview().inset(22)
        }
        
        addressLabel.snp.makeConstraints {
            $0.top.equalTo(hankkiNameLabel.snp.bottom).offset(4)
            $0.leading.equalTo(hankkiNameLabel)
        }
        
        checkButton.snp.makeConstraints {
            $0.size.equalTo(24)
            $0.trailing.equalToSuperview().inset(22)
            $0.centerY.equalToSuperview()
        }
        
        separatorView.snp.makeConstraints {
            $0.horizontalEdges.bottom.equalToSuperview()
            $0.height.equalTo(1)
        }
    }
    
    override func setupStyle() {
        hankkiNameLabel.do {
            $0.attributedText = UILabel.setupAttributedText(
                for: SuiteStyle.subtitle,
                withText: "고동밥집 1호점",
                color: .gray850
            )
        }
        
        addressLabel.do {
            $0.attributedText = UILabel.setupAttributedText(
                for: PretendardStyle.body5,
                withText: "서울특별시 마포구 갈매기 고양이처럼 울음",
                color: .gray400
            )
        }
        
        separatorView.do {
            $0.backgroundColor = .gray100
        }
    }
}
