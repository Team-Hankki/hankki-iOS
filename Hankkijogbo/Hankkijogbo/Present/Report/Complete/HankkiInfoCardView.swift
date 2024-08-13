//
//  HankkiInfoCardView.swift
//  Hankkijogbo
//
//  Created by 서은수 on 7/13/24.
//

import UIKit

final class HankkiInfoCardView: BaseView {
    
    // MARK: - Properties
        
    var hankkiNameString: String = "" {
        didSet {
            self.hankkiNameLabel.attributedText = UILabel.setupAttributedText(
                for: PretendardStyle.body1,
                withText: hankkiNameString,
                color: .gray850
            )
        }
    }
    var addToMyZipListString: String = StringLiterals.MyZip.addToMyZip {
        didSet {
            // TODO: - 버튼은 텍스트 하나 바꾸려면 이렇게 다 다시해야 됨..ㅎ 우리 대안책을 나중에 찾아보아요...
            self.addToMyZipListButton.setAttributedTitle(UILabel.setupAttributedText(
                for: PretendardStyle.body2,
                withText: addToMyZipListString,
                color: .red500
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
                withText: StringLiterals.Report.hankkiReportedByMe,
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
                color: .red500
            ), for: .normal)
            $0.setImage(.icAddRed, for: .normal)
            $0.configuration = .plain()
            $0.configuration?.imagePadding = 2
        }
    }
}
