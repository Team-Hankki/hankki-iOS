//
//  ReportCompositionalLayoutFactory.swift
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

final class ReportCompositionalLayoutFactory: CompositionalLayoutFactory {
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

extension ReportCompositionalLayoutFactory {
    
    // MARK: - Search Section
    
    static func getSearchLayoutSection() -> NSCollectionLayoutSection {
        let item = createItem(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(112))
        let group = createGroup(item: [item], widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(112))
        let section = createLayoutSection(group: group, orthogonalScrollingBehavior: .groupPaging)
        return section
    }
    
    // MARK: - Category Section

    static func getCategoryLayoutSection() -> NSCollectionLayoutSection {
        let header = createBoundarySupplementaryItem(type: .header, widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(50), alignment: .topLeading)
        let item = createItem(widthDimension: .estimated(50), heightDimension: .fractionalHeight(1))
        let group = createGroup(item: [item], widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(36))
        group.interItemSpacing = .fixed(6)
        let section = createLayoutSection(group: group, sectionContentInsets: .init(top: 16, leading: 22, bottom: 24, trailing: 10), boundarySupplementaryItems: [header])
        section.interGroupSpacing = 8

        return section
    }
    
    // MARK: - Image Section

    static func getImageLayoutSection() -> NSCollectionLayoutSection {
        let header = createBoundarySupplementaryItem(type: .header, widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(53), alignment: .topLeading)
        let item = createItem(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(127))
        let group = createGroup(item: [item], widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(127))
        let section = createLayoutSection(group: group, sectionContentInsets: .init(top: 0, leading: 22, bottom: 0, trailing: 22), boundarySupplementaryItems: [header])
        return section
    }
    
    // MARK: - Menu Section
    
    static func getMenuLayoutSection() -> NSCollectionLayoutSection {
        let item = createItem(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(95))
        let group = createGroup(item: [item], widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(95))
        let section = createLayoutSection(group: group, sectionContentInsets: .init(top: 0, leading: 22, bottom: 0, trailing: 14))
        section.interGroupSpacing = 10
        return section
    }
    
    // MARK: - Add Menu Section
    
    static func getAddMenuLayoutSection() -> NSCollectionLayoutSection {
        let footer = createBoundarySupplementaryItem(type: .footer, widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(80), alignment: .bottom)
        let item = createItem(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(32))
        let group = createGroup(item: [item], widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(32))
        let section = createLayoutSection(group: group, sectionContentInsets: .init(top: 24, leading: 22, bottom: 52, trailing: 22), boundarySupplementaryItems: [footer])
        return section
    }
}
