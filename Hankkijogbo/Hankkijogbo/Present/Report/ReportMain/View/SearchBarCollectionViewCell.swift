//
//  SearchBarCollectionViewCell.swift
//  Hankkijogbo
//
//  Created by 서은수 on 7/9/24.
//

import UIKit

final class SearchBarCollectionViewCell: BaseCollectionViewCell {
    
    // MARK: - Properties
    
    private var hankkiNameMaxLength: Int = 12
    var hankkiNameString: String? {
        didSet {
            if let hankkiNameString = hankkiNameString {
                if hankkiNameString != "" {
                    self.setupStyleForSet()
                } else {
                    self.setupStyleForNotSet()
                }
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        setupStyleForNotSet()
    }
    
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
        searchBarButton.snp.makeConstraints {
            $0.top.equalTo(reportedNumberLabel.snp.bottom).offset(5)
            $0.leading.equalToSuperview().inset(22)
            $0.height.equalTo(48)
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
                for: PretendardStyle.body5,
                color: .red500
            )
        }
        descriptionLabel.do {
            $0.attributedText = UILabel.setupAttributedText(
                for: SuiteStyle.h3,
                withText: StringLiterals.Report.reportThisLocation,
                color: .gray900
            )
        }
        separatorView.do {
            $0.backgroundColor = .gray100
        }
    }
}

private extension SearchBarCollectionViewCell {
    
    // MARK: - Private Func
    
    func setupStyleForNotSet() {
        searchBarButton.do {
            $0.backgroundColor = .gray100
            $0.layer.cornerRadius = 10
            $0.setImage(.icSearch, for: .normal)
            $0.setAttributedTitle(UILabel.setupAttributedText(
                for: PretendardStyle.body2,
                withText: StringLiterals.Report.searchFirstPlaceHolder,
                color: .gray400
            ), for: .normal)
            $0.configuration = .plain()
            $0.configuration?.contentInsets = .init(top: 0, leading: 10, bottom: 0, trailing: 14)
            $0.configuration?.imagePadding = 4
        }
    }
    
    func setupStyleForSet() {
        searchBarButton.do {
            $0.backgroundColor = .red100
            $0.layer.cornerRadius = 10
            $0.setAttributedTitle(UILabel.setupAttributedText(
                for: PretendardStyle.subtitle3,
                withText: hankkiNameString ?? StringLiterals.Report.searchFirstPlaceHolder,
                color: .red500
            ), for: .normal)
            $0.setImage(.icArrowClose, for: .normal)
            $0.semanticContentAttribute = .forceRightToLeft
            $0.configuration = .plain()
            $0.configuration?.contentInsets = .init(top: 0, leading: 14, bottom: 0, trailing: 14)
            $0.configuration?.imagePadding = 4
        }
        setupSearchBarButtonTitle()
    }
    
    func setupSearchBarButtonTitle() {
        guard let hankkiNameString = hankkiNameString else { return }
        let title = hankkiNameString.count > hankkiNameMaxLength
        ? hankkiNameString.getTruncatedTailString(limit: hankkiNameMaxLength)
        : hankkiNameString
        
        let attributedTitle = UILabel.setupAttributedText(
            for: PretendardStyle.subtitle3,
            withText: title,
            color: .red500
        )
        
        searchBarButton.setAttributedTitle(attributedTitle, for: .normal)
    }
}

extension SearchBarCollectionViewCell {
    func bindGuideText(text: String) {
        reportedNumberLabel.text = text
    }
}
