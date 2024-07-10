//
//  ReportCompositionalFactory.swift
//  Hankkijogbo
//
//  Created by 서은수 on 7/9/24.
//

import UIKit

// MARK: - Compositional Layout

enum ReportSectionType: Int {
    case search
    case category
    case image
    case menu
    case addMenu
}

enum SupplementaryItemType {
    case header
    case footer
}

enum ReportCompositionalFactory {
    static func create() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (sectionIndex, _) -> NSCollectionLayoutSection? in
            guard let sectionType: ReportSectionType = ReportSectionType(rawValue: sectionIndex) else {
                return nil
            }
            let section: NSCollectionLayoutSection
            switch sectionType {
            case .search:
                section = getSearchLayoutSection()
            case .category:
                section = getCategoryLayoutSection()
            case .image:
                section = getImageLayoutSection()
            case .menu:
                section = getMenuLayoutSection()
            case .addMenu:
                section = getAddMenuLayoutSection()
            }
            return section
        }
    }
}

extension ReportCompositionalFactory {
    static func createItem(
        widthDimension: NSCollectionLayoutDimension,
        heightDimension: NSCollectionLayoutDimension,
        contentInsets: NSDirectionalEdgeInsets = .zero
    ) -> NSCollectionLayoutItem {
        let itemSize = NSCollectionLayoutSize(widthDimension: widthDimension, heightDimension: heightDimension)
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = contentInsets
        return item
    }
    
    static func createGroup(
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
    
    static func createBoundarySupplementaryItem(
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
    
    static func createLayoutSection(
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

extension ReportCompositionalFactory {
    
    // MARK: - Search Section
    
    static func getSearchLayoutSection() -> NSCollectionLayoutSection {
        let item = createItem(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(112))
        let group = createGroup(item: [item], widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(112))
        let section = createLayoutSection(group: group, orthogonalScrollingBehavior: .groupPaging)
        return section
    }
    
    // MARK: - Category Section

    static func getCategoryLayoutSection() -> NSCollectionLayoutSection {
        let header = createBoundarySupplementaryItem(type: .header, widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(57), alignment: .topLeading)
        let item = createItem(widthDimension: .estimated(50), heightDimension: .fractionalHeight(1))
        let group = createGroup(item: [item], widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(36))
        group.interItemSpacing = .fixed(6)
        let section = createLayoutSection(group: group, sectionContentInsets: .init(top: 14, leading: 22, bottom: 20, trailing: 10), boundarySupplementaryItems: [header])
        section.interGroupSpacing = 8

        return section
    }
    
    // MARK: - Image Section

    static func getImageLayoutSection() -> NSCollectionLayoutSection {
        let header = createBoundarySupplementaryItem(type: .header, widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(57), alignment: .topLeading)
        let item = createItem(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(111))
        let group = createGroup(item: [item], widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(111))
        let section = createLayoutSection(group: group, sectionContentInsets: .init(top: 0, leading: 22, bottom: 0, trailing: 22), boundarySupplementaryItems: [header])
        return section
    }
    
    // MARK: - Menu Section
    
    static func getMenuLayoutSection() -> NSCollectionLayoutSection {
        let item = createItem(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(97))
        let group = createGroup(item: [item], widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(97))
        let section = createLayoutSection(group: group, sectionContentInsets: .init(top: 32, leading: 22, bottom: 0, trailing: 14))
        section.interGroupSpacing = 12
        return section
    }
    
    // MARK: - Add Menu Section
    
    static func getAddMenuLayoutSection() -> NSCollectionLayoutSection {
        let item = createItem(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(32))
        let group = createGroup(item: [item], widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(32))
        let section = createLayoutSection(group: group, sectionContentInsets: .init(top: 24, leading: 22, bottom: 52, trailing: 22))
        return section
    }
}
