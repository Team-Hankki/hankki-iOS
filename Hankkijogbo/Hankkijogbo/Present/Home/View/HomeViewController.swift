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
    var isButtonModified = false
    var isDropDownVisible = false
    var selectedMarkerIndex: Int?
    var markers: [NMFMarker] = []
    var presentMyZipBottomSheetNotificationName: String = "presentMyZipBottomSheetNotificationName"
    
    private let universityId = UserDefaults.standard.getUniversity()?.id ?? 0
    
    // MARK: - UI Components
    
    var typeCollectionView = TypeCollectionView()
    var rootView = HomeView()
    var customDropDown: DropDownView?
    var markerInfoCardView: MarkerInfoCardView?
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMap()
        
        setupDelegate()
        setupRegister()
        setupaddTarget()
        bindViewModel()
        
        loadInitialData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupPosition()
        setupNavigationBar()
        requestLocationAuthorization()
        NotificationCenter.default.addObserver(self, selector: #selector(getNotificationForMyZipList), name: NSNotification.Name(presentMyZipBottomSheetNotificationName), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(setupBlackToast), name: NSNotification.Name(StringLiterals.NotificationName.setupToast), object: nil)
        updateUniversityData(universityId: universityId)
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
            }
        }
        
        viewModel.hankkiPinsDidChange = { [weak self] pins in
            self?.setupPosition(with: pins)
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
    
    private func setupNavigationBar() {
        // Univ StringLiterals 추가 이후에 반영 예정
        let university = UserDefaults.standard.getUniversity()?.name ?? "한끼대학교"
        let type: HankkiNavigationType = HankkiNavigationType(hasBackButton: false,
                                                              hasRightButton: false,
                                                              mainTitle: .stringAndImage(university, .btnDropdown),
                                                              rightButton: .string(""),
                                                              rightButtonAction: {},
                                                              titleButtonAction: presentUniversity)
        if let navigationController = navigationController as? HankkiNavigationController {
            navigationController.setupNavigationBar(forType: type)
            navigationController.mainTitleLabel.font = .setupSuiteStyle(of: .subtitle)
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
        navigationController?.pushViewController(univSelectViewController, animated: true)
    }
    
    @objc func getNotificationForMyZipList(_ notification: Notification) {
        if let indexPath = notification.userInfo?["itemIndexPath"] as? IndexPath {
            self.presentMyZipListBottomSheet(id: viewModel.hankkiLists[indexPath.item].id)
        }
    }
    
    @objc func presentMyZipBottomSheet() {
        guard let thumbnailData = viewModel.hankkiThumbnail else { return }
        self.presentMyZipListBottomSheet(id: thumbnailData.id)
    }
    
    @objc func setupBlackToast(_ notification: Notification) {
        if let zipId = notification.userInfo?["zipId"] as? Int {
            
            self.showBlackToast(message: StringLiterals.Toast.addToMyZipBlack) { [self] in
                let hankkiListViewController = HankkiListViewController(.myZip, zipId: zipId)
                navigationController?.pushViewController(hankkiListViewController, animated: true)
            }
        }
    }
}

private extension HomeViewController {
    func loadInitialData() {
        guard let universityId = UserDefaults.standard.getUniversity()?.id else { return }
        viewModel.getHankkiListAPI(universityId: universityId, storeCategory: "", priceCategory: "", sortOption: "") { [weak self] success in
            self?.handleHankkiListResult(success: success)
        }
        viewModel.getHankkiPinAPI(universityId: universityId, storeCategory: "", priceCategory: "", sortOption: "", completion: { _ in })
    }
    
    func updateUniversityData(universityId: Int) {
        guard let universityId = UserDefaults.standard.getUniversity()?.id else { return }
        viewModel.getHankkiListAPI(universityId: universityId, storeCategory: "", priceCategory: "", sortOption: "") { [weak self] success in
            self?.handleHankkiListResult(success: success)
        }
        viewModel.getHankkiPinAPI(universityId: universityId, storeCategory: "", priceCategory: "", sortOption: "", completion: { _ in })
        rootView.bottomSheetView.totalListCollectionView.reloadData()
        
        // 대학 선택 후 홈화면 재진입 시 해당 대학교에 맞게 reset
        hideMarkerInfoCard()
        rootView.bottomSheetView.viewLayoutIfNeededWithDownAnimation()
    }
    
    func handleHankkiListResult(success: Bool) {
        if success {
            if viewModel.hankkiLists.isEmpty {
                rootView.bottomSheetView.showEmptyLabel(true)
            } else {
                rootView.bottomSheetView.showEmptyLabel(false)
            }
        }
    }
}

extension HomeViewController: NMFMapViewCameraDelegate {}

extension HomeViewController: NMFMapViewTouchDelegate {
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
                viewModel.priceCategory = item // 필터링 값 업데이트
            case .sort:
                if let sortOption = viewModel.sortOptions.first(where: { $0.tag == item }) {
                    changeButtonTitle(for: rootView.sortButton, newTitle: sortOption.name)
                    viewModel.sortOption = item // 필터링 값 업데이트
                }
            }
            hideDropDown()
        }
    }
}
