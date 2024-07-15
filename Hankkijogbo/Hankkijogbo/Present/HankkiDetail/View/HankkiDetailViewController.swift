//
//  HankkiDetailViewController.swift
//  Hankkijogbo
//
//  Created by 서은수 on 7/15/24.
//

import UIKit

final class HankkiDetailViewController: BaseViewController {
    
    // MARK: - Properties
    
    var hankkiMenuDummy: [HankkiMenuDummy] = [
        HankkiMenuDummy(menuName: "수육 정식", menuPrice: 7900),
        HankkiMenuDummy(menuName: "수육 정식", menuPrice: 7900),
        HankkiMenuDummy(menuName: "수육 정식", menuPrice: 7900)
    ]
    lazy var hankkiInfo: HankkiInfo = HankkiInfo(
        hankkiName: "한끼네한정식한정식한끼네한정식한정식",
        hankkiCategory: "한식",
        hankkiMenu: hankkiMenuDummy
    )
    
    var hankkiDisappearOption: String = "식당이 사라졌어요"
    var priceLimitOption: String = "더이상 8,000원 이하인 메뉴가 없어요"
    var improperReportOption: String = "부적절한 제보예요"
    
    // MARK: - UI Components
    
    private let scrollView: UIScrollView = UIScrollView()
    private let contentView: UIView = UIView()
    private let whiteBackgroundView: UIView = UIView()
    private let backButton: UIButton = UIButton()
    private let thumbnailImageView: UIImageView = UIImageView()
    private var infoCollectionView: HankkiDetailCollectionView = HankkiDetailCollectionView()
    private var reportOptionCollectionView: HankkiReportOptionCollectionView = HankkiReportOptionCollectionView()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupRegister()
        setupDelegate()
        setupAddTarget()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.isNavigationBarHidden = true
        changeStatusBarBackgroundColor(color: .gray300)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.isNavigationBarHidden = false
        changeStatusBarBackgroundColor(color: .hankkiWhite)
    }
    
    // MARK: - Setup UI
    
    override func setupHierarchy() {
        view.addSubviews(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubviews(
            whiteBackgroundView,
            thumbnailImageView,
            backButton,
            infoCollectionView,
            reportOptionCollectionView
        )
    }
    
    override func setupLayout() {
        scrollView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalTo(UIScreen.getDeviceWidth())
        }
        thumbnailImageView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.height.equalTo(250)
        }
        whiteBackgroundView.snp.makeConstraints {
            $0.top.equalTo(thumbnailImageView.snp.bottom)
            $0.horizontalEdges.bottom.equalToSuperview()
        }
        backButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(15)
            $0.leading.equalToSuperview().inset(20)
            $0.size.equalTo(20)
        }
        infoCollectionView.snp.makeConstraints {
            $0.top.equalTo(thumbnailImageView.snp.bottom).offset(-37)
            $0.leading.equalToSuperview().inset(18)
        }
        reportOptionCollectionView.snp.makeConstraints {
            $0.top.equalTo(infoCollectionView.snp.bottom).offset(50)
            $0.horizontalEdges.equalToSuperview().inset(22)
            $0.bottom.equalToSuperview().inset(31)
        }
    }
    
    override func setupStyle() {
        scrollView.do {
            $0.backgroundColor = .clear
            $0.bounces = false
        }
        contentView.do {
            $0.backgroundColor = .gray300
        }
        thumbnailImageView.do {
            $0.backgroundColor = .gray300
        }
        whiteBackgroundView.do {
            $0.backgroundColor = .white
        }
        backButton.do {
            $0.setImage(.btnBackWhite, for: .normal)
        }
    }
}

private extension HankkiDetailViewController {
    
    // MARK: - Private Func
    
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
    
    /// - 상태바 배경색 변경
    func changeStatusBarBackgroundColor(color: UIColor) {
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        let window = windowScene?.windows.first
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let statusBarManager = windowScene.statusBarManager {
            let width = statusBarManager.statusBarFrame.width
            let height = statusBarManager.statusBarFrame.height
            
            let statusBarView = UIView(frame: .init(x: 0, y: 0, width: width, height: height + 5))
            statusBarView.backgroundColor = color
            
            window?.addSubview(statusBarView)
        }
    }
    
    func presentMyZipListBottomSheet() {
        let viewController = MyZipListBottomSheetViewController()
        viewController.modalTransitionStyle = .crossDissolve
        viewController.modalPresentationStyle = .overFullScreen
        self.present(viewController, animated: false, completion: nil)
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
        presentMyZipListBottomSheet()
    }
    
    @objc func hankkiReportButtonDidTap() {
         self.showAlert(
             image: "이미지 들어가야 됨",
             titleText: "한끼귀염님,\n변동사항을 알려주셔서 감사합니다 :)\n오늘도 저렴하고 든든한 식사하세요!",
             primaryButtonText: "돌아가기",
             primaryButtonHandler: dismissWithFadeOut
         )
     }
}

extension HankkiDetailViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < 0 {
            scrollView.bounces = false
        } else {
            scrollView.bounces = true
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
                header.dataBind(name: hankkiInfo.hankkiName, category: hankkiInfo.hankkiCategory)
                return header
            case UICollectionView.elementKindSectionFooter:
                guard let footer = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: HankkiDetailFooterView.className,
                    for: indexPath
                ) as? HankkiDetailFooterView else {
                    return UICollectionReusableView()
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
            hankkiMenuDummy.count + 1
        } else {
            3
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == infoCollectionView.collectionView {
            if indexPath.item == hankkiMenuDummy.count {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HankkiEditMenuCollectionViewCell.className, for: indexPath) as? HankkiEditMenuCollectionViewCell else { return UICollectionViewCell() }
                cell.editMenuButton.addTarget(self, action: #selector(editMenuButtonDidTap), for: .touchUpInside)
                return cell
            } else {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HankkiDetailCollectionViewCell.className, for: indexPath) as? HankkiDetailCollectionViewCell else { return UICollectionViewCell() }
                return cell
            }
        } else if collectionView == reportOptionCollectionView.collectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HankkiReportOptionCollectionViewCell.className, for: indexPath) as? HankkiReportOptionCollectionViewCell else { return UICollectionViewCell() }
            cell.delegate = self
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
