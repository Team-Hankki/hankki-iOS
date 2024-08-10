//
//  HankkiDetailViewController.swift
//  Hankkijogbo
//
//  Created by 서은수 on 7/15/24.
//

import UIKit

final class HankkiDetailViewController: BaseViewController {
    
    // MARK: - Properties
    
    let hankkiId: Int64
    var viewModel: HankkiDetailViewModel = HankkiDetailViewModel()
    var reportOptionArray: [String] = [
        "식당이 사라졌어요",
        "더이상 8,000원 이하인 메뉴가 없어요",
        "부적절한 제보예요"
    ]
    
    // MARK: - UI Components
    
    private let scrollView: UIScrollView = UIScrollView()
    private let contentView: UIView = UIView()
    private let lightGrayBackgroundView: UIView = UIView()
    private let backButton: UIButton = UIButton()
    private let thumbnailImageView: UIImageView = UIImageView()
    private let topBlackGradientImageView: UIImageView = UIImageView()
    private var infoCollectionView: HankkiDetailCollectionView = HankkiDetailCollectionView()
    private var reportOptionCollectionView: HankkiReportOptionCollectionView = HankkiReportOptionCollectionView()
    
    // MARK: - Life Cycle
    
    init(hankkiId: Int64) {
        self.hankkiId = hankkiId
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
        bindViewModel()
        
        viewModel.getHankkiDetailAPI(hankkiId: hankkiId)
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
            lightGrayBackgroundView,
            thumbnailImageView,
            backButton,
            infoCollectionView,
            reportOptionCollectionView
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
            $0.height.equalTo(250)
        }
        topBlackGradientImageView.snp.makeConstraints {
            $0.top.equalTo(self.scrollView)
            $0.size.equalTo(thumbnailImageView)
        }
        lightGrayBackgroundView.snp.makeConstraints {
            $0.top.equalTo(thumbnailImageView.snp.bottom)
            $0.horizontalEdges.bottom.equalToSuperview()
        }
        backButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(UIApplication.getStatusBarHeight() + 15)
            $0.leading.equalToSuperview().inset(20)
            $0.size.equalTo(20)
        }
        infoCollectionView.snp.makeConstraints {
            $0.top.equalTo(thumbnailImageView.snp.bottom).offset(-40)
            $0.centerX.equalToSuperview()
        }
        reportOptionCollectionView.snp.makeConstraints {
            $0.top.equalTo(infoCollectionView.snp.bottom).offset(50)
            $0.horizontalEdges.equalToSuperview().inset(22)
            $0.bottom.equalToSuperview().inset(31)
        }
    }
    
    override func setupStyle() {
        view.do {
            $0.backgroundColor = .gray50
        }
        scrollView.do {
            $0.backgroundColor = .clear
        }
        lightGrayBackgroundView.do {
            $0.backgroundColor = .gray50
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
            if let data = self?.viewModel.hankkiDetailData {
                // TODO: - 디폴트 사진일 경우를 구별
                if let first = data.imageUrls.first {
                    self?.setupImageStyle(imageUrl: first)
                } else {
                    self?.setupNoImageStyle()
                }
                self?.infoCollectionView.updateLayout(menuSize: data.menus.count)
                self?.infoCollectionView.collectionView.layoutIfNeeded()
                self?.infoCollectionView.collectionView.reloadData()
            }
        }
        
        viewModel.showAlert = { [weak self] _ in
            self?.showAlert(titleText: "알 수 없는 오류가 발생했어요",
                            subText: "네트워크 연결 상태를 확인하고\n다시 시도해주세요",
                            primaryButtonText: "확인")
        }
    }
    
    func setupRegister() {
        infoCollectionView.collectionView.do {
            $0.register(HankkiDetailCollectionViewCell.self, forCellWithReuseIdentifier: HankkiDetailCollectionViewCell.className)
            $0.register(HankkiEditMenuCollectionViewCell.self, forCellWithReuseIdentifier: HankkiEditMenuCollectionViewCell.className)
            $0.register(
                HankkiDetailHeaderView.self,
                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                withReuseIdentifier: HankkiDetailHeaderView.className
            )
            $0.register(
                HankkiDetailFooterView.self,
                forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                withReuseIdentifier: HankkiDetailFooterView.className
            )
        }
        
        reportOptionCollectionView.collectionView.do {
            $0.register(HankkiReportOptionCollectionViewCell.self, forCellWithReuseIdentifier: HankkiReportOptionCollectionViewCell.className)
            $0.register(
                HankkiReportOptionHeaderView.self,
                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                withReuseIdentifier: HankkiReportOptionHeaderView.className
            )
            $0.register(
                HankkiReportOptionFooterView.self,
                forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                withReuseIdentifier: HankkiReportOptionFooterView.className
            )
        }
    }
    
    func setupDelegate() {
        scrollView.delegate = self
        infoCollectionView.collectionView.delegate = self
        infoCollectionView.collectionView.dataSource = self
        reportOptionCollectionView.collectionView.delegate = self
        reportOptionCollectionView.collectionView.dataSource = self
    }
    
    func setupAddTarget() {
        backButton.addTarget(self, action: #selector(backButtonDidTap), for: .touchUpInside)
    }
    
    func setupGesture() {
        let rightSwipeGesture = UISwipeGestureRecognizer.init(target: self, action: #selector(backButtonDidTap))
        rightSwipeGesture.direction = .right
        self.view.addGestureRecognizer(rightSwipeGesture)
    }
    
    func setupNoImageStyle() {
        contentView.do {
            $0.backgroundColor = .gray300
        }
        thumbnailImageView.do {
            $0.backgroundColor = .gray300
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
    
    @objc func editMenuButtonDidTap() {
        self.showAlert(
            titleText: "조금만 기다려주세요!",
            subText: "메뉴를 편집할 수 있도록\n준비하고 있어요",
            primaryButtonText: "확인",
            primaryButtonHandler: dismissWithFadeOut
        )
    }
    
    @objc func addMyZipButtonDidTap() {
        presentMyZipListBottomSheet(id: hankkiId)
    }
    
    @objc func hankkiReportButtonDidTap() {
        self.showAlert(
            image: .imgModalReport,
            titleText: "변동사항을 알려주셔서 감사합니다 :)\n오늘도 저렴하고 든든한 식사하세요!",
            primaryButtonText: "돌아가기",
            primaryButtonHandler: dismissWithFadeOut
        )
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
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if collectionView == infoCollectionView.collectionView {
            switch kind {
            case UICollectionView.elementKindSectionHeader:
                guard let header = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: HankkiDetailHeaderView.className,
                    for: indexPath
                ) as? HankkiDetailHeaderView else {
                    return UICollectionReusableView()
                }
                if let data = viewModel.hankkiDetailData {
                    header.bindData(name: data.name, category: data.category)
                }
                return header
            case UICollectionView.elementKindSectionFooter:
                guard let footer = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: HankkiDetailFooterView.className,
                    for: indexPath
                ) as? HankkiDetailFooterView else {
                    return UICollectionReusableView()
                }
                footer.likedButton.buttonHandler = {
                    if !footer.isLiked {
                        self.viewModel.postHankkiHeartAPI(id: Int64(self.hankkiId)) {
                            footer.updateLikeButtonStatus()
                        }
                    } else {
                        self.viewModel.deleteHankkiHeartAPI(id: Int64(self.hankkiId)) {
                            footer.updateLikeButtonStatus()
                        }
                    }
                }
                if let data = viewModel.hankkiDetailData {
                    footer.isLiked = data.isLiked
                    footer.likedNumber = data.heartCount
                    
                }
                footer.addMyZipButton.hankkiDetailButton.addTarget(self, action: #selector(addMyZipButtonDidTap), for: .touchUpInside)
                return footer
            default:
                return UICollectionReusableView()
            }
        } else if collectionView == reportOptionCollectionView.collectionView {
            switch kind {
            case UICollectionView.elementKindSectionHeader:
                guard let header = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: HankkiReportOptionHeaderView.className,
                    for: indexPath
                ) as? HankkiReportOptionHeaderView else {
                    return UICollectionReusableView()
                }
                return header
            case UICollectionView.elementKindSectionFooter:
                guard let footer = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: HankkiReportOptionFooterView.className,
                    for: indexPath
                ) as? HankkiReportOptionFooterView else {
                    return UICollectionReusableView()
                }
                return footer
            default:
                return UICollectionReusableView()
            }
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == infoCollectionView.collectionView {
            (viewModel.hankkiDetailData?.menus.count ?? 0) + 1
        } else {
            reportOptionArray.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == infoCollectionView.collectionView {
            if indexPath.item == viewModel.hankkiDetailData?.menus.count {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HankkiEditMenuCollectionViewCell.className, for: indexPath) as? HankkiEditMenuCollectionViewCell else { return UICollectionViewCell() }
                cell.editMenuButton.addTarget(self, action: #selector(editMenuButtonDidTap), for: .touchUpInside)
                return cell
            } else {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HankkiDetailCollectionViewCell.className, for: indexPath) as? HankkiDetailCollectionViewCell else { return UICollectionViewCell() }
                if let data = viewModel.hankkiDetailData {
                    cell.bindMenuData(data.menus[indexPath.item])
                }
                return cell
            }
        } else if collectionView == reportOptionCollectionView.collectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HankkiReportOptionCollectionViewCell.className, for: indexPath) as? HankkiReportOptionCollectionViewCell else { return UICollectionViewCell() }
            cell.delegate = self
            cell.bindData(text: reportOptionArray[indexPath.item])
            return cell
        }
        return UICollectionViewCell()
    }
}

// MARK: - UpdateReportButtonStyle Delegate

extension HankkiDetailViewController: UpdateReportButtonStyleDelegate {
    func updateReportButtonStyle(isEnabled: Bool) {
        guard let footer = reportOptionCollectionView.collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: HankkiReportOptionFooterView.className, for: IndexPath(item: 3, section: 0)) as? HankkiReportOptionFooterView else { return }
        
        if isEnabled {
            footer.hankkiReportButton.setupEnabledButton()
            footer.hankkiReportButton.addTarget(
                self,
                action: #selector(hankkiReportButtonDidTap),
                for: .touchUpInside
            )
        } else {
            footer.hankkiReportButton.setupDisabledButton()
        }
    }
}
