//
//  ZipControllerView.swift
//  Hankkijogbo
//
//  Created by 심서현 on 7/10/24.
//

import UIKit

final class ZipViewController: BaseViewController {
    
    // MARK: - Properties
    
    // MARK: - UI Properties
    
    private lazy var hankkiCollectionView = UICollectionView(frame: .zero, collectionViewLayout: setupCollectionViewFlowLayout())
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupRegister()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupNavigationBar()
        setupDelegate()
    }
    
    // MARK: - setup UI
    
    override func setupStyle() {
        hankkiCollectionView.backgroundColor = .gray100
    }
    
    override func setupHierarchy() {
        view.addSubview(hankkiCollectionView)
    }
    
    override func setupLayout() {
        hankkiCollectionView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

private extension ZipViewController {
    func setupRegister() {
        hankkiCollectionView.register(ZipHeaderCollectionView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ZipHeaderCollectionView.className)
        hankkiCollectionView.register(HankkiCollectionViewCell.self, forCellWithReuseIdentifier: HankkiCollectionViewCell.className)
    }
    
    func setupDelegate() {
        hankkiCollectionView.delegate = self
        hankkiCollectionView.dataSource = self
    }
    
    func setupNavigationBar() {
        let type: HankkiNavigationType
        
        type = HankkiNavigationType(
            hasBackButton: true,
            hasRightButton: false,
            mainTitle: .string("식당족보"),
            rightButton: .string(""),
            rightButtonAction: {}
        )
        
        if let navigationController = navigationController as? HankkiNavigationController {
            navigationController.setupNavigationBar(forType: type)
        }
     }
}

private extension ZipViewController {
    func setupCollectionViewFlowLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.do {
            $0.scrollDirection = .vertical
            $0.minimumLineSpacing = 0
            
            $0.itemSize = CGSize(width: view.frame.width,
                                 height: 104)
            $0.headerReferenceSize = CGSize(width: view.frame.width, height: UIView.convertByAspectRatioHeight(UIScreen.getDeviceWidth() - 22 * 2,
                                                                                                               width: 329, height: 231) + 22)
            
        }
        return layout
    }
}
    
extension ZipViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: HankkiCollectionViewCell.className,
            for: indexPath
        ) as? HankkiCollectionViewCell else { return UICollectionViewCell() }
        
        cell.dataBind()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: ZipHeaderCollectionView.className,
                for: indexPath
            )
            return headerView
            
        default:
            fatalError("Unexpected element kind")
        }
    }
}

extension ZipViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            guard let cell = collectionView.cellForItem(at: indexPath) as? HankkiCollectionViewCell else { return }
    }
}
