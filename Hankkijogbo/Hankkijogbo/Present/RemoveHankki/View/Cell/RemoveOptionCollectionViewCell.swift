//
//  RemoveOptionCollectionViewCell.swift
//  Hankkijogbo
//
//  Created by 서은수 on 7/15/24.
//

import UIKit

/// Cell의 클릭 상태에 따라 제보하기 버튼 스타일을 변경하기 위한 delegate
protocol UpdateReportButtonStyleDelegate: AnyObject {
    func updateReportButtonStyle(isEnabled: Bool)
}

final class RemoveOptionCollectionViewCell: BaseCollectionViewCell {
    
    // MARK: - Properties
    
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
    
    weak var delegate: UpdateReportButtonStyleDelegate?
    
    private var selectedOptionString: String?
    private var optionString: String = "" {
        didSet {
            reportOptionLabel.text = optionString
        }
    }
    
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
            $0.leading.equalToSuperview().inset(22)
        }
        
        radioButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(22)
            $0.size.equalTo(24)
        }
    }
    
    override func setupStyle() {
        self.do {
            $0.backgroundColor = .hankkiWhite
        }
        
        reportOptionLabel.do {
            $0.font = .setupPretendardStyle(of: .body6)
            $0.textColor = .gray500
        }
        
        radioButton.do {
            $0.setImage(.btnRadioNormal, for: .normal)
            $0.isUserInteractionEnabled = false
        }
    }
    
    func bindData(text: String) {
        self.optionString = text
    }
}

// MARK: - Private Func

private extension RemoveOptionCollectionViewCell {
    
    func setupSelectedStyle() {
        backgroundColor = .red100
        radioButton.setImage(.btnRadioSelected, for: .normal)
        reportOptionLabel.font = .setupPretendardStyle(of: .body5)
        reportOptionLabel.textColor = .red500
    }
    
    func setupNormalStyle() {
        backgroundColor = .hankkiWhite
        radioButton.setImage(.btnRadioNormal, for: .normal)
        reportOptionLabel.font = .setupPretendardStyle(of: .body6)
        reportOptionLabel.textColor = .gray500
    }
}
