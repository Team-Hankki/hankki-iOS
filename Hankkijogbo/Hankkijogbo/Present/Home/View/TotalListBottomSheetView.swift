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
    var isBottomSheetUp: Bool = false
    var defaultHeight: CGFloat = UIScreen.getDeviceHeight() * 0.4
    var expandedHeight: CGFloat = UIScreen.getDeviceHeight() * 0.8
    
    var data: [GetHankkiListData] = []
    var presentMyZipBottomSheetNotificationName: String = "presentMyZipBottomSheetNotificationName"
    
    weak var homeViewController: HomeViewController?
    
    // MARK: - UI Components
    
    private let bottomSheetHandlerView: UIView = UIView()
    private let bottomGradientView: UIView = UIView()
    private let flowLayout = UICollectionViewFlowLayout()
    lazy var totalListCollectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
    private let containerView: UIView = UIView()
    private let cell = TotalListCollectionViewCell()
    
    private let emptyLabel: UILabel = UILabel()
    private let emptyView: UIImageView = UIImageView()
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupDelegate()
        setupGesture()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupBottomGradientView()
    }
    
    override func setupHierarchy() {
        self.addSubviews(containerView)
        containerView.addSubviews(
            bottomSheetHandlerView,
            totalListCollectionView,
            emptyView,
            emptyLabel
        )
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
            $0.minimumLineSpacing = 0
            $0.scrollDirection = .vertical
        }
        
        totalListCollectionView.do {
            $0.backgroundColor = .white
            $0.register(TotalListCollectionViewCell.self,
                        forCellWithReuseIdentifier: TotalListCollectionViewCell.className)
            $0.dragInteractionEnabled = true
        }
        
        emptyLabel.do {
            $0.text = StringLiterals.Home.emptyNotice
            $0.font = .setupPretendardStyle(of: .body2)
            $0.textColor = .gray400
            $0.textAlignment = .center
            $0.isHidden = true
        }
        
        emptyView.do {
            $0.image = .imgEmpty
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
            $0.top.equalTo(bottomSheetHandlerView.snp.bottom).offset(15)
            $0.horizontalEdges.bottom.equalToSuperview()
        }
        
        emptyView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(59)
        }
        
        emptyLabel.snp.makeConstraints {
            $0.top.equalTo(emptyView.snp.bottom).offset(25)
            $0.centerX.equalToSuperview()
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
                       options: .curveEaseOut,
                       animations: {
            self.transform = .init(translationX: 0, y: -(UIScreen.getDeviceHeight() * 0.4))
        }, completion: { _ in
            self.isBottomSheetUp = true
        })
    }
    
    func viewLayoutIfNeededWithDownAnimation() {
        UIView.animate(withDuration: 0.3,
                       delay: 0,
                       options: .curveEaseOut,
                       animations: {
            self.transform = .identity
        }, completion: { _ in
            self.isBottomSheetUp = false
        })
    }
    
    func viewLayoutIfNeededWithHiddenAnimation() {
        UIView.animate(withDuration: 0.3,
                       delay: 0,
                       options: .curveEaseOut,
                       animations: {
            self.transform = .init(translationX: 0, y: (UIScreen.getDeviceHeight() * 0.4))
        }, completion: { _ in
            self.isBottomSheetUp = false
        })
    }
    
    // Hankki List가 비어있을 경우 empty View 표출
    func showEmptyView(_ show: Bool) {
        emptyView.isHidden = !show
        emptyLabel.isHidden = !show
        totalListCollectionView.isHidden = show
    }
    
    func setupBottomGradientView() {
        
        bottomGradientView.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        
        let gradient = CAGradientLayer()
        
        gradient.do {
            $0.colors = [
                UIColor.gray700.withAlphaComponent(0).cgColor,
                UIColor.hankkiWhite.cgColor,
                UIColor.hankkiWhite.cgColor
            ]
            $0.locations = [0.0, 0.1, 1.0]
            $0.startPoint = CGPoint(x: 0.5, y: 0.0)
            $0.endPoint = CGPoint(x: 0.5, y: 1.0)
            $0.frame = bottomGradientView.bounds
        }
        
        bottomGradientView.layer.addSublayer(gradient)
    }
}

extension TotalListBottomSheetView {
    
    // MARK: - @objc
    
    @objc func containerViewDidUpSwipe() {
        isExpanded = true
        viewLayoutIfNeededWithUpAnimation()
        homeViewController?.hideAllFiltering()
    }
    
    @objc func containerViewDidDownSwipe() {
        isExpanded = false
        viewLayoutIfNeededWithDownAnimation()
    }
    
    @objc func addButtonDidTap(sender: UIButton) {
        // 클릭된 버튼이 속해있는 셀의 IndexPath 구하기
        let buttonPosition = sender.convert(CGPoint.zero, to: self.totalListCollectionView)
        let itemIndexPath = self.totalListCollectionView.indexPathForItem(at: buttonPosition)
        
        NotificationCenter.default.post(Notification(name: NSNotification.Name(presentMyZipBottomSheetNotificationName), object: nil, userInfo: ["itemIndexPath": itemIndexPath ?? IndexPath()]))
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
//        let store = data[indexPath.row]
//        if let imageUrl = store.imageUrl, imageUrl != "img_detail_default" {
//                   // URL에서 이미지를 로드
//            cell.thumbnailImageView.sd_setImage(with: URL(string: imageUrl))
//               } else {
//                   // 기본 이미지 설정
//                   cell.thumbnailImageView?.image = UIImage(named: "img_detail_default")
//               }
        cell.bindData(model: data[indexPath.row])
        cell.makeRoundBorder(cornerRadius: 10, borderWidth: 0, borderColor: .clear)
        cell.addButton.addTarget(self, action: #selector(addButtonDidTap), for: .touchUpInside)
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
