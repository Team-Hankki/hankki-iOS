//
//  MyZipListBottomSheetViewController.swift
//  Hankkijogbo
//
//  Created by 서은수 on 7/7/24.
//

import UIKit

final class MyZipListBottomSheetViewController: BaseViewController {
    
    // MARK: - Properties
    
    var storeId: Int64
    
    private var clickedZipIndexPath: IndexPath?
    private var viewModel: MyZipViewModel = MyZipViewModel()
    private var isExpanded: Bool = false
    private var defaultHeight: CGFloat = UIScreen.getDeviceHeight() * 0.45
    private var expandedHeight: CGFloat = UIScreen.getDeviceHeight() * 0.9
    
    // MARK: - UI Components
    
    private let dimmedView: UIView = UIView()
    private let containerView: UIView = UIView()
    private let bottomSheetHandlerView: UIView = UIView()
    private let titleLabel: UILabel = UILabel()
    private let addNewZipButton: UIButton = UIButton()
    private let addNewZipLabel: UILabel = UILabel()
    private let addNewZipStackView: UIStackView = UIStackView()
    private let flowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    private lazy var myZipCollectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
    
    // MARK: - Init
    
    init(storeId: Int64) {
        self.storeId = storeId
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupGesture()
        setupDelegate()
        setupRegister()
        bindViewModel()
        
        showMyZipBottomSheet()
        viewModel.getMyZipListAPI(id: storeId)
    }
    
    // MARK: - Set UI
    
    override func setupHierarchy() {
        view.addSubviews(dimmedView, containerView)
        containerView.addSubviews(
            bottomSheetHandlerView,
            titleLabel,
            addNewZipStackView,
            myZipCollectionView
        )
        addNewZipStackView.addArrangedSubviews(addNewZipButton, addNewZipLabel)
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
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(bottomSheetHandlerView.snp.bottom).offset(18)
            $0.centerX.equalToSuperview()
        }
        
        addNewZipStackView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(18)
            $0.leading.trailing.equalToSuperview().inset(22)
            $0.height.equalTo(56)
        }
        
        addNewZipButton.snp.makeConstraints {
            $0.size.equalTo(56)
            $0.leading.equalToSuperview()
        }
        
        myZipCollectionView.snp.makeConstraints {
            $0.top.equalTo(addNewZipStackView.snp.bottom).offset(18)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    override func setupStyle() {
        view.do {
            $0.backgroundColor = .clear
        }
        
        dimmedView.do {
            $0.backgroundColor = .black.withAlphaComponent(0.67)
        }
        
        containerView.do {
            $0.isUserInteractionEnabled = true
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 32
            $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        }
        
        bottomSheetHandlerView.do {
            $0.backgroundColor = .gray200
            $0.layer.cornerRadius = 2
        }
        
        titleLabel.do {
            $0.attributedText = UILabel.setupAttributedText(
                for: PretendardStyle.subtitle3,
                withText: StringLiterals.MyZip.myHankkiZip,
                color: .gray850
            )
        }
        
        addNewZipStackView.do {
            $0.axis = .horizontal
            $0.spacing = 18
            $0.alignment = .center
        }
        
        addNewZipButton.do {
            $0.setImage(.imgCreateMyZip, for: .normal)
        }
        
        addNewZipLabel.do {
            $0.attributedText = UILabel.setupAttributedText(
                for: PretendardStyle.body3,
                withText: StringLiterals.MyZip.addNewZip,
                color: .gray800
            )
        }
        
        flowLayout.do {
            $0.estimatedItemSize = .init(width: UIScreen.getDeviceWidth(), height: 56)
            $0.headerReferenceSize = .init(width: UIScreen.getDeviceWidth(), height: 35)
            $0.minimumLineSpacing = 12
            $0.scrollDirection = .vertical
        }
        
        myZipCollectionView.do {
            $0.backgroundColor = .gray50
        }
    }
}

private extension MyZipListBottomSheetViewController {
    
    // MARK: - Private Func
    
    func bindViewModel() {
        viewModel.setMyZipListFavoriteData = {
            self.myZipCollectionView.reloadData()
        }
        
        viewModel.showAlert = { [weak self] _ in
            self?.showAlert(titleText: StringLiterals.Alert.unknownError,
                            subText: StringLiterals.Alert.tryAgain,
                            primaryButtonText: StringLiterals.Alert.check)
        }
        
        viewModel.showAddToZipCompleteToast = { [self] in
            guard let data = viewModel.myZipListFavoriteData else { return }
            NotificationCenter.default.post(Notification(name: NSNotification.Name(StringLiterals.NotificationName.setupBlackToast), object: nil, userInfo: ["zipId": Int(data[clickedZipIndexPath?.item ?? 0].id)]))
        }
    }
    
