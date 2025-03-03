//
//  ReportViewController.swift
//  Hankkijogbo
//
//  Created by 서은수 on 7/9/24.
//

import UIKit
import PhotosUI

final class ReportViewController: BaseViewController {
    
    // MARK: - Properties
    
    private let reportViewModel: ReportViewModel = ReportViewModel()
    private let searchViewModel: SearchViewModel = SearchViewModel()
    private var image: UIImage? {
        didSet {
            compositionalfactory.isImageSelected = (image != nil)
        }
    }
    private let headerLiterals = [StringLiterals.Report.categoryHeader, StringLiterals.Report.addMenuTitle]
    
    // MARK: - UI Components
    
    private let compositionalfactory: ReportCompositionalLayoutFactory = ReportCompositionalLayoutFactory()
    private lazy var compositionalLayout: UICollectionViewCompositionalLayout = compositionalfactory.create()
    private lazy var collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: compositionalLayout)
    private lazy var bottomButtonView: BottomButtonView = BottomButtonView(
        primaryButtonText: StringLiterals.Common.report,
        primaryButtonHandler: bottomButtonPrimaryHandler
    )
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupRegister()
        setupDelegate()
        bindViewModel()
        
        reportViewModel.getReportedNumberAPI()
        reportViewModel.getCategoryFilterAPI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
        
        setupNavigationBar()
        collectionView.reloadSections(IndexSet(integer: ReportSectionType.search.rawValue))
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    // MARK: - Setup UI
    
    override func setupHierarchy() {
        view.addSubviews(collectionView, bottomButtonView)
    }
    
    override func setupLayout() {
        collectionView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        bottomButtonView.snp.makeConstraints {
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(34)
            $0.height.equalTo(154)
        }
    }
    
    override func setupStyle() {
        collectionView.do {
            $0.backgroundColor = .hankkiWhite
            $0.showsVerticalScrollIndicator = false
        }
    }
    
    func bindViewModel() {
        reportViewModel.updateCollectionView = {
            self.collectionView.reloadData()
        }
        
        reportViewModel.updateButton = { isActive in
            if isActive {
                self.bottomButtonView.setupEnabledDoneButton()
            } else {
                self.bottomButtonView.setupDisabledDoneButton()
            }
        }
    }
}

// MARK: - Private Func

private extension ReportViewController {
    
    func setupRegister() {
        collectionView.register(SearchBarCollectionViewCell.self, forCellWithReuseIdentifier: SearchBarCollectionViewCell.className)
        collectionView.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: CategoryCollectionViewCell.className)
        collectionView.register(SelectImageCollectionViewCell.self, forCellWithReuseIdentifier: SelectImageCollectionViewCell.className)
        collectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: ImageCollectionViewCell.className)
        collectionView.register(MenuCollectionViewCell.self, forCellWithReuseIdentifier: MenuCollectionViewCell.className)
        collectionView.register(AddMenuCollectionViewCell.self, forCellWithReuseIdentifier: AddMenuCollectionViewCell.className)
        
        collectionView.register(
            ReportHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: ReportHeaderView.className
        )
        collectionView.register(
            BufferView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: BufferView.className
        )
    }
    
    func setupDelegate() {
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    func setupNavigationBar() {
        let type: HankkiNavigationType = HankkiNavigationType(hasBackButton: true,
                                                              hasRightButton: true,
                                                              mainTitle: .string(StringLiterals.Common.report),
                                                              rightButton: .string(""),
                                                              backButtonAction: setupAmplitudeToBackButton)
        
        if let navigationController = navigationController as? HankkiNavigationController {
            navigationController.setupNavigationBar(forType: type)
        }
    }
    
    func setupAmplitudeToBackButton() {
        SetupAmplitude.shared.logEvent(AmplitudeLiterals.Report.tabBack)
        navigationController?.popViewController(animated: true)
    }
    
    func scrollToFooterView() {
        let footerIndexPath = IndexPath(item: 0, section: ReportSectionType.addMenu.rawValue)
        collectionView.scrollToSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, indexPath: footerIndexPath, scrollPosition: .bottom, animated: true) // 제보하기의 Footer로 스크롤 이동
    }
    
    func removeImageData() {
        image = nil
        reportViewModel.selectedImageData = nil
    }
    
    /// 제보하기 API 호출
    /// - 성공하면 제보 완료 화면으로 넘어가게
    func postHankki() {
        // TODO: - 이 부분 코드 좀 더 고민해보기
        guard let locationData = reportViewModel.selectedLocationData else { return }
        reportViewModel.postHankkiAPI(locationData: locationData)
    }
    
    func addMenuData() {
        if reportViewModel.menus.count == 1 {
            updateFirstXButtonIsHidden()
        }
        
        reportViewModel.menus.append(MenuData())
        collectionView.insertItems(at: [IndexPath(item: reportViewModel.menus.count - 1, section: ReportSectionType.menu.rawValue)])
    }
    
    func updateFirstXButtonIsHidden() {
        guard let cell = collectionView.cellForItem(
            at: IndexPath(item: reportViewModel.menus.count - 1, section: ReportSectionType.menu.rawValue)
        ) as? MenuCollectionViewCell else { return }
        cell.deleteMenuButton.isHidden = false
    }
    
    func setupImagePickerView() {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 1
        configuration.filter = .any(of: [.images])
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
}

