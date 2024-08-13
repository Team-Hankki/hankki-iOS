//
//  HankkiReportOptionCollectionViewCell.swift
//  Hankkijogbo
//
//  Created by 서은수 on 7/15/24.
//

import UIKit

/// Cell의 클릭 상태에 따라 FooterView의 버튼 스타일을 변경하기 위한 delegate
protocol UpdateReportButtonStyleDelegate: AnyObject {
    func updateReportButtonStyle(isEnabled: Bool)
}

final class HankkiReportOptionCollectionViewCell: BaseCollectionViewCell {
    
    // MARK: - Properties
    
    var selectedOptionString: String? {
        didSet {
            print(selectedOptionString ?? "")
        }
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                if selectedOptionString != nil {
                    setupNormalStyle()
                    self.selectedOptionString = nil
                    delegate?.updateReportButtonStyle(isEnabled: false)
                } else {
                    setupSelectedStyle()
                    self.selectedOptionString = self.optionString
                    delegate?.updateReportButtonStyle(isEnabled: true)
                }
            } else {
                setupNormalStyle()
                self.selectedOptionString = nil
                delegate?.updateReportButtonStyle(isEnabled: false)
            }
        }
    }
    
    var optionString: String = "" {
        didSet {
            reportOptionLabel.text = optionString
        }
    }
    
    weak var delegate: UpdateReportButtonStyleDelegate?
    
    // MARK: - UI Components
    
    private var reportOptionLabel: UILabel = UILabel()
    private let radioButton: UIButton = UIButton()
    
    // MARK: - Life Cycle
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.setupNormalStyle()
    }
    
    // MARK: - Setup UI
    
    override func setupHierarchy() {
        addSubviews(reportOptionLabel, radioButton)
    }
    
    override func setupLayout() {
        reportOptionLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(20)
        }
        radioButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(20)
            $0.size.equalTo(24)
        }
    }
    
    override func setupStyle() {
        self.do {
            $0.makeRoundBorder(cornerRadius: 10, borderWidth: 1, borderColor: .gray200)
        }
        reportOptionLabel.do {
            $0.attributedText = UILabel.setupAttributedText(
                for: PretendardStyle.body4,
                color: .gray400
            )
        }
        radioButton.do {
            $0.setImage(.btnRadioNormal, for: .normal)
        }
    }
    
    func bindData(text: String) {
        self.optionString = text
    }
}

private extension HankkiReportOptionCollectionViewCell {
    
    func setupSelectedStyle() {
        self.layer.borderColor = UIColor.red500.cgColor
        self.radioButton.setImage(.btnRadioSelected, for: .normal)
        self.reportOptionLabel.textColor = .red500
    }
    
    func setupNormalStyle() {
        self.layer.borderColor = UIColor.gray200.cgColor
        self.radioButton.setImage(.btnRadioNormal, for: .normal)
        self.reportOptionLabel.textColor = .gray400
    }
}
