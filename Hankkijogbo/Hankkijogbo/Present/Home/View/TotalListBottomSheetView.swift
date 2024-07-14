//
//  TotalListBottomSheetView.swift
//  Hankkijogbo
//
//  Created by Gahyun Kim on 7/10/24.
//

import UIKit

final class TotalListBottomSheetView: BaseView {
    
    // MARK: - Properties
    
    let data = dummyData
    
    // MARK: - UI Components
    
    private let bottomSheetHandlerView = UIView()
    private let flowLayout = UICollectionViewFlowLayout()
    private lazy var totalListCollectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
    private let containerView = UIView()
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupDelegate()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupHierarchy() {
        addSubview(containerView)
        containerView.addSubviews(bottomSheetHandlerView, totalListCollectionView)
        
    }
    
    override func setupStyle() {
        backgroundColor = .white
        
        containerView.do {
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 30
            $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            $0.layer.masksToBounds = true
        }
        
        bottomSheetHandlerView.do {
            $0.backgroundColor = .gray200
            $0.layer.cornerRadius = 2
        }
        
        flowLayout.do {
            $0.estimatedItemSize = .init(width: UIScreen.getDeviceWidth(), height: 56)
            $0.minimumLineSpacing = 12
            $0.scrollDirection = .vertical
        }
        
        totalListCollectionView.do {
            $0.backgroundColor = .white
            $0.register(TotalListCollectionViewCell.self, forCellWithReuseIdentifier: TotalListCollectionViewCell.className)
            $0.dragInteractionEnabled = true
        }
    }
    
    override func setupLayout() {
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        bottomSheetHandlerView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(9)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(44)
            $0.height.equalTo(4)
        }
        
        totalListCollectionView.snp.makeConstraints {
            //            $0.edges.equalToSuperview()
            $0.top.equalTo(bottomSheetHandlerView.snp.bottom).offset(10)
            $0.horizontalEdges.bottom.equalToSuperview()
        }
        
    }
}

extension TotalListBottomSheetView {
    func setupDelegate() {
        totalListCollectionView.delegate = self
        totalListCollectionView.dataSource = self
    }
}

extension TotalListBottomSheetView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TotalListCollectionViewCell.className, for: indexPath) as? TotalListCollectionViewCell else {
            return UICollectionViewCell()
        }
        let model = data[indexPath.row]
        cell.bindData(model: model)
        cell.makeRounded(radius: 10)
        //   cell.delegate = self
        return cell
    }
    
}

// MARK: - UICollectionViewDelegate

extension TotalListBottomSheetView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("CELL CLICK")
    }
}

extension TotalListBottomSheetView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 375, height: 104)
    }
}

//extension TotalListBottomSheetView: TotalListCollectionViewCellDelegate {
//    func addButtonDidTap(in cell: TotalListCollectionViewCell) {
//        let myzipVC = MyZipListBottomSheetViewController()
//        myzipVC.modalPresentationStyle = .fullScreen
//        present(myzipVC, animated: true, completion: nil)
//    }
//}
