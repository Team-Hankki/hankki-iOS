//
//  HankkiDetailViewController.swift
//  Hankkijogbo
//
//  Created by 서은수 on 7/15/24.
//

import UIKit

final class HankkiDetailViewController: BaseViewController, NetworkResultDelegate {
    
    // MARK: - Properties
    
    var viewModel: HankkiDetailViewModel
    
    // MARK: - UI Components
    
    private let scrollView: UIScrollView = UIScrollView()
    private let contentView: UIView = UIView()
    private let backButton: UIButton = UIButton()
    private let topBlackGradientImageView: UIImageView = UIImageView()
    private let thumbnailImageView: UIImageView = UIImageView()
    private let differentInfoView: DifferentInfoView = DifferentInfoView()
    private let hankkiInfoView: HankkiInfoView = HankkiInfoView()
    private let detailMapView: DetailMapView = DetailMapView()
    private let menuCollectionView: HankkiMenuCollectionView = HankkiMenuCollectionView()
    private let precautionView: PrecautionView = PrecautionView()
    
    // MARK: - Life Cycle
    
    init(viewModel: HankkiDetailViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupRegister()
        setupDelegate()
        setupAddTarget()
        setupGesture()
        setupNotification()
        bindViewModel()
        getHankkiDetail()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.isNavigationBarHidden = false
    }
    
    // MARK: - Setup UI
    
