//
//  SearchCollectionViewCell.swift
//  Hankkijogbo
//
//  Created by 서은수 on 7/11/24.
//

import UIKit

protocol ChangeBottomButtonDelegate: AnyObject {
    func changeBottomButtonView(_ isDone: Bool)
}

final class SearchCollectionViewCell: BaseCollectionViewCell {
    
    // MARK: - Properties
    
    var model: GetSearchedLocation?
    weak var delegate: SearchViewController?
    
    var selectedHankkiNameString: String? {
        didSet {
            delegate?.changeBottomButtonView(model != nil)
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
    
    let hankkiNameLabel: UILabel = UILabel()
    let addressLabel: UILabel = UILabel()
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
            $0.trailing.equalTo(checkButton.snp.leading).offset(-16)
        }
        
        addressLabel.snp.makeConstraints {
            $0.top.equalTo(hankkiNameLabel.snp.bottom).offset(4)
            $0.leading.equalTo(hankkiNameLabel)
            $0.trailing.equalTo(checkButton.snp.leading).offset(-16)
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
                color: .gray850
            )
            $0.lineBreakMode = .byTruncatingTail
        }
        
        addressLabel.do {
            $0.attributedText = UILabel.setupAttributedText(
                for: PretendardStyle.body5,
                color: .gray400
            )
            $0.lineBreakMode = .byTruncatingTail
        }
        
        separatorView.do {
            $0.backgroundColor = .gray100
        }
    }
    
    func bindLocationData(model: GetSearchedLocation) {
        self.model = model
        self.hankkiNameLabel.text = model.name
        self.addressLabel.text = model.address
    }
}
