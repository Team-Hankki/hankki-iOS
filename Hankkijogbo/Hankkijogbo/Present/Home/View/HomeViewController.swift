//
//  HomeViewController.swift
//  Hankkijogbo
//
//  Created by Gahyun Kim on 2024/06/21.
//

import UIKit

import NMapsMap

final class HomeViewController: BaseViewController, NetworkResultDelegate {
    
    // MARK: - Properties
    
    var viewModel = HomeViewModel()
    var isButtonModified: Bool = false
    var isDropDownVisible: Bool = false
    var isTypeCollectionViewVisible: Bool = false
    var currentDropDownButtonType: ButtonType?
    
    var selectedMarkerIndex: Int?
    var markers: [NMFMarker] = []
    var hankkiPins: [GetHankkiPinData] = []
    
    private var universityId: Int?
    
    var shouldUpdateNavigationBar: Bool = true
    
    var lastScrollPosition: CGPoint = .zero
    var isRestoringScrollPosition = false
    
    // MARK: - UI Components
    
    var typeCollectionView = TypeCollectionView()
    var rootView = HomeView()
    var customDropDown: DropDownView?
    var markerInfoCardView: MarkerInfoCardView?
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupMap()
        requestLocationAuthorization()
        setupDelegate()
        setupRegister()
        setupaddTarget()
        bindViewModel()
        setupHankkiListResult()
        setupLocation()
        
        NotificationCenter.default.addObserver(self, selector: #selector(locationStateUpdate(_:)), name:  NSNotification.Name(StringLiterals.NotificationName.locationDidUpdate), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.delegate = self
        setupNavigationBar()
        requestLocationAuthorization()
        NotificationCenter.default.addObserver(self, selector: #selector(getNotificationForMyZipList), name: NSNotification.Name(StringLiterals.NotificationName.presentMyZipBottomSheetNotificationName), object: nil)
        updateUniversityData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if !isRestoringScrollPosition {
            rootView.bottomSheetView.totalListCollectionView.setContentOffset(lastScrollPosition, animated: false)
            isRestoringScrollPosition = false
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        lastScrollPosition = rootView.bottomSheetView.totalListCollectionView.contentOffset
        isRestoringScrollPosition = false
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(StringLiterals.NotificationName.presentMyZipBottomSheetNotificationName), object: nil)
    }
    
    // MARK: - Set UI
    
    override func setupHierarchy() {
        view.addSubview(rootView)
    }
    
    override func setupLayout() {
        rootView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.bottom.equalToSuperview()
        }
    }
    
    private func bindViewModel() {
        viewModel.hankkiListsDidChange = { [weak self] data in
            guard let self = self else { return }
            
            self.viewModel.checkThumbnailHankkiValidation()
            
            DispatchQueue.main.async {
                self.rootView.bottomSheetView.data = data
                self.rootView.bottomSheetView.updateTotalListCount(count: data.count)
                self.rootView.bottomSheetView.totalListCollectionView.reloadData()
                self.rootView.bottomSheetView.setNeedsLayout()
                self.rootView.bottomSheetView.layoutIfNeeded()
            }
        }
        
        viewModel.hankkiPinsDidChange = { [weak self] pins in
            self?.hankkiPins = pins
            DispatchQueue.main.async {
                self?.setupPosition(with: pins)
            }
        }
        
        viewModel.showAlert = { [weak self] _ in
            self?.showAlert(titleText: StringLiterals.Alert.unknownError,
                            subText: StringLiterals.Alert.tryAgain,
                            primaryButtonText: StringLiterals.Alert.check)
        }
        
        viewModel.showHankkiListBottomSheet = {
            self.showHankkiListBottomSheet()
        }
        
        viewModel.getCategoryFilterAPI { [weak self] success in
            if success {
                DispatchQueue.main.async {
                    self?.rootView.typeFiletringCollectionView.collectionView.reloadData()
                }
            }
        }
    }
}

