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
        
        setupAlertStyle()
        setupAlertHierarchy()
        setupAlertLayout()
        
        if image.isEmpty {
            setupTextAlertStyle()
            setupTextAlertHierarchy()
            setupTextAlertLayout()
        } else {
            setupImageAlertStyle()
            setupImageAlertHierarchy()
            setupImageAlertLayout()
        }
        
        setupButtonAction()
    }
}

extension AlertViewController {
    
    // MARK: - Private Func
    
    private func cancleAction() {
        dismiss(animated: false)
    }
    
    // MARK: - @objc
    
    @objc func secondaryButtonDidTapped() {
        if let secondaryButtonHandler {
            secondaryButtonHandler()
        } else {
            cancleAction()
        }
    }
    
    @objc func primaryButtonDidTapped() {
        if let primaryButtonHandler {
            primaryButtonHandler()
        } else {
            cancleAction()
        }
    }
    
    // MARK: - setupAction
    
    func setupButtonAction() {
        secondaryButton.addTarget(self, action: #selector(secondaryButtonDidTapped), for: .touchUpInside)
        primaryButton.addTarget(self, action: #selector(primaryButtonDidTapped), for: .touchUpInside)
    }
    
    // MARK: - setupStyle
    
    private func setupAlertStyle() {
        view.backgroundColor = .black.withAlphaComponent(0.67)
        
        alertView.do {
            $0.backgroundColor = .white
        }
        
        imageView.do {
            $0.backgroundColor = .gray300
            $0.layer.cornerRadius = 10
        }
        
        labelStackView.do {
            $0.axis = .vertical
        }
        
        titleLabel.do {
            $0.text = titleText
            $0.font = .setupPretendardStyle(of: .subtitle3)
            $0.textColor = .black
            $0.numberOfLines = 0
        }
        
        subLabel.do {
            $0.text = subText
            $0.font = .setupPretendardStyle(of: .body4)
            $0.textColor = .gray500
            $0.numberOfLines = 0
        }
        
        buttonStackView.do {
            $0.axis = .horizontal
            $0.spacing = 8
        }
        
        secondaryButton.do {
            $0.layer.cornerRadius = 16
            $0.backgroundColor = .white
            $0.setTitle(secondaryButtonText, for: .normal)
            $0.titleLabel?.font = .setupPretendardStyle(of: .subtitle3)
            $0.setTitleColor(.red, for: .normal)
            
            $0.snp.makeConstraints {
                $0.width.equalTo(100)
                $0.height.equalTo(54)
            }
        }
        
        primaryButton.do {
            $0.layer.cornerRadius = 16
            $0.backgroundColor = .red
            $0.setTitle(primaryButtonText, for: .normal)
            $0.titleLabel?.font = .setupPretendardStyle(of: .subtitle3)
            $0.setTitleColor(.white, for: .normal)
            
            $0.snp.makeConstraints {
                $0.width.equalTo(100)
                $0.height.equalTo(54)
            }
        }
    }
    
    private func setupTextAlertStyle() {
        alertView.do {
            $0.layer.cornerRadius = 24
        }
        
        labelStackView.do {
            $0.alignment = .leading
            $0.spacing = 8
        }
        
        titleLabel.do {
            $0.textAlignment = .left
        }
        
        subLabel.do {
            $0.textAlignment = .left
        }
        
        buttonStackView.do {
            $0.alignment = .trailing
        }
    }

    private func setupImageAlertStyle() {
        alertView.do {
            $0.layer.cornerRadius = 32
        }
        
        labelStackView.do {
            $0.alignment = .center
            $0.spacing = 16
        }
        
        titleLabel.do {
            $0.textAlignment = .center
        }
        
        subLabel.do {
            $0.textAlignment = .center
        }
        
        buttonStackView.do {
            $0.alignment = .center
        }
    }
    
    // MARK: - setupHierarchy
    
    private func setupAlertHierarchy() {
        view.addSubview(alertView)
        setupLabelStackViewHirachy()
        setupButtonStackViewHirachy()
    }
    
    private func setupTextAlertHierarchy() {
        alertView.addSubviews(labelStackView, buttonStackView)
    }
    
    private func setupImageAlertHierarchy() {
        alertView.addSubviews(imageView, labelStackView, buttonStackView)
    }
    
    private func setupLabelStackViewHirachy() {
        if !titleText.isEmpty {
            labelStackView.addArrangedSubview(titleLabel)
        }
        if !subText.isEmpty {
            labelStackView.addArrangedSubview(subLabel)
        }
    }
    
    private func setupButtonStackViewHirachy() {
        if !secondaryButtonText.isEmpty {
            buttonStackView.addArrangedSubview(secondaryButton)
        }
        if !primaryButtonText.isEmpty {
            buttonStackView.addArrangedSubview(primaryButton)
        }
    }
    
    // MARK: - setupLayout
    
    private func setupAlertLayout() {
        alertView.snp.makeConstraints {
            $0.width.equalTo(330)
            $0.center.equalToSuperview()
        }
    }
    
    private func setupTextAlertLayout() {
        labelStackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.leading.equalToSuperview().inset(20)
        }
        
        buttonStackView.snp.makeConstraints {
            $0.top.equalTo(labelStackView.snp.bottom).offset(16)
            $0.trailing.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(20)
        }
    }
    
    private func setupImageAlertLayout() {
        imageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(140)
            $0.top.equalToSuperview().inset(30)
        }
        
        labelStackView.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
        }
        
        buttonStackView.snp.makeConstraints {
            $0.top.equalTo(labelStackView.snp.bottom).offset(36)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(30)
        }
    }
}
