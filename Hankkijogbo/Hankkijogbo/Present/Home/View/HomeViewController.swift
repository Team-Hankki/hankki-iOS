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
    private var markers: [NMFMarker] = []
    var presentMyZipBottomSheetNotificationName: String = "presentMyZipBottomSheetNotificationName"
    
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
        viewModel.getHankkiListAPI(universityid: UserDefaults.standard.getUniversity()?.id ?? 0, storeCategory: "", priceCategory: "", sortOption: "", completion: { _ in})
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupPosition()
        setupNavigationBar()
        requestLocationAuthorization()
        NotificationCenter.default.addObserver(self, selector: #selector(getNotificationForMyZipList), name: NSNotification.Name(presentMyZipBottomSheetNotificationName), object: nil)
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
            self?.showAlert(titleText: "알 수 없는 오류가 발생했어요",
                            subText: "네트워크 연결 상태를 확인하고\n다시 시도해주세요",
                            primaryButtonText: "확인")
        }
    }
    
    private func loadInitialData() {
        let universityId = UserDefaults.standard.getUniversity()?.id ?? 0
        viewModel.getHankkiListAPI(universityid: universityId, storeCategory: "", priceCategory: "", sortOption: "", completion: { _ in })
        viewModel.getHankkiPinAPI(universityid: universityId, storeCategory: "", priceCategory: "", sortOption: "", completion: { _ in })
    }
    
    func updateUniversityData(universityId: Int) {
        viewModel.getHankkiListAPI(universityid: universityId, storeCategory: "", priceCategory: "", sortOption: "", completion: { _ in })
        viewModel.getHankkiPinAPI(universityid: universityId, storeCategory: "", priceCategory: "", sortOption: "", completion: { _ in })
    }
}

// MARK: - MapView

extension HomeViewController {
    func setupMap() {
        rootView.mapView.touchDelegate = self
    }
    
    func setupPosition() {
        var markers: [GetHankkiPinData] = viewModel.hankkiPins
        guard let university = UserDefaults.standard.getUniversity() else { return }
        
        let initialPosition = NMGLatLng(lat: university.latitude, lng: university.longitude)
        viewModel.getHankkiPinAPI(universityid: university.id, storeCategory: "", priceCategory: "", sortOption: "", completion: { [weak self] pins in
            
            markers = self?.viewModel.hankkiPins ?? []
            self?.rootView.mapView.positionMode = .direction
            self?.rootView.mapView.moveCamera(NMFCameraUpdate(scrollTo: initialPosition))
            
            self?.clearMarkers()
            
            for (index, location) in markers.enumerated() {
                let marker = NMFMarker()
                marker.iconImage = NMFOverlayImage(image: .icPin)
                marker.position = NMGLatLng(lat: location.latitude, lng: location.longitude)
                marker.mapView = self?.rootView.mapView
                marker.touchHandler = { [weak self] _ in
                    self?.rootView.bottomSheetView.viewLayoutIfNeededWithHiddenAnimation()
                    self?.showMarkerInfoCard(at: index, pinId: location.id)
                    return true
                }
                self?.markers.append(marker)
            }
        })
    }
    
    private func setupPosition(with pins: [GetHankkiPinData]) {
        clearMarkers()
        
        for (index, location) in pins.enumerated() {
            let marker = NMFMarker()
            marker.iconImage = NMFOverlayImage(image: .icPin)
            marker.position = NMGLatLng(lat: location.latitude, lng: location.longitude)
            marker.mapView = rootView.mapView
            marker.touchHandler = { [weak self] _ in
                self?.rootView.bottomSheetView.viewLayoutIfNeededWithHiddenAnimation()
                self?.showMarkerInfoCard(at: index, pinId: location.id)
                return true
            }
            markers.append(marker)
        }
    }
    
    private func clearMarkers() {
        markers.forEach { $0.mapView = nil }
        markers.removeAll()
    }
    