extension HomeViewController {
    private func setupDelegate() {
        rootView.typeFiletringCollectionView.collectionView.delegate = self
        rootView.typeFiletringCollectionView.collectionView.dataSource = self
        rootView.bottomSheetView.homeViewController = self
        rootView.bottomSheetView.delegate = self
        viewModel.delegate = self
    }
    
    private func setupRegister() {
        rootView.typeFiletringCollectionView.collectionView.register(TypeCollectionViewCell.self,
                                                                     forCellWithReuseIdentifier: TypeCollectionViewCell.className)
    }
    
    private func setupNavigationBar(mainTitle: String? = nil) {
        let title = mainTitle ?? UserDefaults.standard.getUniversity()?.name ?? StringLiterals.Home.entire
        
        let type: HankkiNavigationType = HankkiNavigationType(hasBackButton: false,
                                                              hasRightButton: false,
                                                              mainTitle: .stringAndImage(title, .icArrowUnder),
                                                              mainTitleFont: PretendardStyle.body5,
                                                              mainTitlePosition: "left",
                                                              rightButton: .string(""),
                                                              rightButtonAction: {},
                                                              titleButtonAction: presentUniversity)
        if let navigationController = navigationController as? HankkiNavigationController {
            navigationController.setupNavigationBar(forType: type)
            navigationController.isNavigationBarHidden = false
        }
    }
    
    private func setupaddTarget() {
        rootView.typeButton.addTarget(self, action: #selector(typeButtonDidTap), for: .touchUpInside)
        rootView.priceButton.addTarget(self, action: #selector(priceButtonDidTap), for: .touchUpInside)
        rootView.sortButton.addTarget(self, action: #selector(sortButtonDidTap), for: .touchUpInside)
        rootView.targetButton.addTarget(self, action: #selector(targetButtonDidTap), for: .touchUpInside)
        rootView.filteringFloatingButton.addTarget(self, action: #selector(floatingButtonDidTap), for: .touchUpInside)
    }
    
    func presentUniversity() {
        let univSelectViewController = UnivSelectViewController()
        univSelectViewController.delegate = self
        resetAllFilters()
        navigationController?.pushViewController(univSelectViewController, animated: true)
    }
}

extension HomeViewController {
    @objc func presentMyZipBottomSheet() {
        guard let thumbnailData = viewModel.hankkiThumbnail else { return }
        self.presentMyZipListBottomSheet(id: thumbnailData.id)
    }
    
    @objc func filteringBottomSheet() {
        let filteringBottomSheet = FilteringBottomSheetViewController()
        filteringBottomSheet.modalPresentationStyle = .overFullScreen
        self.present(filteringBottomSheet, animated: true, completion: nil)
    }
    
    @objc func getNotificationForMyZipList(_ notification: Notification) {
        if let indexPath = notification.userInfo?["itemIndexPath"] as? IndexPath {
            self.presentMyZipListBottomSheet(id: viewModel.hankkiLists[indexPath.item].id)
        }
    }
    
    @objc func setupBlackToast(_ notification: Notification) {
        if let zipId = notification.userInfo?["zipId"] as? Int {
            
            self.showBlackToast(message: StringLiterals.Toast.addToMyZipBlack) { [self] in
                let hankkiListViewController = ZipDetailViewController(zipId: zipId)
                navigationController?.pushViewController(hankkiListViewController, animated: true)
            }
        }
    }
    
    @objc func locationStateUpdate(_ notification: Notification) {
        if let university = notification.userInfo?["university"] as? UniversityModel {
            setupPosition(with: university)
        }
    }
}

private extension HomeViewController {
    func updateUniversityData() {
        let universityId = UserDefaults.standard.getUniversity()?.id
        viewModel.updateHankkiList()
        rootView.bottomSheetView.totalListCollectionView.reloadData()
    }
    
    func handleHankkiListResult(success: Bool, isEmpty: Bool) {
        if success {
            rootView.bottomSheetView.showEmptyView(isEmpty)
        } else {
            rootView.bottomSheetView.showEmptyView(true)
        }
    }
    
    func setupHankkiListResult() {
        viewModel.onHankkiListFetchCompletion = { [weak self] success, isEmpty in
            self?.handleHankkiListResult(success: success, isEmpty: isEmpty)
        }
    }
    
    func setupLocation() {
        if let savedUniversity = UserDefaults.standard.getUniversity(), savedUniversity.id != nil {
            moveCameraToUniversityLocation(savedUniversity)
        } else {
            if CLLocationManager.authorizationStatus() == .authorizedWhenInUse || CLLocationManager.authorizationStatus() == .authorizedAlways {
                requestLocationAuthorization()
            }
        }
    }
    
    func showHankkiListBottomSheet() {
        hideMarkerInfoCard()
        self.rootView.bottomSheetView.viewLayoutIfNeededWithDownAnimation()
    }
}

extension HomeViewController: NMFMapViewTouchDelegate, NMFMapViewCameraDelegate {
    func mapView(_ mapView: NMFMapView, didTapMap latlng: NMGLatLng, point: CGPoint) {
        showHankkiListBottomSheet()
    }
}

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == 0 {
            viewModel.selectedStoreCategoryIndex = indexPath.item
            viewModel.storeCategory = nil
            changeButtonTitle(for: rootView.typeButton, newTitle: "전체")
        } else if indexPath.item - 1 < viewModel.categoryFilters.count {
            let selectedCategory = viewModel.categoryFilters[indexPath.item - 1]
            viewModel.selectedStoreCategoryIndex = indexPath.item
            viewModel.storeCategory = selectedCategory.tag
            changeButtonTitle(for: rootView.typeButton, newTitle: selectedCategory.name)
        }
        collectionView.reloadData()
        collectionView.scrollToCenter(at: indexPath)
    }
}

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.categoryFilters.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TypeCollectionViewCell.className, for: indexPath) as? TypeCollectionViewCell else { return UICollectionViewCell() }
        
        if indexPath.item == 0 {
            cell.typeLabel.text = StringLiterals.Home.entire
            cell.thumbnailImageView.image = .imgAll
        } else if indexPath.item <= viewModel.categoryFilters.count {
            cell.bindData(model: viewModel.categoryFilters[indexPath.item - 1])
        } else {
            cell.bindData(model: GetCategoryFilterData(name: "", tag: "", imageUrl: ""))
        }
        
        let isSelected = indexPath.item == viewModel.selectedStoreCategoryIndex
        cell.updateSelection(isSelected: isSelected)
        
        return cell
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 58, height: 60)
    }
}

