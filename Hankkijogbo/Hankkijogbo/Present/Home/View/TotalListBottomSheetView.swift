//
//  TotalListBottomSheetView.swift
//  Hankkijogbo
//
//  Created by Gahyun Kim on 7/10/24.
//

import UIKit

final class TotalListBottomSheetView: BaseView {
    
    let hankkiCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    override func setupHierarchy() {
        addSubview(hankkiCollectionView)
    }
    
    override func setupStyle() {
        hankkiCollectionView.do {
            $0.backgroundColor = .white
            $0.register(TotalListCollectionViewCell.self, forCellWithReuseIdentifier: TotalListCollectionViewCell.className)
            $0.dragInteractionEnabled = true
        }
    }
    
    override func setupLayout() {
        hankkiCollectionView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(20)
        }

    }
}
