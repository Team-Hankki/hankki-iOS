//
//  ZipCollectionViewCell.swift
//  Hankkijogbo
//
//  Created by 심서현 on 7/10/24.
//

import UIKit

protocol HankkiListTableViewCellDelegate: AnyObject {
    func heartButtonDidTap(in cell: HankkiListTableViewCell, isSelected: Bool)
}

extension HankkiListTableViewCell {
    struct Model {
        let id: Int
        let name: String
        let imageURL: String
        let category: String
        let lowestPrice: Int
        var heartCount: Int
        var isDeleted: Bool = false
    }
}

final class HankkiListTableViewCell: BaseTableViewCell {
    
    // MARK: - Properties
    
    weak var delegate: HankkiListTableViewCellDelegate?
    
    private var data: Model?
    
    // MARK: - UI Properties
    
    private let cellStackView = UIStackView()
    
    private let thumbnailView = UIImageView()
    private let infoStackView = UIStackView()
    
    private let categoryLabel = UILabel()
    
    private let titleLabel = UILabel()
    private let titleStaciView = UIStackView()

    private let heartView = UIView()
    private let heartIcon = UIImageView()
    private let heartCountLabel  = UILabel()
    
    private let priceView = UIView()
    private let priceTitleLabel = UILabel()
    private let priceLabel  = UILabel()
    
    private let heartButton = UIButton()
    
    // MARK: - Life Cycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupAction()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - setup UI

    override func setupStyle() {
        
        thumbnailView.do {
            $0.makeRoundBorder(cornerRadius: 12, borderWidth: 0, borderColor: .clear)
            $0.contentMode = .scaleAspectFill
        }
        
        cellStackView.do {
            $0.axis = .horizontal
            $0.spacing = 13
            $0.isLayoutMarginsRelativeArrangement = true
            $0.alignment = .center
        }
        
        infoStackView.do {
            $0.axis = .vertical
            $0.spacing = 1
            $0.alignment = .leading
        }
        
        titleStaciView.do {
            $0.axis = .horizontal
            $0.alignment = .center
            $0.spacing = 6
        }
        
        titleLabel.do {
            $0.attributedText = UILabel.setupAttributedText(for: PretendardStyle.body5, color: .gray850)
            $0.lineBreakMode = .byTruncatingTail
        }
        
        categoryLabel.do {
            $0.attributedText = UILabel.setupAttributedText(for: PretendardStyle.caption4, color: .gray500)
        }
        
        priceLabel.do {
            $0.attributedText = UILabel.setupAttributedText(for: PretendardStyle.body6, color: .gray800)
        }
        
        priceTitleLabel.do {
            $0.attributedText = UILabel.setupAttributedText(for: PretendardStyle.caption4,
                                                            withText: StringLiterals.HankkiList.lowest,
                                                            color: .gray400)
        }
        
        heartIcon.do {
            $0.image = .icHeartRed
        }
        heartCountLabel.do {
            $0.attributedText = UILabel.setupAttributedText(for: PretendardStyle.caption1, color: .gray700)
        }
        
        heartButton.do {
            $0.setImage(.btnLikeSelectedList, for: .selected)
            $0.setImage(.btnLikeNormalList, for: .normal)
            $0.isSelected = true
        }
    }
    
    override func setupHierarchy() {
        self.contentView.addSubviews(thumbnailView, cellStackView)
        cellStackView.addArrangedSubviews(infoStackView, heartButton)
        infoStackView.addArrangedSubviews(categoryLabel, titleStaciView, priceView)
        
        titleStaciView.addArrangedSubviews(titleLabel, heartView)
        heartView.addSubviews(heartIcon, heartCountLabel)
        priceView.addSubviews(priceTitleLabel, priceLabel)
    }
    
    override func setupLayout() {
  
        thumbnailView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(15)
            $0.verticalEdges.equalToSuperview().inset(12)
            $0.size.equalTo(78)
        }
        
        cellStackView.snp.makeConstraints {
            $0.leading.equalTo(thumbnailView.snp.trailing).offset(14)
            $0.trailing.equalToSuperview().inset(15)
            $0.verticalEdges.equalToSuperview().inset(19.5)
        }
        
        heartIcon.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.size.equalTo(16)
        }
        
        heartCountLabel.snp.makeConstraints {
            $0.leading.equalTo(heartIcon.snp.trailing).offset(2)
            $0.trailing.equalToSuperview()
            $0.verticalEdges.equalToSuperview()
        }
        
        heartButton.snp.makeConstraints {
            $0.size.equalTo(26)
        }
        
        priceView.snp.makeConstraints {
            $0.height.equalTo(22)
        }
        
        priceTitleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.width.equalTo(23)
            $0.height.equalTo(21)
        }
        
        priceLabel.snp.makeConstraints {
            $0.leading.equalTo(priceTitleLabel.snp.trailing).offset(2)
            $0.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
}

extension HankkiListTableViewCell {
    func dataBind(_ data: Model, isFinal: Bool, isLikeButtonDisable: Bool) {
        self.data = data
    
//        categoryLabel.text = data.category
        categoryLabel.text = "가나다라 마바사 아자차카 타파아 아야어여오요우이"
//        titleLabel.text = data.name
        titleLabel.text = "가나다라 마바사 아자차카 타파아 아야어여오요우이"
        
        thumbnailView.setKFImage(url: data.imageURL, placeholder: .imgDetailDefault)
        heartButton.isHidden = isLikeButtonDisable
        priceLabel.formattingPrice(price: data.lowestPrice)
        heartCountLabel.text = "\(data.heartCount)"
        
        heartButton.isSelected = !data.isDeleted
    }
}

private extension HankkiListTableViewCell {
    @objc private func heartButtonDidTap() {
        delegate?.heartButtonDidTap(in: self, isSelected: self.heartButton.isSelected)
        heartButton.isSelected = !heartButton.isSelected
    }
    
    func setupAction() {
        heartButton.addTarget(self, action: #selector(heartButtonDidTap), for: .touchUpInside)
    }
}
