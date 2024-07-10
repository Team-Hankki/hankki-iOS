//
//  TotalListBottomSheetController.swift
//  Hankkijogbo
//
//  Created by Gahyun Kim on 7/9/24.
//

import UIKit

final class TotalListBottomSheetController: BaseViewController {
    
    // MARK: - Properties
    
    var isExpanded: Bool = false
    var defaultHeight: CGFloat = UIScreen.getDeviceHeight() * 0.4
    var expandedHeight: CGFloat = UIScreen.getDeviceHeight() * 0.8
    
    let data = dummyData
    
    // MARK: - UI Properties
    
    private let dimmedView = UIView()
    private let containerView = UIView()
    private let bottomSheetHandlerView = UIView()
    private let flowLayout = UICollectionViewFlowLayout()
    private lazy var totalListCollectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
    private let totalListCollectionViewCell = TotalListCollectionViewCell()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupGesture()
        setupDelegate()
        setupRegister()
        showMyZipBottomSheet()
       // setupAddTarget()
    }
    
    // MARK: - Set UI
    
    override func setupHierarchy() {
        view.addSubviews(dimmedView, containerView)
        containerView.addSubviews(bottomSheetHandlerView, totalListCollectionView)
    }
    
    override func setupLayout() {
        dimmedView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        containerView.snp.makeConstraints {
            $0.bottom.width.equalToSuperview()
            $0.height.equalTo(0)
        }
        
        bottomSheetHandlerView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(9)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(44)
            $0.height.equalTo(4)
        }
        
        totalListCollectionView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(30)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    override func setupStyle() {
        dimmedView.do {
            $0.backgroundColor = .black.withAlphaComponent(0.67)
        }
        
        containerView.do {
            $0.isUserInteractionEnabled = true
            $0.backgroundColor = .gray100
            $0.layer.cornerRadius = 30
            $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        }
        
        bottomSheetHandlerView.do {
            $0.backgroundColor = .gray200
            $0.layer.cornerRadius = 2
        }
        
        flowLayout.do {
            $0.estimatedItemSize = .init(width: UIScreen.getDeviceWidth(), height: 56)
            $0.headerReferenceSize = .init(width: UIScreen.getDeviceWidth(), height: 35)
            $0.minimumLineSpacing = 12
            $0.scrollDirection = .vertical
        }
        
        totalListCollectionView.do {
            $0.backgroundColor = .gray100
        }
    }
}

// MARK: - Private extension

private extension TotalListBottomSheetController {
    func setupGesture() {
        let upSwipeGesture = UISwipeGestureRecognizer.init(target: self, action: #selector(containerViewDidUpSwipe))
        upSwipeGesture.direction = .up
        containerView.addGestureRecognizer(upSwipeGesture)
        
        let downSwipeGesture = UISwipeGestureRecognizer.init(target: self, action: #selector(containerViewDidDownSwipe))
        downSwipeGesture.direction = .down
        containerView.addGestureRecognizer(downSwipeGesture)
        
        let dimmedTapGesture = UITapGestureRecognizer(target: self, action: #selector(dimmedViewDidTap))
        dimmedView.addGestureRecognizer(dimmedTapGesture)
    }
    
    func setupDelegate() {
        totalListCollectionView.delegate = self
        totalListCollectionView.dataSource = self
    }
    
    func setupRegister() {
        totalListCollectionView.register(
            TotalListCollectionViewCell.self,
            forCellWithReuseIdentifier: TotalListCollectionViewCell.className
        )
    }
    
//    func setupAddTarget() {
//        totalListCollectionViewCell.addButton.addTarget(self, action: #selector(actionButtonDipTap), for: .touchUpInside)
//    }
//    
//    @objc func actionButtonDipTap() {
//        print("BUTTON TAPPED")
//        let vc = MyZipListBottomSheetViewController()
//        navigationController?.pushViewController(vc, animated: true)
//    }
}

extension TotalListBottomSheetController {
    
    // MARK: - Bottom Sheet
    
    func showMyZipBottomSheet() {
        containerView.snp.remakeConstraints {
            $0.bottom.width.equalToSuperview()
            $0.height.equalTo(defaultHeight)
        }
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    func removeMyZipBottomSheet() {
        containerView.snp.remakeConstraints {
            $0.bottom.width.equalToSuperview()
            $0.height.equalTo(0)
        }
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {
            self.dimmedView.alpha = 0.0
            self.view.layoutIfNeeded()
        }, completion: { _ in
            if self.presentingViewController != nil {
                self.dismiss(animated: false, completion: nil)
            }
        })
    }
    
    func remakeContainerViewHeight(_ height: CGFloat) {
        containerView.snp.remakeConstraints {
            $0.bottom.width.equalToSuperview()
            $0.height.equalTo(height)
        }
    }
    
    func viewLayoutIfNeededWithAnimation() {
        UIView.animate(withDuration: 0.3,
                       delay: 0,
                       options: .curveEaseIn,
                       animations: {
            self.view.layoutIfNeeded()
        })
    }
}

private extension TotalListBottomSheetController {
    
    // MARK: - @objc
    
    @objc func containerViewDidUpSwipe() {
        isExpanded = true
        remakeContainerViewHeight(expandedHeight)
        viewLayoutIfNeededWithAnimation()
    }
    
    @objc func containerViewDidDownSwipe() {
        var updatedHeight = defaultHeight
        
        if isExpanded {
            updatedHeight = defaultHeight
        } else {
            updatedHeight = 0
            removeMyZipBottomSheet()
        }
        
        isExpanded = false
        remakeContainerViewHeight(updatedHeight)
        viewLayoutIfNeededWithAnimation()
    }
    
    @objc func dimmedViewDidTap() {
        removeMyZipBottomSheet()
    }
}

// MARK: - UICollectionViewDataSource

extension TotalListBottomSheetController: UICollectionViewDataSource {
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
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension TotalListBottomSheetController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("CELL CLICK")
    }
}

extension TotalListBottomSheetController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 331, height: 104)
    }
}
