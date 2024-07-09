//
//  MypageCollectionViewCellType.swift
//  Hankkijogbo
//
//  Created by 심서현 on 7/9/24.
//

import UIKit

extension MypageViewController {
    enum SectionType: Int, CaseIterable {
        case zip, hankki, option
        
        var numberOfItemsInSection: Int {
            switch self {
            case .zip:
                1
            case .hankki:
                2
            case .option:
                3
            }
        }
    }
    
    func setupAction(_ section: SectionType, itemIndex: Int) {
        print("터치")
        // TODO: - 함수 추후 변경
        switch section {
        case .zip:
            print("나의 한끼 족보로 이동")
            
        case .hankki:
            print("제보하거나 좋아요한 한끼 식당 리스트로 이동")
            
        case .option:
            switch itemIndex {
            case 0:
                print("FAQ로 이동")
            case 1:
                print("1:1 문의로 이동")
            case 2:
                self.showAlert(
                    image: "dummy",
                    titleText: "정말 로그아웃 하실 건가요?",
                    subText: "Apple 계정을 로그아웃합니다",
                    secondaryButtonText: "돌아가기",
                    primaryButtonText: "로그아웃"
                )
            default:
                return
            }
        }
    }
    
    func setupSection(_ section: SectionType) -> NSCollectionLayoutSection {
        switch section {
        case .zip:
        return setupZipSection()
        case .hankki:
            return setupHankkiSection()
        case .option:
            return setupOptionSection()
        }
    }
}

// MARK: - setup CollectionView Section

private extension MypageViewController {
    
    func setupNSCollectionLayoutSection(itemSize: NSCollectionLayoutSize, groupSize: NSCollectionLayoutSize) -> NSCollectionLayoutSection {
        let itemSize = itemSize
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = groupSize
        
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: groupSize,
            subitems: [item]
        )
        let section = NSCollectionLayoutSection(group: group)
        
        return section
    }
    
    func setupZipSection() -> NSCollectionLayoutSection {
        let itemWidth: CGFloat = (375 - 22*2)
        
        let section: NSCollectionLayoutSection = setupNSCollectionLayoutSection(
            itemSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(72)),
            groupSize: NSCollectionLayoutSize(widthDimension: .absolute(itemWidth), heightDimension: .absolute(UIView.convertByAspectRatioHeight(itemWidth, width: 331, height: 72)))
        )
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(196))
        
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        
        section.boundarySupplementaryItems = [header]
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 22, bottom: 0, trailing: 22)
        
        return section
    }
    
    func setupHankkiSection() -> NSCollectionLayoutSection {
        let itemWidth: CGFloat = ((375 - 22*2) / 2) - 20
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(itemWidth), heightDimension: .fractionalHeight(1.0))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(UIView.convertByAspectRatioHeight(itemWidth, width: 155, height: 95)
        ))
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitem: item,
            count: 2
        )
        group.interItemSpacing = .flexible(20)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 22, bottom: 10, trailing: 22)
        
        return section
    }
    
    func setupOptionSection() -> NSCollectionLayoutSection {
        let section: NSCollectionLayoutSection = setupNSCollectionLayoutSection(
            itemSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(60)),
            groupSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(60))
        )

        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 22, bottom: 0, trailing: 22)

        let footerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(48))
        
        let footer = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: footerSize,
            elementKind: UICollectionView.elementKindSectionFooter,
            alignment: .bottomTrailing
        )
        
        section.boundarySupplementaryItems = [footer]

        return section
    }
}
