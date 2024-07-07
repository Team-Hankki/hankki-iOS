//
//  BaseView.swift
//  Hankkijogbo
//
//  Created by 서은수 on 7/3/24.
//

import UIKit

import SnapKit
import Then

/// 모든 UIView는 BaseView를 상속 받는다.
/// - 각 함수를 override하여 각 View에 맞게 함수 내용을 작성한다.
/// - 각 View에서는 해당 함수들을 호출하지 않아도 된다.
class BaseView: UIView {
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupHierarchy()
        setupLayout()
        setupStyle()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Set UI

    func setupHierarchy() { }
    
    func setupLayout() { }
    
    func setupStyle() { }
}
