//
//  SearchBarCollectionViewCell.swift
//  Hankkijogbo
//
//  Created by 서은수 on 7/9/24.
//

import UIKit

final class SearchBarCollectionViewCell: BaseCollectionViewCell {
    
    // MARK: - Properties
    
    var hankkiNameString: String = "" {
        didSet {
            if hankkiNameString != "" {
                self.setupStyleForSet()
            } else {
                self.setupStyleForNotSet()
            }
        }
    }
    
    // MARK: - UI Components
    
    let searchBarButton: UIButton = UIButton()
    private let reportedNumberLabel: UILabel = UILabel()
    private let descriptionLabel: UILabel = UILabel()
    private let separatorView: UIView = UIView()
    
    // MARK: - Setup UI
    
    override func setupHierarchy() {
        contentView.addSubviews(
            reportedNumberLabel,
            searchBarButton,
            descriptionLabel,
            separatorView
        )
    }
    
    override func setupLayout() {
        reportedNumberLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().inset(26)
        }
        descriptionLabel.snp.makeConstraints {
            $0.centerY.equalTo(searchBarButton)
            $0.leading.equalTo(searchBarButton.snp.trailing).offset(6)
        }
        separatorView.snp.makeConstraints {
            $0.top.equalTo(searchBarButton.snp.bottom).offset(26)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(12)
        }
    }
    
    override func setupStyle() {
        reportedNumberLabel.do {
            $0.attributedText = UILabel.setupAttributedText(
                for: PretendardStyle.body4,
                withText: "52번째 제보예요",
                color: .hankkiRed
            )
        }
        descriptionLabel.do {
            $0.attributedText = UILabel.setupAttributedText(
                for: SuiteStyle.h3,
                withText: "을 제보할래요",
                color: .gray900
            )
        }
        separatorView.do {
            $0.backgroundColor = .gray100
        }
    }
    
    private func setupStyleForNotSet() {   
        searchBarButton.snp.removeConstraints()
        searchBarButton.snp.makeConstraints {
            $0.top.equalTo(reportedNumberLabel.snp.bottom).offset(5)
            $0.leading.equalToSuperview().inset(22)
            $0.width.equalTo(164)
            $0.height.equalTo(48)
        }
        searchBarButton.do {
            $0.backgroundColor = .gray100
            $0.layer.cornerRadius = 10
            $0.setImage(.icSearch, for: .normal)
            $0.setAttributedTitle(UILabel.setupAttributedText(
                for: PretendardStyle.body6,
                withText: "이름으로 식당 검색",
                color: .gray400
            ), for: .normal)
            $0.titleLabel?.lineBreakMode = .byTruncatingTail
            $0.titleLabel!.numberOfLines = 1
            $0.configuration = .plain()
            $0.configuration?.contentInsets = .init(top: 0, leading: 10, bottom: 0, trailing: 14)
            $0.configuration?.imagePadding = 4
        }
    }
    
    private func setupStyleForSet() {
        searchBarButton.snp.removeConstraints()
        searchBarButton.snp.makeConstraints {
            $0.top.equalTo(reportedNumberLabel.snp.bottom).offset(5)
            $0.leading.equalToSuperview().inset(22)
            $0.width.equalTo(227)
            $0.height.equalTo(48)
        }
        searchBarButton.do {
            $0.backgroundColor = .hankkiRedLight
            $0.layer.cornerRadius = 10
            $0.setAttributedTitle(UILabel.setupAttributedText(
                for: PretendardStyle.subtitle3,
                withText: hankkiNameString,
                color: .hankkiRed
            ), for: .normal)
            $0.setImage(.icArrowClose, for: .normal)
            $0.semanticContentAttribute = .forceRightToLeft
            $0.configuration = .plain()
            $0.configuration?.titleLineBreakMode = .byTruncatingTail
            $0.configuration?.contentInsets = .init(top: 0, leading: 14, bottom: 0, trailing: 14)
            $0.configuration?.imagePadding = 4
        }
    }
}