    private func showMarkerInfoCard(at index: Int, pinId: Int64) {
        guard selectedMarkerIndex != index else { return }
        selectedMarkerIndex = index
        
        if markerInfoCardView == nil {
            markerInfoCardView = MarkerInfoCardView()
            view.addSubview(markerInfoCardView!)
            markerInfoCardView?.snp.makeConstraints { make in
                make.width.equalTo(331)
                make.height.equalTo(109)
                make.centerX.equalToSuperview()
                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(22)
            }
            view.layoutIfNeeded()
        }
        
        viewModel.getThumbnailAPI(id: pinId) { [weak self] success in
            guard let self = self, success, let thumbnailData = self.viewModel.hankkiThumbnail else { return }
            DispatchQueue.main.async {
                self.markerInfoCardView?.bindData(model: thumbnailData)
                
                UIView.animate(withDuration: 0.3, animations: {
                    self.markerInfoCardView?.snp.updateConstraints {
                        $0.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).inset(22)
                    }
                    self.view.layoutIfNeeded()
                })
                self.showTargetButtonAtCardView()
            }
        }
    }
    
    private func hideMarkerInfoCard() {
        guard markerInfoCardView != nil else { return }
        
        UIView.animate(withDuration: 0.3, animations: {
            self.markerInfoCardView?.snp.updateConstraints {
                $0.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(109)
            }
            self.view.layoutIfNeeded()
        }, completion: { _ in
            self.markerInfoCardView?.removeFromSuperview()
            self.markerInfoCardView = nil
            self.selectedMarkerIndex = nil
        })
        self.showTargetButtonAtBottomSheet()
    }
}

private extension HomeViewController {
    func setupDelegate() {
        typeCollectionView.collectionView.delegate = self
        typeCollectionView.collectionView.dataSource = self
    }
    
    func setupRegister() {
        typeCollectionView.collectionView.register(TypeCollectionViewCell.self,
                                                   forCellWithReuseIdentifier: TypeCollectionViewCell.className)
    }
    
    func setupNavigationBar() {
        let university = UserDefaults.standard.getUniversity()?.name ?? "한끼대학교"
        let type: HankkiNavigationType = HankkiNavigationType(hasBackButton: false,
                                                              hasRightButton: false,
                                                              mainTitle: .stringAndImage(university, .btnDropdown),
                                                              rightButton: .string(""),
                                                              rightButtonAction: {},
                                                              titleButtonAction: presentUniversity)
        if let navigationController = navigationController as? HankkiNavigationController {
            navigationController.setupNavigationBar(forType: type)
            navigationController.isNavigationBarHidden = false
        }
    }
    
    @objc func getNotificationForMyZipList(_ notification: Notification) {
        if let indexPath = notification.userInfo?["itemIndexPath"] as? IndexPath {
            print("클릭된 셀의 indexPath \(indexPath)")
            print(viewModel.hankkiLists[indexPath.item])
            self.presentMyZipListBottomSheet(id: viewModel.hankkiLists[indexPath.item].id)
        }
    }
}

// MARK: - Filtering 관련 Extension

private extension HomeViewController {
    func setupaddTarget() {
        rootView.typeButton.addTarget(self, action: #selector(typeButtonDidTap), for: .touchUpInside)
        rootView.priceButton.addTarget(self, action: #selector(priceButtonDidTap), for: .touchUpInside)
        rootView.sortButton.addTarget(self, action: #selector(sortButtonDidTap), for: .touchUpInside)
        rootView.targetButton.addTarget(self, action: #selector(targetButtonDidTap), for: .touchUpInside)
    }
}

extension HomeViewController: NMFMapViewCameraDelegate {}

extension HomeViewController: NMFMapViewTouchDelegate {
    func mapView(_ mapView: NMFMapView, didTapMap latlng: NMGLatLng, point: CGPoint) {
        self.rootView.bottomSheetView.viewLayoutIfNeededWithDownAnimation()
        self.hideMarkerInfoCard()
        
        print("Map clicked")
    }
}

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        typeCollectionView.isHidden = true
        viewModel.storeCategory = viewModel.categoryFilters[indexPath.item].tag
        changeButtonTitle(for: rootView.typeButton, newTitle: viewModel.categoryFilters[indexPath.item].name ?? "")
        print("\(String(describing: viewModel.storeCategory)) 이 클릭되었습니다.")
    }
}

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.categoryFilters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TypeCollectionViewCell.className, for: indexPath) as? TypeCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.bindData(model: viewModel.categoryFilters[indexPath.item])
        return cell
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
}

extension HomeViewController: DropDownViewDelegate {
    func dropDownView(_ controller: DropDownView, didSelectItem item: String, buttonType: ButtonType) {
        viewModel.getSortOptionFilterAPI { [self] isSuccess in
            switch buttonType {
            case .price:
                if item == "K6" {
                    changeButtonTitle(for: rootView.priceButton, newTitle: "6000원 이하")
                } else {
                    changeButtonTitle(for: rootView.priceButton, newTitle: "6000~8000원")
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
    
    func presentUniversity() {
        let univSelectViewController = UnivSelectViewController()
        navigationController?.pushViewController(univSelectViewController, animated: true)
    }
}
