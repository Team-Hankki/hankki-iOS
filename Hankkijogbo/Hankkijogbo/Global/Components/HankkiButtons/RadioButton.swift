//
//  RadioButton.swift
//  Hankkijogbo
//
//  Created by 서은수 on 10/10/24.
//

import UIKit

final class RadioButton: UIButton {

    // MARK: - Properties
    
    typealias ButtonAction = (() -> Void)
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
        setupStyle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension RadioButton {
    
    func setupLayout() {
        self.snp.makeConstraints {
            $0.size.equalTo(24)
        }
    }
    
    func setupStyle() {
        self.do {
            $0.setImage(.btnRadioNormal, for: .normal)
        }
    }
}
