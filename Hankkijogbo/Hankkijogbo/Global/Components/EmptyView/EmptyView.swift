//
//  EmptyView.swift
//  Hankkijogbo
//
//  Created by 심서현 on 7/15/24.
//

import UIKit

final class EmptyView: BaseView {
    
    // MARK: - Properties
    
    typealias ButtonAction = (() -> Void)
    
    private let text: String
    private let buttonText: String?
    private let buttonAction: ButtonAction?
    
    // MARK: - UI Components
    
    private let view: UIView = UIView()
    private let imageView: UIImageView = UIImageView()
    private let textLabel: UILabel = UILabel()
    private lazy var button: UIButton = MoreButton(buttonText: self.buttonText, buttonAction: self.buttonAction)
        
    // MARK: - Life Cycle
    
    init(
        text: String,
        buttonText: String? = nil,
        buttonAction: ButtonAction? = nil
    ) {
        self.text = text
        self.buttonText = buttonText
        self.buttonAction = buttonAction
        
        super.init(frame: .zero)
        
        setupStyle()
        setupHierarchy()
        setupLayout()
    }
   
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup UI
    
    override func setupStyle() {
        imageView.do {
            $0.image = .imgEmpty
        }
        
        textLabel.do {
            $0.attributedText = UILabel.setupAttributedText(for: PretendardStyle.body6, withText: text, color: .gray500)
            $0.numberOfLines = 0
            $0.textAlignment = .center
        }
    }
    
    override func setupHierarchy() {
        self.addSubview(view)
        view.addSubviews(imageView, textLabel)
        if buttonText != nil {
            view.addSubview(button)
        }
    }

    override func setupLayout() {
        view.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().multipliedBy(0.85)
        }
        
        imageView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.size.equalTo(100)
        }
        
        textLabel.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.top.equalTo(imageView.snp.bottom).offset(25)
            if buttonText == nil {
                $0.bottom.equalToSuperview()
            }
        }
        
        if buttonText != nil {
            button.snp.makeConstraints {
                $0.centerX.equalToSuperview()
                $0.top.equalTo(textLabel.snp.bottom).offset(25)
                $0.bottom.equalToSuperview()
            }
        }
    }
}

extension EmptyView {
    /// 텍스트 부분의 색을 일부 변경합니다.
    func setupTextLabelColor(start: Int, end: Int, color: UIColor) {
        textLabel.setupTextColorRange(start: start, end: end, color: color)
    }
}
