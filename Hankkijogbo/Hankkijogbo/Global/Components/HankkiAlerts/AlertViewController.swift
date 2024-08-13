//
//  ImageAlert.swift
//  Hankkijogbo
//
//  Created by 심서현 on 7/5/24.
//

import UIKit

import Then
import SnapKit

final class AlertViewController: BaseViewController {
    
    // MARK: - Properties
    
    typealias ButtonAction = () -> Void
    
    var image: UIImage?
    
    var titleText: String = ""
    var subText: String = ""
    
    var secondaryButtonText: String = ""
    var primaryButtonText: String = ""
    
    var secondaryButtonHandler: ButtonAction?
    var primaryButtonHandler: ButtonAction?

    // MARK: - UI Properties
    
    private let alertView: UIView = UIView()
    
    private let imageView: UIImageView = UIImageView()
    
    private let labelStackView: UIStackView = UIStackView()
    private let titleLabel: UILabel = UILabel()
    private let subLabel: UILabel = UILabel()
    
    private let buttonStackView: UIStackView = UIStackView()
    private let secondaryButton: UIButton = UIButton()
    private let primaryButton: UIButton = UIButton()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupButtonAction()
    }
    
    override func setupStyle() {
        let style: AlertStyle = (image == nil) ? .textAlertStyle : .imageAlertStyle
        
        view.backgroundColor = .black.withAlphaComponent(0.67)
        
        alertView.do {
            $0.backgroundColor = .hankkiWhite
            $0.layer.cornerRadius = style.alertCornerRadius
        }
        
        imageView.do {
            $0.image = image
            $0.layer.cornerRadius = 10
            $0.isHidden = (image == nil)
        }
        
        labelStackView.do {
            $0.axis = .vertical
            $0.alignment = style.labelStackViewAlignment
            $0.spacing = 8
        }
        
        titleLabel.do {
            $0.attributedText = UILabel.setupAttributedText(
                for: style.titleFont,
                withText: titleText,
                color: .gray900
            )
            $0.textAlignment = style.labelAlignment
            $0.numberOfLines = 0
            $0.isHidden = titleText.isEmpty
        }
        
        subLabel.do {
            $0.attributedText = UILabel.setupAttributedText(
                for: PretendardStyle.body4,
                withText: subText,
                color: .gray500
            )
            $0.numberOfLines = 0
            $0.textAlignment = style.labelAlignment
            $0.isHidden = subText.isEmpty
        }
        
        buttonStackView.do {
            $0.axis = .horizontal
            $0.spacing = 8
            $0.alignment = style.buttonStackViewAlignment
        }
        
        setupButtonStyle(button: secondaryButton,
                         title: secondaryButtonText,
                         backgroundColor: .hankkiWhite, titleColor: .hankkiRed)
        
        setupButtonStyle(button: primaryButton,
                         title: primaryButtonText,
                         backgroundColor: .hankkiRed, titleColor: .hankkiWhite)
    }
    
    override func setupHierarchy() {
        view.addSubview(alertView)
        labelStackView.addArrangedSubviews(titleLabel, subLabel)
        buttonStackView.addArrangedSubviews(secondaryButton, primaryButton)
        alertView.addSubviews(imageView, labelStackView, buttonStackView)
    }
    
    override func setupLayout() {
        alertView.snp.makeConstraints {
            // margin 22px
            // max-width 331px
            if UIScreen.getDeviceWidth() > 331 {
                $0.width.equalTo(331)
            } else {
                $0.horizontalEdges.equalToSuperview().inset(22)
            }
            $0.center.equalToSuperview()
        }
        
        
        // TODO: - 버튼 패딩 값으로 바꾸기
        secondaryButton.snp.makeConstraints {
            $0.width.equalTo(100)
            $0.height.equalTo(54)
        }
        
        primaryButton.snp.makeConstraints {
            $0.width.equalTo(100)
            $0.height.equalTo(54)
        }
        
        
        if image == nil {
            // 이미지가 없는 모달창일 경우
            labelStackView.snp.makeConstraints {
                $0.top.equalToSuperview().offset(24)
                $0.leading.equalToSuperview().inset(20)
            }
            
            buttonStackView.snp.makeConstraints {
                $0.trailing.equalToSuperview().inset(18)
                $0.bottom.equalToSuperview().inset(18)
                $0.top.equalTo(labelStackView.snp.bottom).offset(16)
            }
        } else {
            // 이미지가 있는 모달창일 경우
            imageView.snp.makeConstraints {
                $0.centerX.equalToSuperview()
                $0.size.equalTo(140)
                $0.top.equalToSuperview().inset(24)
            }
            
            labelStackView.snp.makeConstraints {
                $0.top.equalTo(imageView.snp.bottom).offset(24)
                $0.centerX.equalToSuperview()
            }
            
            buttonStackView.snp.makeConstraints {
                $0.centerX.equalToSuperview()
                $0.bottom.equalToSuperview().inset(24)
                $0.top.equalTo(labelStackView.snp.bottom).offset(26)
            }
        }
    }
}

// MARK: - private Func

private extension AlertViewController {
    
    func cancelAction() {
        dismiss(animated: false)
    }
    
    func setupButtonStyle(
        button: UIButton,
        title: String,
        backgroundColor: UIColor,
        titleColor: UIColor
    ) {
        button.do {
            if let attributedTitle = UILabel.setupAttributedText(
                for: PretendardStyle.subtitle3,
                withText: title,
                color: titleColor
            ) {
                $0.setAttributedTitle(attributedTitle, for: .normal)
            }
            $0.layer.cornerRadius = 16
            $0.backgroundColor = backgroundColor
            $0.isHidden = title.isEmpty
        }
    }
    
    // MARK: - @objc
    
    @objc func secondaryButtonDidTap() {
        if let secondaryButtonHandler {
            secondaryButtonHandler()
        } else {
            cancelAction()
        }
    }
    
    @objc func primaryButtonDidTap() {
        if let primaryButtonHandler {
            primaryButtonHandler()
            cancelAction()
        } else {
            cancelAction()
        }
    }
    
    // MARK: - setupAction
    
    func setupButtonAction() {
        secondaryButton.addTarget(self, action: #selector(secondaryButtonDidTap), for: .touchUpInside)
        primaryButton.addTarget(self, action: #selector(primaryButtonDidTap), for: .touchUpInside)
    }
}

extension AlertViewController {
    func setupTitleText(start: Int, end: Int, color: UIColor) {
        titleLabel.setupTextColorRange(start: start, end: end, color: color)
    }
}
