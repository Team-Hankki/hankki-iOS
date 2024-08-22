//
//  CompositionalLayoutFactory.swift
//  Hankkijogbo
//
//  Created by 서은수 on 7/11/24.
//

import UIKit

enum SupplementaryItemType {
    case header
    case footer
}

// MARK: - Compositional Layout

class CompositionalLayoutFactory {
    
    /// Item 생성 시 사용합니다.
    func createItem(
        widthDimension: NSCollectionLayoutDimension,
        heightDimension: NSCollectionLayoutDimension,
        contentInsets: NSDirectionalEdgeInsets = .zero
    ) -> NSCollectionLayoutItem {
        let itemSize = NSCollectionLayoutSize(widthDimension: widthDimension, heightDimension: heightDimension)
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = contentInsets
        return item
    }
    
    /// Group 생성 시 사용합니다.
    func createGroup(
        item: [NSCollectionLayoutItem],
        widthDimension: NSCollectionLayoutDimension,
        heightDimension: NSCollectionLayoutDimension,
        contentInsets: NSDirectionalEdgeInsets = .zero
    ) -> NSCollectionLayoutGroup {
        let groupSize = NSCollectionLayoutSize(widthDimension: widthDimension, heightDimension: heightDimension)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: item)
        group.contentInsets = contentInsets
        return group
    }
    
    /// Header 또는 Footer 생성 시 사용합니다.
    /// - type에 .header 또는 .footer를 작성
    func createBoundarySupplementaryItem(
        type: SupplementaryItemType,
        widthDimension: NSCollectionLayoutDimension,
        heightDimension: NSCollectionLayoutDimension,
        alignment: NSRectAlignment = .top
    ) -> NSCollectionLayoutBoundarySupplementaryItem {
        return NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: .init(
                widthDimension: widthDimension,
                heightDimension: heightDimension
            ),
            elementKind: type == .header ? UICollectionView.elementKindSectionHeader : UICollectionView.elementKindSectionFooter,
            alignment: alignment
        )
    }
    
    /// Section 생성 시 사용합니다.
    func createLayoutSection(
        group: NSCollectionLayoutGroup,
        orthogonalScrollingBehavior: UICollectionLayoutSectionOrthogonalScrollingBehavior = .none,
        sectionContentInsets: NSDirectionalEdgeInsets = .zero,
        boundarySupplementaryItems: [NSCollectionLayoutBoundarySupplementaryItem]? = nil
    ) -> NSCollectionLayoutSection {
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = orthogonalScrollingBehavior
        section.contentInsets = sectionContentInsets
        if let supplementaryItems = boundarySupplementaryItems {
            section.boundarySupplementaryItems = supplementaryItems
        }
        return section
    }
}
