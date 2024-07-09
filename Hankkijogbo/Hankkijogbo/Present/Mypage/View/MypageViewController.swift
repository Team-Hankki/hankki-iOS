//
//  MypageViewController.swift
//  Hankkijogbo
//
//  Created by 심서현 on 7/8/24.
//

import UIKit

final class MypageViewController: BaseViewController {
    
    // MARK: - Properties
    
    private lazy var optionList: [MypageOptionCollectionViewCell.DataStruct] = [
        MypageOptionCollectionViewCell.DataStruct(title: "FAQ"),
        MypageOptionCollectionViewCell.DataStruct(title: "1:1 문의"),
        MypageOptionCollectionViewCell.DataStruct(title: "로그아웃")
    ]
    
    // MARK: - UI Properties
    
    lazy var layout = UICollectionViewCompositionalLayout { (sectionIndex, _) -> NSCollectionLayoutSection? in
        return self.setupCollectionViewSection(for: SectionType(rawValue: sectionIndex)!)
    }
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupRegister()
        setupDelegate()
    }
    
    override func setupHierarchy() {
        view.addSubviews(collectionView)
    }
    
    override func setupLayout() {
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

private extension MypageViewController {
    func setupRegister() {
        collectionView.register(MypageZipCollectionViewCell.self, forCellWithReuseIdentifier: MypageZipCollectionViewCell.className)
        collectionView.register(MypageHankkiCollectionViewCell.self, forCellWithReuseIdentifier: MypageHankkiCollectionViewCell.className)
        collectionView.register(MypageOptionCollectionViewCell.self, forCellWithReuseIdentifier: MypageOptionCollectionViewCell.className)
        
        collectionView.register(MypageHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: MypageHeaderView.className)
        collectionView.register(MypageQuitFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: MypageQuitFooterView.className)
    }
    
    func setupDelegate() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
}

// MARK: - Delegate

extension MypageViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return SectionType.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return SectionType(rawValue: section)?.numberOfItemsInSection ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: MypageHeaderView.className,
                for: indexPath
            )
            return headerView
            
        case UICollectionView.elementKindSectionFooter:
            let footerView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: MypageQuitFooterView.className,
                for: indexPath
            )
            
            return footerView
        
        default:
            fatalError("Unexpected element kind")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch SectionType(rawValue: indexPath.section) {
        case .zip:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MypageZipCollectionViewCell.className, for: indexPath) as? MypageZipCollectionViewCell else {
                return UICollectionViewCell()
            }
            return cell
            
        case .hankki:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MypageHankkiCollectionViewCell.className, for: indexPath) as? MypageHankkiCollectionViewCell else {
                return UICollectionViewCell()
            }
            return cell
            
        case .option:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MypageOptionCollectionViewCell.className, for: indexPath) as? MypageOptionCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.dataBind(data: optionList[indexPath.item])
            return cell
            
        case .none:
            return UICollectionViewCell()
        }
    }
}

extension MypageViewController: UIGestureRecognizerDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        setupAction(SectionType(rawValue: indexPath.section)!, itemIndex: indexPath.item)
    }
}

//MARK: - setup CollectionView Section

private extension MypageViewController {

    func setupCollectionViewSection(for section: SectionType) -> NSCollectionLayoutSection {
        setupSection(section)
    }
    
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
        let section: NSCollectionLayoutSection = setupNSCollectionLayoutSection(
            itemSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(72)),
            groupSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(72))
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
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(94 / ( 375-44 )))
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitem: item,
            count: 2
        )
        group.interItemSpacing = .flexible(21)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 19, leading: 22, bottom: 8, trailing: 22)
        
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
