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

final class HankkiListTableViewCell: BaseTableViewCell {
    
    // MARK: - Properties
    
    weak var delegate: HankkiListTableViewCellDelegate?
    
    private var data: DataStruct?
    
    private let dummyTagList = ["#두루미", "#해파리"]
    
    // MARK: - UI Properties
    
    private let cellStackView = UIStackView()
    
    private let thumbnailView = UIImageView()
    private let infoStackView = UIStackView()
    
    private let categoryChipView = UIView()
    private let categoryLabel = UILabel()
    
    private let titleLabel = UILabel()
    private let titleStaciView = UIStackView()
    
    private let subInfoStackView = UIStackView()
    
    private let priceLabel  = UILabel()
    private let heartCountLabel  = UILabel()
    
    private let line = UIView()
    
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
        cellStackView.do {
            $0.backgroundColor = .hankkiWhite
            $0.axis = .horizontal
            $0.spacing = 12
            $0.layoutMargins = UIEdgeInsets(top: 16, left: 22, bottom: 16, right: 22)
            $0.isLayoutMarginsRelativeArrangement = true
            $0.alignment = .center
        }
        
        thumbnailView.do {
            $0.makeRounded(radius: 8)
            $0.image = .imgHankkiListDefault
        }
        
        infoStackView.do {
            $0.axis = .vertical
            $0.spacing = 7
            $0.alignment = .leading
        }
        
        titleStaciView.do {
            $0.axis = .horizontal
            $0.spacing = 5
        }
        
        titleLabel.do {
            $0.attributedText = UILabel.setupAttributedText(for: SuiteStyle.subtitle, withText: "가게 이름", color: .gray900)
        }
        
        categoryChipView.do {
            $0.makeRounded(radius: 10)
            $0.backgroundColor = .hankkiRedLight
        }
        
        categoryLabel.do {
            $0.attributedText = UILabel.setupAttributedText(for: PretendardStyle.caption2, withText: "카테고리", color: .hankkiRed)
        }
        
        priceLabel.do {
            $0.attributedText = UILabel.setupAttributedText(for: PretendardStyle.button, withText: "가격", color: .gray500)
        }
        
        heartCountLabel.do {
            $0.attributedText = UILabel.setupAttributedText(for: PretendardStyle.button, withText: "하트수", color: .gray500)
        }
        
        subInfoStackView.do {
            $0.axis = .horizontal
        }
        
        line.do {
            $0.backgroundColor = .gray200
        }
        
        heartButton.do {
//            let selectedImage = UIGraphicsImageRenderer(size: CGSize(width: 52, height: 52)).image { _ in
//                UIImage.btnLikeSelected52.draw(in: CGRect(origin: .zero, size: CGSize(width: 52, height: 52)))
//            }
//            let normalImage = UIGraphicsImageRenderer(size: CGSize(width: 52, height: 52)).image { _ in
//                UIImage.btnLikeNormal52.draw(in: CGRect(origin: .zero, size: CGSize(width: 52, height: 52)))
//            }
//            
            $0.setImage(.btnLikeSelected52, for: .selected)
            $0.setImage(.btnLikeSelected52, for: .normal)
            $0.isSelected = true
        }
    }
    
    override func setupHierarchy() {
        self.contentView.addSubviews(cellStackView, line)
        cellStackView.addArrangedSubviews(thumbnailView, infoStackView, heartButton)
        infoStackView.addArrangedSubviews(titleStaciView, subInfoStackView)
        titleStaciView.addArrangedSubviews(titleLabel, categoryChipView)
        subInfoStackView.addArrangedSubviews(createSubInfoView(0), createSubInfoView(1))
        categoryChipView.addSubview(categoryLabel)
    }
    
    override func setupLayout() {
        cellStackView.snp.makeConstraints {
            $0.width.equalToSuperview().offset(11)
        }
        
        thumbnailView.snp.makeConstraints {
            $0.size.equalTo(72)
        }
        
        categoryChipView.snp.makeConstraints {
            $0.height.equalTo(20)
        }
        
        categoryLabel.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(8)
            $0.centerY.equalToSuperview()
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

extension HankkiListTableViewCell {
    func dataBind(_ data: DataStruct, isLikeButtonDisable: Bool) {
        self.data = data

        titleLabel.text = data.name
        categoryLabel.text = data.category
        heartButton.isHidden = isLikeButtonDisable
        priceLabel.text = "\(data.lowestPrice)원"
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
    
    func createSubInfoView(_ index: Int) -> UIView {
        let stackView = UIStackView()
        let subInfoImageView = UIImageView()
        let subInfoSeparatorView = UIImageView()
        
        stackView.do {
            $0.axis = .horizontal
            $0.alignment = .center
        }
        
        subInfoSeparatorView.do {
            $0.image = .icSeparator
            $0.isHidden = (index == 0)
        }
  
        stackView.addArrangedSubviews(subInfoSeparatorView, subInfoImageView)
        
        subInfoSeparatorView.snp.makeConstraints {
            $0.width.equalTo(10)
            $0.height.equalTo(18)
        }
        
        subInfoImageView.snp.makeConstraints {
            $0.size.equalTo(16)
        }
        
        switch index {
        case 0:
            subInfoImageView.image = .icFood16
            stackView.addArrangedSubview(priceLabel)
        case 1:
            subInfoImageView.image = .icHeart
            stackView.addArrangedSubview(heartCountLabel)
        default:
            subInfoImageView.image = .icFood16
        }
        
        return stackView
    }
}
