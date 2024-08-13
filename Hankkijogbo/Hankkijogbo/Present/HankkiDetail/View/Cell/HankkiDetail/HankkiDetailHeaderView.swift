//
//  HankkiDetailHeaderView.swift
//  Hankkijogbo
//
//  Created by 서은수 on 7/15/24.
//

import UIKit

final class HankkiDetailHeaderView: BaseCollectionReusableView {
    
    private let nameMaxLength: Int = 10
    
    // MARK: - UI Components
    
    private let headerStackView: UIStackView = UIStackView()
    private let headerLabel: UILabel = UILabel()
    private let categoryLabel: HankkiPaddingLabel = HankkiPaddingLabel(padding: .init(top: 10, left: 12, bottom: 10, right: 12))
    
    // MARK: - Setup UI
    
    override func setupHierarchy() {
        addSubview(headerStackView)
        headerStackView.addArrangedSubviews(headerLabel, categoryLabel)
    }
    
    override func setupLayout() {
        headerStackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(36)
            $0.centerX.equalToSuperview()
        }
        headerLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
            $0.height.equalTo(36)
        }
        categoryLabel.snp.makeConstraints {
            $0.centerY.equalTo(headerLabel)
            $0.leading.equalTo(headerLabel.snp.trailing).offset(8)
            $0.height.equalTo(28)
        }
    }
    
    override func setupStyle() {
        headerStackView.do {
            $0.axis = .horizontal
            $0.spacing = 8
            $0.alignment = .top
            $0.distribution = .equalSpacing
        }
        headerLabel.do {
            $0.attributedText = UILabel.setupAttributedText(
                for: SuiteStyle.h1,
                color: .gray900
            )
            $0.lineBreakMode = .byTruncatingTail // attributedText 설정 이후에 적어야만 적용이 된다고 함
            $0.textAlignment = .center
        }
        categoryLabel.do {
            $0.attributedText = UILabel.setupAttributedText(
                for: PretendardStyle.caption1,
                color: .hankkiRed
            )
            $0.backgroundColor = .hankkiRedLight
            $0.makeRoundBorder(cornerRadius: 12, borderWidth: 0, borderColor: .clear)
        }
    }
}

extension HankkiDetailHeaderView {
    func bindData(name: String, category: String) {
        headerLabel.text = name
        if name.count > nameMaxLength {
            updateHeaderLabelWidth(by: name)
        }
        
        categoryLabel.text = category
    }
}

private extension HankkiDetailHeaderView {
    
    /// 10글자를 초과할 경우 headerLabel의 width 값을 업데이트 하여 truncate되도록 만든다
    /// - getTextWidth로 11글자일 때의 width 값 계산
    /// - 11글자일 때로 width를 설정하여 이를 넘는 글자는 .byTruncatingTail이 자동 적용됨
    private func updateHeaderLabelWidth(by name: String) {
        if name.count == nameMaxLength + 1 {
            headerLabel.text = name + "11글자일 때에도 잘리기 위한 버퍼 텍스트입니다..." // 추가 안 하면 11글자는 안 잘리고 그대로 들어가버림
        }
        let textWidth = getTextWidth(text: String(name.prefix(nameMaxLength + 1)))
        headerLabel.snp.removeConstraints()
        headerLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
            $0.width.lessThanOrEqualTo(textWidth)
            $0.height.equalTo(36)
        }
    }
    
    /// headerLabel의 font를 가지는 text의 width 값 계산
    private func getTextWidth(text: String) -> CGFloat {
        let textSize = (text as NSString).boundingRect(
            with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: headerLabel.frame.height),
            options: .usesLineFragmentOrigin,
            attributes: [.font: headerLabel.font as Any],
            context: nil
        ).size
        
        return textSize.width
    }
}