    override func setupHierarchy() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubviews(
            thumbnailImageView,
            backButton,
            differentInfoView,
            hankkiInfoView,
            detailMapView,
            menuCollectionView,
            precautionView
        )
        thumbnailImageView.addSubview(topBlackGradientImageView)
    }
    
    override func setupLayout() {
        scrollView.snp.makeConstraints {
            $0.top.equalTo(self.view).offset(-UIApplication.getStatusBarHeight())
            $0.horizontalEdges.bottom.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalTo(UIScreen.getDeviceWidth())
        }
        
        thumbnailImageView.snp.makeConstraints {
            $0.top.width.equalToSuperview()
            $0.height.equalTo(235)
        }
        
        topBlackGradientImageView.snp.makeConstraints {
            $0.top.equalTo(self.scrollView)
            $0.size.equalTo(thumbnailImageView)
        }
        
        backButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(48.5)
            $0.leading.equalToSuperview().inset(7)
            $0.size.equalTo(40)
        }
        
        differentInfoView.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(15)
            $0.bottom.equalTo(thumbnailImageView.snp.bottom).offset(-12)
        }
        
        hankkiInfoView.snp.makeConstraints {
            $0.top.equalTo(thumbnailImageView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(116)
        }
        
        detailMapView.snp.makeConstraints {
            $0.top.equalTo(hankkiInfoView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(260)
        }
        
        menuCollectionView.snp.makeConstraints {
            $0.top.equalTo(detailMapView.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview()
        }

        precautionView.snp.makeConstraints {
            $0.top.equalTo(menuCollectionView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(169)
        }
    }
    
    override func setupStyle() {
        view.do {
            $0.backgroundColor = .gray100
        }
        
        scrollView.do {
            $0.backgroundColor = .clear
        }
        
        backButton.do {
            $0.setImage(.btnBackWhite, for: .normal)
        }
    }
}

private extension HankkiDetailViewController {
    
    // MARK: - Private Func
    
    func bindViewModel() {
        viewModel.setHankkiDetailData = { [weak self] in
            if let self = self,
               let data = viewModel.hankkiDetailData {
                if let first = data.imageUrls.first {
                    setupImageStyle(imageUrl: first)
                } else {
                    setupNoImageStyle()
                }
                
                hankkiInfoView.bindData(
                    category: data.category,
                    categoryImageUrl: data.categoryImageUrl,
                    name: data.name,
                    heartCount: String(data.heartCount),
                    isLiked: data.isLiked
                )
                detailMapView.bindData(latitude: data.latitude, longitude: data.longitude)
                
                menuCollectionView.updateLayout(menuSize: data.menus.count)
                menuCollectionView.collectionView.reloadData()
            }
        }
        
        viewModel.showAlert = { [weak self] _ in
            self?.showAlert(titleText: StringLiterals.Alert.unknownError,
                            subText: StringLiterals.Alert.tryAgain,
                            primaryButtonText: StringLiterals.Alert.check)
        }
        
        viewModel.dismiss = {
            self.navigationController?.popViewController(animated: false)
        }
    }
    
    func setupRegister() {
        menuCollectionView.collectionView.do {
            $0.register(HankkiMenuCollectionViewCell.self, forCellWithReuseIdentifier: HankkiMenuCollectionViewCell.className)
            $0.register(
                HankkiMenuHeaderView.self,
                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                withReuseIdentifier: HankkiMenuHeaderView.className
            )
            $0.register(
                HankkiMenuFooterView.self,
                forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                withReuseIdentifier: HankkiMenuFooterView.className
            )
        }
    }
    
    func setupDelegate() {
        viewModel.delegate = self
        scrollView.delegate = self
        menuCollectionView.collectionView.delegate = self
        menuCollectionView.collectionView.dataSource = self
    }
    
    func setupAddTarget() {
        backButton.addTarget(self, action: #selector(backButtonDidTap), for: .touchUpInside)
        hankkiInfoView.heartButton.addTarget(self, action: #selector(heartButtonDidTap), for: .touchUpInside)
        hankkiInfoView.myZipButton.addTarget(self, action: #selector(myZipButtonDidTap), for: .touchUpInside)
    }
    
    func setupGesture() {
        let rightSwipeGesture = UISwipeGestureRecognizer.init(target: self, action: #selector(backButtonDidTap))
        rightSwipeGesture.direction = .right
        view.addGestureRecognizer(rightSwipeGesture)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(differentInfoViewDidTap))
        differentInfoView.addGestureRecognizer(tapGesture)
    }
    
    func setupNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(reloadHankkiDetailNotification),
            name: NSNotification.Name(StringLiterals.NotificationName.reloadHankkiDetail),
            object: nil
        )
    }
    
    func getHankkiDetail() {
        viewModel.getHankkiDetailAPI()
    }
    
    func setupNoImageStyle() {
        contentView.do {
            $0.backgroundColor = .gray100
        }
        thumbnailImageView.do {
            $0.image = .imgDetailDefault
        }
        topBlackGradientImageView.do {
            $0.image = nil
        }
    }
    
    func setupImageStyle(imageUrl: String) {
        thumbnailImageView.do {
            $0.setKFImage(url: imageUrl)
            $0.contentMode = .scaleAspectFill
            $0.clipsToBounds = true
        }
        topBlackGradientImageView.do {
            $0.image = .imgBlackGradient
        }
    }
}

extension HankkiDetailViewController {
    
    // MARK: - @objc Func
    
    @objc func backButtonDidTap() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func heartButtonDidTap() {
        guard let data = viewModel.hankkiDetailData else { return }
        
        if !data.isLiked {
            self.viewModel.postHankkiHeartAPI()
        } else {
            self.viewModel.deleteHankkiHeartAPI()
        }
    }
    
    @objc func myZipButtonDidTap() {
        presentMyZipListBottomSheet(id: viewModel.hankkiId)
    }
    
    @objc func editMenuButtonDidTap() {
        SetupAmplitude.shared.logEvent(AmplitudeLiterals.Detail.tabMenuEdit)
        
        guard let menus = viewModel.hankkiDetailData?.menus else { return }
        
        let editHankkiBottomSheet = HankkiNavigationController(
            rootViewController: EditHankkiBottomSheetViewController(storeId: viewModel.hankkiId, menus: menus)
        )
        editHankkiBottomSheet.modalTransitionStyle = .crossDissolve
        editHankkiBottomSheet.modalPresentationStyle = .overFullScreen
        self.present(editHankkiBottomSheet, animated: true, completion: nil)
    }
    
    @objc func differentInfoViewDidTap() {
        let removeHankkiViewController = RemoveHankkiViewController(viewModel: viewModel)
        self.navigationController?.pushViewController(removeHankkiViewController, animated: true)
    }
    
    @objc func setupBlackToast(_ notification: Notification) {
        if let zipId = notification.userInfo?["zipId"] as? Int {
            
            self.showBlackToast(message: StringLiterals.Toast.addToMyZipBlack) { [self] in
                let hankkiListViewController = HankkiListViewController(.myZip, zipId: zipId)
                navigationController?.pushViewController(hankkiListViewController, animated: true)
            }
        }
    }
    
    @objc func reloadHankkiDetailNotification() {
        getHankkiDetail()
    }
}

extension HankkiDetailViewController {
    
    /// 상단의 bounces만 비활성화
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < -UIApplication.getStatusBarHeight() {
            scrollView.contentOffset.y = -UIApplication.getStatusBarHeight()
        }
    }
}

// MARK: - UICollectionView Delegate

extension HankkiDetailViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            guard let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: HankkiMenuHeaderView.className,
                for: indexPath
            ) as? HankkiMenuHeaderView else {
                return UICollectionReusableView()
            }
            if let data = viewModel.hankkiDetailData {
                header.bindData(menuNumber: String(data.menus.count))
            }
            return header
        case UICollectionView.elementKindSectionFooter:
            guard let footer = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: HankkiMenuFooterView.className,
                for: indexPath
            ) as? HankkiMenuFooterView else {
                return UICollectionReusableView()
            }
            footer.editButton.addTarget(self, action: #selector(editMenuButtonDidTap), for: .touchUpInside)
            return footer
        default:
            return UICollectionReusableView()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.hankkiDetailData?.menus.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HankkiMenuCollectionViewCell.className, for: indexPath) as? HankkiMenuCollectionViewCell else { return UICollectionViewCell() }
        if let data = viewModel.hankkiDetailData {
            cell.bindData(data.menus[indexPath.item])
            return cell
        }
        return UICollectionViewCell()
    }
}
