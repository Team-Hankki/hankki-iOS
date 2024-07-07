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
    
    var image: String = ""
    
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
    
    // MARK: - setupStyle
    
    override func setupStyle() {
        let style: AlertStyle = image.isEmpty ? .textAlertStyle : .imageAlertStyle
        
        view.backgroundColor = .black.withAlphaComponent(0.67)
        
        alertView.do {
            $0.backgroundColor = .white
            $0.layer.cornerRadius = style.alertCornerRadius
        }
        
        imageView.do {
            $0.backgroundColor = .gray300
            $0.layer.cornerRadius = 10
            $0.isHidden = image.isEmpty
        }
        
        labelStackView.do {
            $0.axis = .vertical
            $0.alignment = style.labelStackViewAlignment
            $0.spacing = 8
        }
        
        titleLabel.do {
            $0.text = titleText
            $0.font = .setupPretendardStyle(of: .subtitle3)
            $0.textColor = .black
            $0.numberOfLines = 0
            $0.textAlignment = style.labelAlignment
            $0.isHidden = titleText.isEmpty
        }
        
        subLabel.do {
            $0.text = subText
            $0.font = .setupPretendardStyle(of: .body4)
            $0.textColor = .gray500
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
                         backgroundColor: .white, titleColor: .red)
        
        setupButtonStyle(button: primaryButton,
                        title: primaryButtonText,
                         backgroundColor: .red, titleColor: .white)
    }
    
    // MARK: - setupHierarchy
    
    override func setupHierarchy() {
        view.addSubview(alertView)
        labelStackView.addArrangedSubviews(titleLabel, subLabel)
        buttonStackView.addArrangedSubviews(secondaryButton, primaryButton)
        alertView.addSubviews(imageView, labelStackView, buttonStackView)
    }
    
    // MARK: - setupLayout
    
    override func setupLayout() {
        alertView.snp.makeConstraints {
            $0.width.equalTo(330)
            $0.center.equalToSuperview()
        }
        
        secondaryButton.snp.makeConstraints {
            $0.width.equalTo(100)
            $0.height.equalTo(54)
        }
        
        primaryButton.snp.makeConstraints {
            $0.width.equalTo(100)
            $0.height.equalTo(54)
        }
        
        if image.isEmpty {
            labelStackView.snp.makeConstraints {
                $0.top.equalToSuperview().offset(24)
                $0.leading.equalToSuperview().inset(20)
            }
            
            buttonStackView.snp.makeConstraints {
                $0.top.equalTo(labelStackView.snp.bottom).offset(16)
                $0.trailing.equalToSuperview().inset(20)
                $0.bottom.equalToSuperview().inset(24)
            }
        } else {
            imageView.snp.makeConstraints {
                $0.centerX.equalToSuperview()
                $0.width.height.equalTo(140)
                $0.top.equalToSuperview().inset(24)
            }
            
            labelStackView.snp.makeConstraints {
                $0.top.equalTo(imageView.snp.bottom).offset(20)
                $0.centerX.equalToSuperview()
            }
            
            buttonStackView.snp.makeConstraints {
                $0.top.equalTo(labelStackView.snp.bottom).offset(36)
                $0.centerX.equalToSuperview()
                $0.bottom.equalToSuperview().inset(24)
            }
        }
    }
}

// MARK: - private Func

private extension AlertViewController {
    
    func cancleAction() {
        dismiss(animated: false)
    }
    
    func setupButtonStyle(button: UIButton,
                          title: String,
                          backgroundColor: UIColor,
                          titleColor: UIColor
    ) {
        button.layer.cornerRadius = 16
        button.backgroundColor = backgroundColor
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = .setupPretendardStyle(of: .subtitle3)
        button.setTitleColor(titleColor, for: .normal)
        button.isHidden = title.isEmpty
    }
    
    // MARK: - @objc
    
    @objc func secondaryButtonDidTap() {
        if let secondaryButtonHandler {
            secondaryButtonHandler()
        } else {
            cancleAction()
        }
    }
    
    @objc func primaryButtonDidTap() {
        if let primaryButtonHandler {
            primaryButtonHandler()
        } else {
            cancleAction()
        }
    }
    
    // MARK: - setupAction
    
    func setupButtonAction() {
        secondaryButton.addTarget(self, action: #selector(secondaryButtonDidTap), for: .touchUpInside)
        primaryButton.addTarget(self, action: #selector(primaryButtonDidTap), for: .touchUpInside)
    }

}
