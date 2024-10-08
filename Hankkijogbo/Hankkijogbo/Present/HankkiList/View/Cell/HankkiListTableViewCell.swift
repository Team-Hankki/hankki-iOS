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
    
    private let thumbnailView = UIImageView()
    
    private let infoView = UIView()
    private let titleStackView = UIStackView()
    private let titleLabel = UILabel()
    
    private let heartSatckView = UIStackView()
    private let heartImageView = UIImageView()
    private let heartCountLabel  = UILabel()

    private let menuListLabel = UILabel()
    
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
            $0.makeRoundBorder(cornerRadius: 10, borderWidth: 0, borderColor: .clear)
            $0.contentMode = .scaleAspectFill
        }
        
        titleStackView.do {
            $0.axis = .horizontal
            $0.alignment = .center
            $0.spacing = 4
        }
        
        titleLabel.do {
            $0.attributedText = UILabel.setupAttributedText(for: PretendardStyle.body7, color: .gray900)
            $0.lineBreakMode = .byTruncatingTail
        }
        
        heartSatckView.do {
            $0.axis = .horizontal
            $0.alignment = .center
        }
        
        heartImageView.do {
            $0.image = .icHeartRed
        }
        heartCountLabel.do {
            $0.attributedText = UILabel.setupAttributedText(for: PretendardStyle.caption1, color: .heartRed)
        }
        
        menuListLabel.do {
            $0.attributedText = UILabel.setupAttributedText(for: PretendardStyle.button,
                                                            color: .gray500)
            $0.lineBreakMode = .byTruncatingTail
        }
  
        priceTitleLabel.do {
            $0.attributedText = UILabel.setupAttributedText(for: PretendardStyle.caption1,
                                                            withText: StringLiterals.HankkiList.average,
                                                            color: .gray400)
        }
        priceLabel.do {
            $0.attributedText = UILabel.setupAttributedText(for: PretendardStyle.body5, color: .gray850)
        }

        heartButton.do {
            $0.setImage(.btnLikeSelectedList, for: .selected)
            $0.setImage(.btnLikeNormalList, for: .normal)
            $0.isSelected = true
        }
    }
    
    override func setupHierarchy() {
        self.contentView.addSubviews(thumbnailView,
                                     infoView,
                                     heartButton)
        
        infoView.addSubviews(titleStackView,
                             menuListLabel,
                             priceTitleLabel, priceLabel)
        
        titleStackView.addArrangedSubviews(titleLabel, heartSatckView)
        heartSatckView.addArrangedSubviews(heartImageView, heartCountLabel)
    }
    
    override func setupLayout() {
        thumbnailView.snp.makeConstraints {
            $0.size.equalTo(78)
            $0.leading.equalToSuperview().inset(22)
            $0.verticalEdges.equalToSuperview().inset(16)
        }
        
        infoView.snp.makeConstraints {
            $0.leading.equalTo(thumbnailView.snp.trailing).offset(14)
        }
        
        titleStackView.snp.makeConstraints {
            $0.top.equalTo(thumbnailView).inset(6.5)
            $0.horizontalEdges.equalToSuperview()
        }
        
        heartImageView.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.size.equalTo(16)
        }
        
        heartCountLabel.snp.makeConstraints {
            $0.leading.equalTo(heartImageView.snp.trailing)
            $0.trailing.equalToSuperview()
        }
        
        menuListLabel.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.top.equalTo(titleStackView.snp.bottom).offset(2)
        }
        
        priceTitleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.top.equalTo(menuListLabel.snp.bottom).offset(6.5)
        }
        
        priceLabel.snp.makeConstraints {
            $0.leading.equalTo(priceTitleLabel.snp.trailing).offset(3)
            $0.bottom.equalTo(priceTitleLabel)
        }
        
        heartButton.snp.makeConstraints {
            $0.size.equalTo(38)
            $0.leading.equalTo(infoView.snp.trailing).offset(14)
            $0.trailing.equalToSuperview().inset(22)
            $0.centerY.equalToSuperview()
        }
    }
}

extension HankkiListTableViewCell {
    func dataBind(_ data: Model, isFinal: Bool, isLikeButtonDisable: Bool) {
        self.data = data
        
        thumbnailView.setKFImage(url: data.imageURL, placeholder: .imgDetailDefault)
        
        heartCountLabel.text = "\(data.heartCount)"
        titleLabel.text = data.name
        
        // TODO: - 서버 바뀌면 값 변경
        menuListLabel.text = "제육볶음, 김치찌개, 된장찌개, 계란찜, 해장국, 제육볶음, 김치찌개, 된장찌개, 계란찜, 해장국"
        priceLabel.formattingPrice(price: data.lowestPrice)
        
        heartButton.isHidden = isLikeButtonDisable
        heartButton.isSelected = !data.isDeleted
        
        if heartButton.isHidden {
            infoView.snp.remakeConstraints {
                $0.leading.equalTo(thumbnailView.snp.trailing).offset(14)
                $0.trailing.equalToSuperview().inset(22)
            }
        }
        heartSatckView.isHidden = !isLikeButtonDisable
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
