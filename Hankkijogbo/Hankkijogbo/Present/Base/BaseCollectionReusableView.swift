//
//  BaseCollectionReusableView.swift
//  Hankkijogbo
//
//  Created by 서은수 on 7/9/24.
//

import UIKit

import SnapKit
import Then

class BaseCollectionReusableView: UICollectionReusableView {
    
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