// MARK: - @objc Func

private extension ReportViewController {
    
    @objc func selectImageButtonDidTap() {
        setupImagePickerView()
        
        SetupAmplitude.shared.logEvent(AmplitudeLiterals.Report.tabFoodPicture)
    }
    
    @objc func imageXButtonDidTap() {
        removeImageData()
        collectionView.reloadSections(IndexSet(integer: ReportSectionType.image.rawValue))
    }
    
    @objc func searchBarButtonDidTap() {
        let searchViewController = SearchViewController(viewModel: searchViewModel)
        searchViewController.delegate = self
        navigationController?.pushViewController(searchViewController, animated: true)
    }
    
    /// 제보하기 호출
    @objc func bottomButtonPrimaryHandler() {
        postHankki()
    }
    
    /// 메뉴 셀 추가
    @objc func addMenuButtonDidTap() {
        addMenuData()
        scrollToFooterView()
    }
    
    /// 메뉴 셀 삭제
    @objc func deleteMenuButtonDidTap(_ sender: UIButton) {
        if !reportViewModel.menus.isEmpty {
            // 클릭된 버튼이 속해있는 셀의 IndexPath 구하기
            let buttonPosition = sender.convert(CGPoint.zero, to: self.collectionView)
            let itemIndexPath = self.collectionView.indexPathForItem(at: buttonPosition)
            
            guard let item = itemIndexPath?.item else { return }
            reportViewModel.menus.remove(at: item) // 해당 위치의 데이터 삭제
            collectionView.deleteItems(at: [IndexPath(item: item, section: ReportSectionType.menu.rawValue)]) // item 삭제
            collectionView.reloadSections(IndexSet(integer: ReportSectionType.menu.rawValue))
        }
    }
}

// MARK: - UICollectionView Delegate