// DropDownViewDelegate
extension HomeViewController: DropDownViewDelegate {
    func dropDownView(_ controller: DropDownView, didSelectItem item: String, buttonType: ButtonType) {
        viewModel.getSortOptionFilterAPI { [self] _ in
            switch buttonType {
            case .price:
                if item == "K6" {
                    changeButtonTitle(for: rootView.priceButton, newTitle: StringLiterals.Home.less6000)
                } else {
                    changeButtonTitle(for: rootView.priceButton, newTitle: StringLiterals.Home.more6000)
                }
                viewModel.priceCategory = item
            case .sort:
                if let sortOption = viewModel.sortOptions.first(where: { $0.tag == item }) {
                    changeButtonTitle(for: rootView.sortButton, newTitle: sortOption.name)
                    viewModel.sortOption = item
                }
            }
            hideDropDown()
        }
    }
}

extension HomeViewController: UnivSelectViewControllerDelegate {
    func didRequestLocationFocus() {
        startLocationUpdates()
    }
    
    func didSelectUniversity(name: String) {
        setupNavigationBar(mainTitle: name)
    }
    
    func startLocationUpdates() {
        guard let manager = locationManager else { return }
        manager.startUpdatingLocation()
        
        setupNavigationBar(mainTitle: StringLiterals.Home.entire)
        fetchAllHankkiInfo()
    }
    
    func fetchAllHankkiInfo() {
        viewModel.getHankkiListAPI(storeCategory: "", priceCategory: "", sortOption: "") { _ in }
        viewModel.getHankkiPinAPI(storeCategory: "", priceCategory: "", sortOption: "") { _ in }
    }
}
