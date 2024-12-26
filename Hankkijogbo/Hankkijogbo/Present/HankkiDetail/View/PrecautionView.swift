//
//  PrecautionView.swift
//  Hankkijogbo
//
//  Created by 서은수 on 12/25/24.
//

import UIKit

final class PrecautionView: BaseView {
        
    // MARK: - UI Components
    
    private let guideLabel: UILabel = UILabel()
    private let precautionStackView: UIStackView = UIStackView()
    
    // MARK: - Setup UI
    
    override func setupHierarchy() {
        addSubviews(guideLabel, precautionStackView)
    }
    
    override func setupLayout() {
        guideLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.leading.equalToSuperview().inset(22)
        }
        
        precautionStackView.snp.makeConstraints {
            $0.top.equalTo(guideLabel.snp.bottom).offset(5)
            $0.leading.equalTo(guideLabel).offset(5)
            $0.trailing.equalToSuperview().inset(10)
        }
    }
    
    override func setupStyle() {
        self.do {
            $0.backgroundColor = .gray100
        }
        
        guideLabel.do {
            $0.attributedText = UILabel.setupAttributedText(
                for: PretendardStyle.caption3,
                withText: StringLiterals.HankkiDetail.precautions,
                color: .gray400
            )
        }
        
        precautionStackView.do {
            $0.axis = .vertical
            $0.alignment = .leading
            $0.spacing = 4
            
            setupStackView()
        }
    }
}

private extension PrecautionView {
    
    func setupStackView() {
        let precautions: [String] = [
            StringLiterals.HankkiDetail.precautionCanBeDifferent,
            StringLiterals.HankkiDetail.precautionShowOnly8000OrUnder,
            StringLiterals.HankkiDetail.precautionCanModify,
            StringLiterals.HankkiDetail.precautionCanStop
        ]
        
        precautions.forEach { precaution in
            let precautionLabel: UILabel = UILabel()
            precautionLabel.attributedText = UILabel.setupAttributedText(
                for: PretendardStyle.caption2,
                withText: "• \(precaution)",
                color: .gray400
            )
            precautionStackView.addArrangedSubview(precautionLabel)
        }
    }
}