extension ReportViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            guard let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: ReportHeaderView.className,
                for: indexPath
            ) as? ReportHeaderView else {
                return UICollectionReusableView()
            }
            header.bindData(headerLiterals[indexPath.section - 1])
            return header
        case UICollectionView.elementKindSectionFooter:
            guard let footer = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: BufferView.className,
                for: indexPath
            ) as? BufferView else {
                return UICollectionReusableView()
            }
            return footer
        default:
            return UICollectionReusableView()
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        5
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let sectionType = ReportSectionType(rawValue: section)
        switch sectionType {
        case .search, .image, .addMenu:
            return 1
        case .category:
            return reportViewModel.categories.count
        case .menu:
            return reportViewModel.menus.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let sectionType = ReportSectionType(rawValue: indexPath.section)
        switch sectionType {
        case .search:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchBarCollectionViewCell.className, for: indexPath) as? SearchBarCollectionViewCell else { return UICollectionViewCell() }
            if searchViewModel.isFinalSelected {
                cell.hankkiNameString = reportViewModel.selectedLocationData?.name
            }
            cell.searchBarButton.addTarget(self, action: #selector(searchBarButtonDidTap), for: .touchUpInside)
            cell.bindGuideText(text: reportViewModel.reportedNumberGuideText)
            return cell
        case .category:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.className, for: indexPath) as? CategoryCollectionViewCell else { return UICollectionViewCell() }
            cell.bindData(reportViewModel.categories[indexPath.row])
            return cell
        case .image:
            if let image = image {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.className, for: indexPath) as? ImageCollectionViewCell else { return UICollectionViewCell() }
                cell.changeImageButton.addTarget(self, action: #selector(selectImageButtonDidTap), for: .touchUpInside)
                cell.selectedImageView.image = image
                cell.imageXButton.addTarget(self, action: #selector(imageXButtonDidTap), for: .touchUpInside)
                return cell
            } else {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SelectImageCollectionViewCell.className, for: indexPath) as? SelectImageCollectionViewCell else { return UICollectionViewCell() }
                cell.selectImageButton.addTarget(self, action: #selector(selectImageButtonDidTap), for: .touchUpInside)
                return cell
            }
        case .menu:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MenuCollectionViewCell.className, for: indexPath) as? MenuCollectionViewCell else { return UICollectionViewCell() }
            cell.delegate = self
            cell.bindData(menu: reportViewModel.menus[indexPath.row], isOnlyOne: reportViewModel.menus.count == 1)
            cell.deleteMenuButton.addTarget(self, action: #selector(deleteMenuButtonDidTap(_:)), for: .touchUpInside)
            return cell
        case .addMenu:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddMenuCollectionViewCell.className, for: indexPath) as? AddMenuCollectionViewCell else { return UICollectionViewCell() }
            cell.addMenuButton.addTarget(self, action: #selector(addMenuButtonDidTap), for: .touchUpInside)
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    
    /// didSelectItemAt 전에 호출되는 메서드
    /// - 클릭된 카테고리를 한번 더 클릭 시 클릭을 해제시켜주기 위해 필요함
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        if collectionView.cellForItem(at: indexPath) as? CategoryCollectionViewCell != nil {
            if reportViewModel.categories[indexPath.row].isChecked {
                reportViewModel.categories[indexPath.row].isChecked = false
                return false
            }
        }
        return true
    }
    
    /// 다른 카테고리가 이미 선택되어 있다면 이를 해제하고 이번에 클릭된 카테고리를 활성화 시킨다
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.cellForItem(at: indexPath) as? CategoryCollectionViewCell != nil {
            reportViewModel.disableCheckedCategories()
            reportViewModel.categories[indexPath.row].isChecked = true
        }
    }
}

// MARK: - PHPickerViewController Delegate

extension ReportViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        let itemProvider = results.first?.itemProvider
        if let itemProvider = itemProvider, itemProvider.canLoadObject(ofClass: UIImage.self) {
            self.setupLoading(true, type: .fullView)

            itemProvider.loadObject(ofClass: UIImage.self) { (image, _) in
                
                if let image = image as? UIImage {
                    self.image = image
                    ImageCompressor.compress(image: image) { data in
                        if let compressedData = data {
                            self.reportViewModel.selectedImageData = compressedData
                            DispatchQueue.main.async {
                                self.collectionView.reloadSections(IndexSet(integer: ReportSectionType.image.rawValue))
                            }
                        } else {
                            DispatchQueue.main.async {
                                self.showAlert(titleText: StringLiterals.Alert.bigImageError,
                                               subText: StringLiterals.Alert.smallImagePlease,
                                               primaryButtonText: StringLiterals.Alert.check)
                            }
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        self.showAlert(titleText: StringLiterals.Alert.loadImageError,
                                       subText: StringLiterals.Alert.checkImagePlease,
                                       primaryButtonText: StringLiterals.Alert.check)
                    }
                }
                
                self.setupLoading(false, type: .fullView)
            }
        }
    }
}

// MARK: - UpdateViewModelMenuDataDelegate

extension ReportViewController: UpdateViewModelMenuDataDelegate {
    
    func updateViewModelMenuData(cell: MenuCollectionViewCell, name: String, price: String) {
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        reportViewModel.menus[indexPath.row] = MenuData(name: name, price: Int(price) ?? 0)
    }
}

// MARK: - UpdateViewModelLocationDataDelegate

extension ReportViewController: UpdateViewModelLocationDataDelegate {
    
    func updateViewModelLocationData(data: GetSearchedLocation?) {
        reportViewModel.selectedLocationData = data
    }
}
