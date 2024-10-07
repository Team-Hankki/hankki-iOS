//
//  HomeViewController.swift
//  Hankkijogbo
//
//  Created by Gahyun Kim on 2024/06/21.
//

import UIKit

import NMapsMap

final class HomeViewController: BaseViewController {
    
    // MARK: - Properties
    
    var viewModel = HomeViewModel()
    var isButtonModified: Bool = false
    var isDropDownVisible: Bool = false
    var isTypeCollectionViewVisible: Bool = false
    var currentDropDownButtonType: ButtonType?
    
    var selectedMarkerIndex: Int?
    var markers: [NMFMarker] = []
    
    private var universityId: Int?
    
    var shouldUpdateNavigationBar: Bool = true
    
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
        
        setupNavigationBar()
        requestLocationAuthorization()
        NotificationCenter.default.addObserver(self, selector: #selector(getNotificationForMyZipList), name: NSNotification.Name(StringLiterals.NotificationName.presentMyZipBottomSheetNotificationName), object: nil)
        updateUniversityData()
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
            DispatchQueue.main.async {
                self.rootView.bottomSheetView.data = data
                self.rootView.bottomSheetView.totalListCollectionView.reloadData()
                self.rootView.bottomSheetView.setNeedsLayout()
                self.rootView.bottomSheetView.layoutIfNeeded()
            }
        }
        
        viewModel.hankkiPinsDidChange = { [weak self] pins in
            DispatchQueue.main.async {
                self?.setupPosition(with: pins)
            }
        }
        
        viewModel.showAlert = { [weak self] message in
            self?.showAlert(titleText: StringLiterals.Alert.unknownError,
                            subText: StringLiterals.Alert.tryAgain,
                            primaryButtonText: StringLiterals.Alert.check)
        }
    }
}

extension HomeViewController {
    private func setupDelegate() {
        typeCollectionView.collectionView.delegate = self
        typeCollectionView.collectionView.dataSource = self
        rootView.bottomSheetView.homeViewController = self
    }
    
    private func setupRegister() {
        typeCollectionView.collectionView.register(TypeCollectionViewCell.self,
                                                   forCellWithReuseIdentifier: TypeCollectionViewCell.className)
    }
    
    private func setupNavigationBar(mainTitle: String? = nil) {
        let title = mainTitle ?? UserDefaults.standard.getUniversity()?.name ?? StringLiterals.Home.allUniversity
        
        let type: HankkiNavigationType = HankkiNavigationType(hasBackButton: false,
                                                              hasRightButton: false,
                                                              mainTitle: .stringAndImageDouble(title, .icSchool, .icArrowUnder),
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
    }
    
    func presentUniversity() {
        let univSelectViewController = UnivSelectViewController()
        univSelectViewController.delegate = self
        resetAllFilters()
        navigationController?.pushViewController(univSelectViewController, animated: true)
    }
    
    @objc func presentMyZipBottomSheet() {
        guard let thumbnailData = viewModel.hankkiThumbnail else { return }
        self.presentMyZipListBottomSheet(id: thumbnailData.id)
    }
    
    @objc func getNotificationForMyZipList(_ notification: Notification) {
        if let indexPath = notification.userInfo?["itemIndexPath"] as? IndexPath {
            self.presentMyZipListBottomSheet(id: viewModel.hankkiLists[indexPath.item].id)
        }
    }
    
    @objc func setupBlackToast(_ notification: Notification) {
        if let zipId = notification.userInfo?["zipId"] as? Int {
            
            self.showBlackToast(message: StringLiterals.Toast.addToMyZipBlack) { [self] in
                let hankkiListViewController = HankkiListViewController(.myZip, zipId: zipId)
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
    func loadInitialData() {
        universityId = UserDefaults.standard.getUniversity()?.id
        viewModel.getHankkiListAPI(universityId: universityId, storeCategory: "", priceCategory: "", sortOption: "") { [weak self] success in
            let isEmpty = self?.viewModel.hankkiLists.isEmpty ?? true
            self?.viewModel.onHankkiListFetchCompletion?(success, isEmpty)
        }
        viewModel.getHankkiPinAPI(universityId: universityId, storeCategory: "", priceCategory: "", sortOption: "", completion: { _ in })
    }
    
    func updateUniversityData() {
        let universityId = UserDefaults.standard.getUniversity()?.id
        
        viewModel.getHankkiListAPI(universityId: universityId, storeCategory: "", priceCategory: "", sortOption: "") { [weak self] success in
            let isEmpty = self?.viewModel.hankkiLists.isEmpty ?? true
            self?.viewModel.onHankkiListFetchCompletion?(success, isEmpty)
        }
        viewModel.getHankkiPinAPI(universityId: universityId, storeCategory: "", priceCategory: "", sortOption: "", completion: { _ in })
        rootView.bottomSheetView.totalListCollectionView.reloadData()
        
        // 대학 선택 후 홈화면 재진입 시 해당 대학교에 맞게 reset
        hideMarkerInfoCard()
        rootView.bottomSheetView.viewLayoutIfNeededWithDownAnimation()
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
}

extension HomeViewController: NMFMapViewTouchDelegate, NMFMapViewCameraDelegate {
    func mapView(_ mapView: NMFMapView, didTapMap latlng: NMGLatLng, point: CGPoint) {
        self.rootView.bottomSheetView.viewLayoutIfNeededWithDownAnimation()
        self.hideMarkerInfoCard()
    }
}

// CollectionViewDelegate, DataSource
extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        typeCollectionView.isHidden = true
        viewModel.storeCategory = viewModel.categoryFilters[indexPath.item].tag
        changeButtonTitle(for: rootView.typeButton, newTitle: viewModel.categoryFilters[indexPath.item].name ?? "")
    }
}

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.categoryFilters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TypeCollectionViewCell.className, for: indexPath) as? TypeCollectionViewCell else { return UICollectionViewCell() }
        cell.bindData(model: viewModel.categoryFilters[indexPath.item])
        return cell
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
}

// DropDownViewDelegate
extension HomeViewController: DropDownViewDelegate {
    func dropDownView(_ controller: DropDownView, didSelectItem item: String, buttonType: ButtonType) {
        viewModel.getSortOptionFilterAPI { [self] isSuccess in
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
        
        setupNavigationBar(mainTitle: StringLiterals.Home.allUniversity)
        fetchAllHankkiInfo()
    }
    
    func fetchAllHankkiInfo() {
        viewModel.getHankkiListAPI(storeCategory: "", priceCategory: "", sortOption: "") { _ in }
        viewModel.getHankkiPinAPI(storeCategory: "", priceCategory: "", sortOption: "") { _ in }
    }
}
