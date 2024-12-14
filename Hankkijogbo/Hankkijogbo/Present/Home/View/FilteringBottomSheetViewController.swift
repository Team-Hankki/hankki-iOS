//
//  FilteringBottomSheetViewController.swift
//  Hankkijogbo
//
//  Created by Gahyun Kim on 12/13/24.
//

import UIKit

final class FilteringBottomSheetViewController: BaseViewController {
    
    // MARK: - Properties
    
    private var defaultHeight: CGFloat = 266
    
    
    // MARK: - Components
    
    private let priceTitleLabel: UILabel = UILabel()
    private let entireChipButton: UIButton = UIButton()
    private let less6000ChipButton: UIButton = UIButton()
    private let more6000ChipButton: UIButton = UIButton()
    private let priceChipStackView: UIStackView = UIStackView()
    
    private let sortTitleLabel: UILabel = UILabel()
    private let latestChipButton: UIButton = UIButton()
    private let lowestChipButton: UIButton = UIButton()
    private let recommendChipButton: UIButton = UIButton()
    private let sortChipStackView: UIStackView = UIStackView()
    
    private let applyButton: UIButton = UIButton()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
    
    override func setupHierarchy() {
        view.addSubviews(priceTitleLabel, priceChipStackView, sortTitleLabel, sortChipStackView, applyButton)
        
        priceChipStackView.addArrangedSubviews(entireChipButton, less6000ChipButton, more6000ChipButton)
        
        sortChipStackView.addArrangedSubviews(latestChipButton, lowestChipButton, recommendChipButton)
    }
    
    override func setupLayout() {
        priceTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(28)
            $0.leading.equalToSuperview().inset(22)
        }
        
        priceChipStackView.snp.makeConstraints {
            $0.top.equalTo(priceTitleLabel.snp.bottom).offset(8)
            $0.leading.equalToSuperview().inset(22)
        }
        
        sortTitleLabel.snp.makeConstraints {
            $0.top.equalTo(priceTitleLabel.snp.bottom).offset(24)
            $0.leading.equalToSuperview().inset(22)
        }
        
        sortChipStackView.snp.makeConstraints {
            $0.top.equalTo(sortTitleLabel.snp.bottom).offset(8)
            $0.leading.equalToSuperview().inset(22)
        }
        
        applyButton.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.height.equalTo(68)
            $0.width.equalTo(UIScreen.main.bounds.width)
        }
    }
    
    override func setupStyle() {
        [priceTitleLabel, sortTitleLabel].forEach {
            $0.do {
                $0.font = .setupPretendardStyle(of: .body4)
                $0.textColor = .gray850
            }
        }
        
        [entireChipButton, less6000ChipButton, more6000ChipButton, latestChipButton, lowestChipButton, recommendChipButton].forEach {
            defaultButtonStyle(button: $0)
        }
        
        [priceChipStackView, sortChipStackView].forEach {
            $0.do {
                $0.axis = .horizontal
                $0.spacing = 8
                $0.isUserInteractionEnabled = true
            }
        }
        
        applyButton.do {
            $0.setTitle("적용", for: .normal)
            $0.titleLabel?.font = .setupPretendardStyle(of: .body4)
            $0.setTitleColor(.gray800, for: .normal)
            $0.backgroundColor = .hankkiWhite
            $0.isEnabled = true
        }
    }
}


private extension FilteringBottomSheetViewController {
    func defaultButtonStyle(button: UIButton) {
        button.do {
            $0.makeRoundBorder(cornerRadius: 16, borderWidth: 1, borderColor: .gray300)
            $0.titleLabel?.font = .setupPretendardStyle(of: .caption1)
            $0.titleLabel?.textColor = .gray600
        }
    }
    
    func selectedButtonStyle(button: UIButton) {
        button.do {
            $0.makeRoundBorder(cornerRadius: 16, borderWidth: 1, borderColor: .red500)
            $0.titleLabel?.font = .setupPretendardStyle(of: .caption1)
            $0.titleLabel?.textColor = .red500
            $0.backgroundColor = .red100
        }
    }
}
