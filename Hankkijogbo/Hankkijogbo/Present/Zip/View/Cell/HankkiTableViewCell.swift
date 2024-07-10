//
//  ZipCollectionViewCell.swift
//  Hankkijogbo
//
//  Created by 심서현 on 7/10/24.
//

import UIKit

final class HankkiTableViewCell: BaseTableViewCell {
    
    // MARK: - Properties
    
    // MARK: - UI Properties
    
    private let cellStackView = UIStackView()
    
    private let thumbnailView = UIImageView()
    private let infoStackView = UIStackView()
    
    private let tagChipView = UIView()
    private let tagLabel = UILabel()
    
    private let titleLabel = UILabel()
    
    private let subInfoStackView = UIStackView()
    private let subInfoImageView = UIImageView()
    
    private let line = UIView()
    
    private let heartButton = UIImageView()

    // MARK: - Life Cycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupSubInfoStackView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - setup UI
    
    override func setupStyle() {
        cellStackView.do {
            $0.backgroundColor = .hankkiWhite
            $0.axis = .horizontal
            $0.spacing = 12
            $0.layoutMargins = UIEdgeInsets(top: 16, left: 22, bottom: 16, right: 22)
            $0.isLayoutMarginsRelativeArrangement = true
            $0.alignment = .center
        }
        
        thumbnailView.do {
            $0.layer.cornerRadius = 8
            $0.backgroundColor = .red
        }
        
        infoStackView.do {
            $0.axis = .vertical
            $0.spacing = 2
            $0.alignment = .leading
        }
        
        tagChipView.do {
            $0.layer.cornerRadius = 10
            $0.backgroundColor = .hankkiRedLight
        }
        
        tagLabel.do {
            $0.attributedText = UILabel.setupAttributedText(for: PretendardStyle.caption2, withText: "#한식", color: .hankkiRed)
        }
        titleLabel.do {
            $0.attributedText = UILabel.setupAttributedText(for: SuiteStyle.subtitle, withText: "한끼네 한정식", color: .gray900)
        }
        
        subInfoStackView.do {
            $0.axis = .horizontal
            $0.spacing = 0
        }
        
        subInfoImageView.do {
            $0.backgroundColor = .gray100
        }
        
        line.do {
            $0.backgroundColor = .gray200
        }
        
        heartButton.do {
            $0.backgroundColor = .yellow
        }
    }
    
    override func setupHierarchy() {
        self.addSubviews(cellStackView, line)
        cellStackView.addArrangedSubviews(thumbnailView, infoStackView, heartButton)
        infoStackView.addArrangedSubviews(tagChipView, titleLabel, subInfoStackView)
        tagChipView.addSubview(tagLabel)
    }
    
    override func setupLayout() {
        cellStackView.snp.makeConstraints {
            $0.width.equalToSuperview()
        }
        
        thumbnailView.snp.makeConstraints {
            $0.size.equalTo(72)
        }
        
        tagChipView.snp.makeConstraints {
            $0.height.equalTo(20)
        }
        
        tagLabel.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(8)
            $0.centerY.equalToSuperview()
        }
        
        subInfoImageView.snp.makeConstraints {
            $0.width.equalTo(10)
            $0.height.equalTo(18)
        }
        
        line.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.height.equalTo(1)
            $0.horizontalEdges.equalToSuperview().inset(22)
        }
        
        heartButton.snp.makeConstraints {
            $0.size.equalTo(38)
        }
    }
}

extension HankkiTableViewCell {
    func dataBind() {
    }
}

private extension HankkiTableViewCell {
    func setupSubInfoStackView() {
        createSubInfoView("7,500원")
        subInfoStackView.addArrangedSubview(subInfoImageView)
        createSubInfoView("300")
    }
    
    func createSubInfoView(_ text: String) {
        let subInfoView = UIView()
        let subInfoImageView = UIImageView()
        let subInfoLabel = UILabel()
        
        subInfoImageView.do {
            $0.backgroundColor = .red
        }
        
        subInfoLabel.do {
            $0.attributedText = UILabel.setupAttributedText(for: PretendardStyle.button, withText: text, color: .gray500)
        }
        
        subInfoStackView.addArrangedSubview(subInfoView)
        subInfoView.addSubviews(subInfoImageView, subInfoLabel)
        
        subInfoImageView.snp.makeConstraints {
            $0.size.equalTo(16)
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview()
        }
        
        subInfoLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(18)
            $0.trailing.top.bottom.equalToSuperview()
        }
    }
    
}
