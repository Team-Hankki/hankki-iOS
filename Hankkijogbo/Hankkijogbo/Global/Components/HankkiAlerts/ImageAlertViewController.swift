//
//  ImageAlert.swift
//  Hankkijogbo
//
//  Created by 심서현 on 7/5/24.
//

import UIKit

import Then
import SnapKit

class ImageAlertViewController: BaseViewController {
    
    // MARK: - Properties

    // MARK: - UI Properties
    
    private let alertView: UIView = UIView()
    
    private let imageView: UIImageView = UIImageView()
    
    private let labelStackView: UIStackView = UIStackView()
    
    private let st1Label: UILabel = UILabel()
    
    private let st3Label: UILabel = UILabel()
    
    private let b5Label: UILabel = UILabel()
    
    private let buttonStackView: UIStackView = UIStackView()
    
    private let secondaryButton: UIButton = UIButton()
    
    private let primaryButton: UIButton = UIButton()
    
    // MARK: - Life Cycle
    
    override func setupStyle() {
        view.backgroundColor = .black.withAlphaComponent(0.67)
        
        alertView.do {
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 28
        }
        
        imageView.do {
            $0.backgroundColor = .gray300
            $0.layer.cornerRadius = 10
        }
        
        labelStackView.do {
            $0.axis = .vertical
            $0.alignment = .center
            $0.spacing = 5
        }
        
        st1Label.do {
            $0.text = "St1"
            $0.font = .setupPretendardStyle(of: .subtitle1)
            $0.textColor = .black
        }
        
        st3Label.do {
            $0.text = "St3"
            $0.font = .setupPretendardStyle(of: .subtitle3)
            $0.textColor = .black
        }
        
        b5Label.do {
            $0.text = "St5"
            $0.font = .setupPretendardStyle(of: .body5)
            $0.textColor = .black
        }
        
        buttonStackView.do {
            $0.axis = .horizontal
            $0.alignment = .center
            $0.spacing = 24
        }
        
        secondaryButton.do {
            $0.layer.cornerRadius = 16
            $0.backgroundColor = .white
            $0.setTitle("세컨드", for: .normal)
            $0.titleLabel?.font = .setupPretendardStyle(of: .subtitle3)
            $0.setTitleColor(.red, for: .normal)
        }
        
        primaryButton.do {
            $0.layer.cornerRadius = 16
            $0.backgroundColor = .red
            $0.setTitle("프라임", for: .normal)
            $0.titleLabel?.font = .setupPretendardStyle(of: .subtitle3)
            $0.setTitleColor(.white, for: .normal)
        }
    }
    
    override func setupHierarchy() {
        view.addSubview(alertView)
        alertView.addSubviews(imageView, labelStackView, buttonStackView)
        labelStackView.addArrangedSubviews(st1Label, b5Label)
        buttonStackView.addArrangedSubviews(secondaryButton, primaryButton)
    }
    
    override func setupLayout() {
        alertView.snp.makeConstraints {
            $0.width.equalTo(319)
            $0.center.equalToSuperview()
        }
        
        imageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(114)
            $0.top.equalToSuperview().inset(20)
        }
        
        labelStackView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(imageView.snp.bottom).offset(20)
        }
        
        buttonStackView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(labelStackView.snp.bottom).offset(20)
            $0.bottom.equalToSuperview().inset(35)
        }
        
        secondaryButton.snp.makeConstraints {
            $0.width.equalTo(100)
            $0.height.equalTo(54)
        }
        
        primaryButton.snp.makeConstraints {
            $0.width.equalTo(100)
            $0.height.equalTo(54)
        }
    }
}
