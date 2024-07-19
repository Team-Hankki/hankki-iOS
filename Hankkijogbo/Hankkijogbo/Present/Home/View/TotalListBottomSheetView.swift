//
//  TotalListBottomSheetView.swift
//  Hankkijogbo
//
//  Created by Gahyun Kim on 7/10/24.
//

import UIKit

final class TotalListBottomSheetView: BaseView {
    
    // MARK: - Properties
    
    var isExpanded: Bool = false
    var defaultHeight: CGFloat = UIScreen.getDeviceHeight() * 0.4
    var expandedHeight: CGFloat = UIScreen.getDeviceHeight() * 0.8
    var data: [GetHankkiListData] = []
    
    // MARK: - UI Components
    
    private let bottomSheetHandlerView = UIView()
    private let flowLayout = UICollectionViewFlowLayout()
    lazy var totalListCollectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
    private let containerView = UIView()
    private let cell = TotalListCollectionViewCell()
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupDelegate()
        setupGesture()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupHierarchy() {
        self.addSubviews(containerView)
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
            $0.register(TotalListCollectionViewCell.self,
                        forCellWithReuseIdentifier: TotalListCollectionViewCell.className)
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
            $0.top.equalTo(bottomSheetHandlerView.snp.bottom).offset(10)
            $0.horizontalEdges.bottom.equalToSuperview()
        }
        
        self.snp.makeConstraints {
            $0.width.equalTo(UIScreen.getDeviceWidth())
            $0.height.equalTo(UIScreen.getDeviceHeight() * 0.8)
        }
        
    }
}

extension TotalListBottomSheetView {
    func setupDelegate() {
        totalListCollectionView.delegate = self
        totalListCollectionView.dataSource = self
    }
    
    func setupGesture() {
        let upSwipeGesture = UISwipeGestureRecognizer.init(target: self, action: #selector(containerViewDidUpSwipe))
        upSwipeGesture.direction = .up
        self.addGestureRecognizer(upSwipeGesture)
        
        let downSwipeGesture = UISwipeGestureRecognizer.init(target: self, action: #selector(containerViewDidDownSwipe))
        downSwipeGesture.direction = .down
        self.addGestureRecognizer(downSwipeGesture)
    }
    
    func viewLayoutIfNeededWithUpAnimation() {
        UIView.animate(withDuration: 0.3,
                       delay: 0,
                       options: .curveEaseIn,
                       animations: {
            self.transform = .init(translationX: 0, y: -(UIScreen.getDeviceHeight() * 0.4))
        })
    }
    
    func viewLayoutIfNeededWithDownAnimation() {
        UIView.animate(withDuration: 0.3,
                       delay: 0,
                       options: .curveEaseIn,
                       animations: {
            self.transform = .identity
        })
    }
    
    func viewLayoutIfNeededWithHiddenAnimation() {
        UIView.animate(withDuration: 0.3,
                       delay: 0,
                       options: .curveEaseIn,
                       animations: {
            self.transform = .init(translationX: 0, y: (UIScreen.getDeviceHeight() * 0.4))
        })
    }
}

extension TotalListBottomSheetView {
    
    // MARK: - @objc
    
    @objc func containerViewDidUpSwipe() {
        isExpanded = true
        viewLayoutIfNeededWithUpAnimation()
    }
    
    @objc func containerViewDidDownSwipe() {
        isExpanded = false
        viewLayoutIfNeededWithDownAnimation()
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
        cell.bindData(model: data[indexPath.row])
        cell.makeRounded(radius: 10)
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension TotalListBottomSheetView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootViewController = windowScene.windows.first?.rootViewController as? UINavigationController {
            let hankkiDetailViewController = HankkiDetailViewController(hankkiId: data[indexPath.item].id)
            rootViewController.pushViewController(hankkiDetailViewController, animated: true)
        }
        
    }
}

extension TotalListBottomSheetView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = UIScreen.convertByWidthRatio(375)
        let height = UIScreen.convertByHeightRatio(104)
        return CGSize(width: width, height: height)
    }
}
