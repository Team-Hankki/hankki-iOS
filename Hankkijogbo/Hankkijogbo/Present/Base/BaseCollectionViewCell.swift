//
//  BaseCollectionViewCell.swift
//  Hankkijogbo
//
//  Created by 서은수 on 6/30/24.
//

import UIKit

/// 모든 UICollectionViewCell는 BaseCollectionViewCell를 상속 받는다.
/// - 각 함수를 override하여 각 Cell에 맞게 함수 내용을 작성한다.
/// - 각 Cell에서는 setupStyle과 setupHierarchy, setupLayout 함수를 호출하지 않아도 된다.
class BaseCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupStyle()
        setupHierarchy()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Set UI

    func setupStyle() { }
    
    func setupHierarchy() { }
    
    func setupLayout() { }
}
