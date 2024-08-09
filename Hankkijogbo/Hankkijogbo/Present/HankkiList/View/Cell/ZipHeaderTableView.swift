//
//  ZipHeaderCollectionView.swift
//  Hankkijogbo
//
//  Created by 심서현 on 7/10/24.
//

import UIKit

extension ZipHeaderTableView {
    struct Model {
        let name: String
        let imageUrl: String
        let title: String
        let details: [String]
    }
}

final class ZipHeaderTableView: UITableViewHeaderFooterView {
    
    // MARK: - Properties
    
    var showAlert: ((String) -> Void)?
    
    // MARK: - UI Properties
    
    private let headerView = UIView()
    private let headerImageView = UIImageView()
    private let headerLabel = UILabel()
    
    private let tagStackView = UIStackView()
    
    private let nameStackView = UIStackView()
    private let nameImageView = UIImageView()
    private let nameLabel = UILabel()
    
    private let shareButton = UIButton()
    
    // MARK: - Life Cycle
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        setupStyle()
        setupHierarchy()
        setupLayout()
        setupAddTarget()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - setup UI
    
    private func setupStyle() {
        headerView.do {
            $0.backgroundColor = .hankkiRed
        }
        
        headerImageView.do {
            $0.image = .imgZipScreen1
            $0.isUserInteractionEnabled = true
        }
        
        headerLabel.do {
            $0.attributedText = UILabel.setupAttributedText(
                for: PretendardStyle.h2,
                withText: " ",
                color: .gray900
            )
        }
        
        tagStackView.do {
            $0.axis = .horizontal
            $0.spacing = 6
        }
        
        nameStackView.do {
            $0.axis = .horizontal
            $0.spacing = 8
            $0.alignment = .center
        }
        
        nameImageView.do {
            $0.image = .imgZipProfile
        }
        
        nameLabel.do {
            $0.attributedText = UILabel.setupAttributedText(for: PretendardStyle.body4, withText: " ", color: .gray600)
        }
        
        shareButton.do {
            var configuration = UIButton.Configuration.tinted()
            
            configuration.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 9, bottom: 9, trailing: 16)
            configuration.background.cornerRadius = 20
            configuration.background.backgroundColor = .gray800
        
            $0.configuration = configuration
            
            $0.setImage(.icShare, for: .normal)
            
            $0.setAttributedTitle(UILabel.setupAttributedText(for: PretendardStyle.body3,
                                                              withText: StringLiterals.HankkiList.Header.shareButton,
                                                              color: .hankkiWhite), for: .normal)
        }
    }
    
    private func setupHierarchy() {
        self.contentView.addSubview(headerView)
        headerView.addSubview(headerImageView)
        headerImageView.addSubviews(headerLabel, tagStackView, nameStackView, shareButton)
        nameStackView.addArrangedSubviews(nameImageView, nameLabel)
    }
    
    private func setupLayout() {
        headerView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
        }
        
        headerImageView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(22)
            $0.top.equalToSuperview()
            $0.height.equalTo(
                UIView.convertByAspectRatioHeight(UIScreen.getDeviceWidth() - 22 * 2,
                                                  width: 329, height: 231)
            )
            $0.bottom.equalToSuperview().inset(22)
        }
        
        headerLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(UIScreen.convertByWidthRatio(21))
            $0.top.equalToSuperview().inset(UIScreen.convertByHeightRatio(80))
        }
        
        tagStackView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(UIScreen.convertByWidthRatio(19))
            $0.top.equalTo(headerLabel.snp.bottom).offset(8)
        }
        
        nameStackView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(UIScreen.convertByWidthRatio(20))
            $0.bottom.equalToSuperview().inset(UIScreen.convertByHeightRatio(24))
        }
        
        nameImageView.snp.makeConstraints {
            $0.size.equalTo(26)
        }
        
        shareButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(UIScreen.convertByHeightRatio(24))
            $0.trailing.equalToSuperview().inset(UIScreen.convertByWidthRatio(20))
        }
    }
}

private extension ZipHeaderTableView {
    func setupAddTarget() {
        shareButton.addTarget(self, action: #selector(shareButtonDidTap), for: .touchUpInside)
    }
    
    @objc func shareButtonDidTap() {
        UIApplication.showAlert(titleText: StringLiterals.Alert.DevelopShare.title,
                                subText: StringLiterals.Alert.DevelopShare.sub,
                                primaryButtonText: StringLiterals.Alert.check)
    }
    
    func setupTagStackView(_ tagList: [String]) {
        tagList.forEach { createTagChipView($0) }
    }
    
    func createTagChipView(_ title: String) {
        let tagChipView = UIView()
        let tagLabel = UILabel()
    
        tagChipView.do {
            $0.backgroundColor = .gray100
            $0.layer.cornerRadius = 13
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.gray200.cgColor
        }
        
        tagLabel.do {
            $0.attributedText = UILabel.setupAttributedText(for: PretendardStyle.caption1,
                                                            withText: title,
                                                            color: .gray500)
        }
        
        tagChipView.addSubview(tagLabel)
        
        tagChipView.snp.makeConstraints {
            $0.height.equalTo(26)
        }
        
        tagLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(10)
        }
        
        tagStackView.addArrangedSubview(tagChipView)
    }
}

extension ZipHeaderTableView {
    func dataBind(_ data: Model?) {
        headerLabel.text = data?.title
        setupTagStackView(data?.details ?? [])
        nameLabel.text = data?.name
        nameImageView.setKFImage(url: data?.imageUrl)
    }
}