    func setupGesture() {
        let upSwipeGesture = UISwipeGestureRecognizer.init(target: self, action: #selector(containerViewDidUpSwipe))
        upSwipeGesture.direction = .up
        self.containerView.addGestureRecognizer(upSwipeGesture)
        let downSwipeGesture = UISwipeGestureRecognizer.init(target: self, action: #selector(containerViewDidDownSwipe))
        downSwipeGesture.direction = .down
        self.containerView.addGestureRecognizer(downSwipeGesture)
        let dimmedTapGesture = UITapGestureRecognizer(target: self, action: #selector(dimmedViewDidTap))
        self.dimmedView.addGestureRecognizer(dimmedTapGesture)
        let addNewZipTapGesture = UITapGestureRecognizer(target: self, action: #selector(addNewZipStackViewDidTap))
        addNewZipStackView.addGestureRecognizer(addNewZipTapGesture)
    }
    
    func setupDelegate() {
        myZipCollectionView.delegate = self
        myZipCollectionView.dataSource = self
    }
    
    func setupRegister() {
        myZipCollectionView.register(
            MyZipListHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: MyZipListHeaderView.className
        )
        myZipCollectionView.register(
            MyZipListCollectionViewCell.self,
            forCellWithReuseIdentifier: MyZipListCollectionViewCell.className
        )
    }
}

extension MyZipListBottomSheetViewController {
    
    // MARK: - Bottom Sheet
    
    func showMyZipBottomSheet() {
        containerView.snp.remakeConstraints {
            $0.bottom.width.equalToSuperview()
            $0.height.equalTo(defaultHeight)
        }
        viewLayoutIfNeededWithAnimation()
    }
    
    func dismissMyZipBottomSheet() {
        containerView.snp.remakeConstraints {
            $0.bottom.width.equalToSuperview()
            $0.height.equalTo(0)
        }
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {
            self.dimmedView.alpha = 0.0
            self.view.layoutIfNeeded()
        }, completion: { _ in
            self.dismiss(animated: false, completion: nil)
        })
    }
    
    func remakeContainerViewHeight(_ height: CGFloat) {
        containerView.snp.remakeConstraints {
            $0.bottom.width.equalToSuperview()
            $0.height.equalTo(height)
        }
    }
    
    func viewLayoutIfNeededWithAnimation() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn) {
            self.view.layoutIfNeeded()
        }
    }
}

private extension MyZipListBottomSheetViewController {
    
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
            dismissMyZipBottomSheet()
        }
        
        isExpanded = false
        remakeContainerViewHeight(updatedHeight)
        viewLayoutIfNeededWithAnimation()
    }
    
    @objc func dimmedViewDidTap() {
        dismissMyZipBottomSheet()
    }
    
    @objc func addNewZipStackViewDidTap () {
        dismissMyZipBottomSheet()
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootViewController = windowScene.windows.first?.rootViewController as? UINavigationController {
            let createZipViewController = CreateZipViewController()
            rootViewController.pushViewController(createZipViewController, animated: true)
        }
    }
    
    /// 내 족보 셀의 + 버튼 클릭 시 호출
    /// - 클릭된 버튼이 속해있는 셀의 IndexPath 계산
    /// - 내 족보에 식당 추가 POST API 호출
    @objc func addToMyZipButtonDidTap(_ sender: UIButton) {
        let buttonPosition = sender.convert(CGPoint.zero, to: self.myZipCollectionView)
        clickedZipIndexPath = self.myZipCollectionView.indexPathForItem(at: buttonPosition)

        guard let data = viewModel.myZipListFavoriteData else { return }
        
        // TODO: - 이미 추가된 족보일 때 앱 터지는 이슈
        viewModel.postHankkiToZipAPI(
            request: PostHankkiToZipRequestDTO(
                favoriteId: data[clickedZipIndexPath?.item ?? 0].id,
                storeId: storeId
            )
        )
        self.dismissMyZipBottomSheet()
    }
}

// MARK: - UICollectionViewDataSource

extension MyZipListBottomSheetViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.myZipListFavoriteData?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader,
              let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: MyZipListHeaderView.className,
                for: indexPath
              ) as? MyZipListHeaderView else {
            return UICollectionReusableView()
        }
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyZipListCollectionViewCell.className, for: indexPath) as? MyZipListCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.addZipButton.addTarget(self, action: #selector(addToMyZipButtonDidTap), for: .touchUpInside)
        if let data = viewModel.myZipListFavoriteData {
            cell.bindData(zipData: data[indexPath.item])
        }
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension MyZipListBottomSheetViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let data = viewModel.myZipListFavoriteData {
            
            let hankkiDetailViewController = HankkiDetailViewController(hankkiId: data[indexPath.item].id)
            navigationController?.pushViewController(hankkiDetailViewController, animated: true)
        }
    }
}
