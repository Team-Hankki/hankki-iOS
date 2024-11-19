//
//  HankkiAccessoryView.swift
//  Hankkijogbo
//
//  Created by 서은수 on 11/18/24.
//

import UIKit

/// - 한끼족보 기본 악세사리 뷰
final class HankkiAccessoryView: BaseView {
    
    // MARK: - Properties
    
    var text: String
    
    // MARK: - UI Components
    
    let button: UIButton = UIButton()
        
    // MARK: - Init
    
    init(text: String) {
        self.text = text
        super.init(frame: .zero)
    }
   
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Set UI
    
    override func setupStyle() {
        button.do {
            $0.isEnabled = false
            $0.backgroundColor = .red400
            $0.setAttributedTitle(
                UILabel.setupAttributedText(
                    for: PretendardStyle.subtitle3,
                    withText: text,
                    color: .hankkiWhite
                ), for: .normal)
        }
    }
    
    override func setupHierarchy() {
        addSubview(button)
    }

    override func setupLayout() {
        self.snp.makeConstraints {
            $0.width.equalTo(UIScreen.getDeviceWidth())
            $0.height.equalTo(54)
        }
        
        button.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

extension HankkiAccessoryView {
    
    func updateStyle(isValid: Bool) {
        button.backgroundColor = isValid ? .red500 : .red400
        button.isEnabled = isValid
    }
}
