//
//  HankkiInfoCardView.swift
//  Hankkijogbo
//
//  Created by 서은수 on 7/13/24.
//

import UIKit

final class HankkiInfoCardView: BaseView {
    
    // MARK: - Properties
        
    var reportedGuideString: String = "내가 등록한 식당"
    var hankkiNameString: String = "고봉김밥집 1호점" {
        didSet {
            self.hankkiNameLabel.attributedText = UILabel.setupAttributedText(
                for: PretendardStyle.body1,
                withText: hankkiNameString,
                color: .gray850
            )
        }
    }
    var addToMyZipListString: String = "내 족보에 추가" {
        didSet {
            self.addToMyZipListButton.setAttributedTitle(UILabel.setupAttributedText(
                for: PretendardStyle.body2,
                withText: addToMyZipListString,
                color: .hankkiRed
            ), for: .normal)
        }
    }
    
    // MARK: - UI Components
    
    private let reportedGuideLabel: UILabel = UILabel()
    private let hankkiNameLabel: UILabel = UILabel()
    let addToMyZipListButton: UIButton = UIButton()
    
    // MARK: - Life Cycle
    
    init(hankkiNameString: String) {
        self.hankkiNameString = hankkiNameString
        super.init(frame: .zero)
        
        addShadow(color: .black, alpha: 0.04, y: 4, blur: 7)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup UI
    
    override func setupHierarchy() {
        addSubviews(
            reportedGuideLabel,
            hankkiNameLabel,
            addToMyZipListButton
        )
    }
    
    override func setupLayout() {
        reportedGuideLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16)
            $0.leading.equalToSuperview().inset(18)
        }
        hankkiNameLabel.snp.makeConstraints {
            $0.top.equalTo(reportedGuideLabel.snp.bottom)
            $0.leading.equalTo(reportedGuideLabel)
        }
        addToMyZipListButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(20)
        }
    }
    
    override func setupStyle() {
        self.do {
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 14
        }
        reportedGuideLabel.do {
            $0.attributedText = UILabel.setupAttributedText(
                for: PretendardStyle.caption1,
                withText: reportedGuideString,
                color: .gray500
            )
        }
        hankkiNameLabel.do {
            $0.attributedText = UILabel.setupAttributedText(
                for: PretendardStyle.body1,
                withText: hankkiNameString,
                color: .gray850
            )
        }
        addToMyZipListButton.do {
            $0.setAttributedTitle(UILabel.setupAttributedText(
                for: PretendardStyle.body2,
                withText: addToMyZipListString,
                color: .hankkiRed
            ), for: .normal)
            $0.setImage(.icAddRed, for: .normal)
            $0.configuration = .plain()
            $0.configuration?.imagePadding = 2
        }
    }
}
