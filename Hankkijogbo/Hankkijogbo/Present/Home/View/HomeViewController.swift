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
    
    let viewModel = HomeViewModel()
    var isButtonModified = false
    var isDropDownVisible = false
    var selectedMarkerIndex: Int?
    
    // MARK: - UI Components
    
    private var typeCollectionView = TypeCollectionView()
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
        setupPosition()
        viewModel.getHankkiListAPI(universityid: 1, storeCategory: "", priceCategory: "", sortOption: "", completion: { _ in})
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupNavigationBar()
        requestLocationAuthorization()
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
            guard let self else { return }
            DispatchQueue.main.async {
                self.rootView.bottomSheetView.data = data
                self.rootView.bottomSheetView.totalListCollectionView.reloadData()
            }
        }
    }
}

// MARK: - MapView

extension HomeViewController {
    func setupMap() {
        rootView.mapView.touchDelegate = self
    }
    
    func setupPosition() {
        var markers: [GetHankkiPinData] = viewModel.hankkiPins
        let initialPosition = NMGLatLng(lat: 37.5665, lng: 126.9780)
        
        viewModel.getHankkiPinAPI(universityid: 1, storeCategory: "", priceCategory: "", sortOption: "", completion: { [weak self] pins in
            markers = self?.viewModel.hankkiPins ?? []
            
            self?.rootView.mapView.positionMode = .direction
            self?.rootView.mapView.moveCamera(NMFCameraUpdate(scrollTo: initialPosition))
            
            for (index, location) in markers.enumerated() {
                let marker = NMFMarker()
                marker.position = NMGLatLng(lat: location.latitude, lng: location.longitude)
                marker.mapView = self?.rootView.mapView
                marker.touchHandler = { _ in
                    self?.showMarkerInfoCard(at: index)
//                    print("Marker \(index + 1) clicked")
                    return true
                }
            }
        })
    }
    
//    private func showMarkerInfoCard(at index: Int) {
//          guard selectedMarkerIndex != index else { return }
//          selectedMarkerIndex = index
//          
//          if markerInfoCardView == nil {
//              markerInfoCardView = MarkerInfoCardView()
//              view.addSubview(markerInfoCardView!)
//              markerInfoCardView?.snp.makeConstraints { make in
//                  make.width.equalTo(331)
//                  make.height.equalTo(109)
//                  make.centerX.equalToSuperview()
//                  make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(109)
//              }
//              view.layoutIfNeeded()
//          }
//          
//        markerInfoCardView?.bindData(model: viewModel.hankkiPins[index])
//          
//          UIView.animate(withDuration: 0.3, animations: {
//              self.markerInfoCardView?.snp.updateConstraints { make in
//                  make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
//              }
//              self.view.layoutIfNeeded()
//          })
//      }
    private func showMarkerInfoCard(at index: Int) {
        guard selectedMarkerIndex != index else { return }
        selectedMarkerIndex = index
        
        if markerInfoCardView == nil {
            markerInfoCardView = MarkerInfoCardView()
            view.addSubview(markerInfoCardView!)
            markerInfoCardView?.snp.makeConstraints { make in
                make.width.equalTo(331)
                make.height.equalTo(109)
                make.centerX.equalToSuperview()
                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(109)
            }
            view.layoutIfNeeded()
        }
        
        let pinData = viewModel.hankkiPins[index]

        let category = "Category"
        let lowestPrice = 10000
        let heartCount = 5
        let imageUrl = "http://example.com/image.jpg" /
        
        let thumbnailData = GetHankkiThumbnailData(from: pinData, category: category, lowestPrice: lowestPrice, heartCount: heartCount, imageUrl: imageUrl)
        markerInfoCardView?.bindData(model: thumbnailData)
        
        UIView.animate(withDuration: 0.3, animations: {
            self.markerInfoCardView?.snp.updateConstraints { make in
                make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
            }
            self.view.layoutIfNeeded()
        })
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
        let type: HankkiNavigationType = HankkiNavigationType(hasBackButton: false,
                                                              hasRightButton: false,
                                                              mainTitle: .stringAndImage("한끼대학교", .btnDropdown),
                                                              rightButton: .string(""),
                                                              rightButtonAction: {})
        if let navigationController = navigationController as? HankkiNavigationController {
            navigationController.setupNavigationBar(forType: type)
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
    
    // MARK: - @objc Func
    
    @objc func typeButtonDidTap() {
        //        viewModel.getCategoryFilterAPI(completion: {_ in })
        viewModel.getCategoryFilterAPI { [weak self] success in
            if success {
                DispatchQueue.main.async {
                    self?.typeCollectionView.collectionView.reloadData()
                }
            }
        }
        if isButtonModified {
            revertButton(for: rootView.typeButton, filter: "종류")
        } else {
            typeCollectionView.isHidden = false
            
            view.addSubview(typeCollectionView)
            
            typeCollectionView.snp.makeConstraints {
                $0.top.equalTo(rootView.typeButton.snp.bottom).offset(8)
                $0.leading.equalTo(rootView).inset(8)
                $0.trailing.equalToSuperview()
                $0.centerX.equalToSuperview()
            }
        }
    }
    
    @objc func priceButtonDidTap() {
        toggleDropDown(isPriceModel: true, buttonType: .price)
    }
    
    @objc func sortButtonDidTap() {
        toggleDropDown(isPriceModel: false, buttonType: .sort)
    }
    
}

extension HomeViewController: NMFMapViewCameraDelegate {}

extension HomeViewController: NMFMapViewTouchDelegate {
    func mapView(_ mapView: NMFMapView, didTapMap latlng: NMGLatLng, point: CGPoint) {
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
        switch buttonType {
        case .price:
            if let priceFilter = viewModel.priceFilters.first(where: { $0.tag == item }) {
                viewModel.priceCategory = priceFilter.tag
                changeButtonTitle(for: rootView.priceButton, newTitle: priceFilter.name)
            }
        case .sort:
            if let sortOption = viewModel.sortOptions.first(where: { $0.tag == item }) {
                viewModel.sortOption = sortOption.tag
                changeButtonTitle(for: rootView.sortButton, newTitle: sortOption.name)
            }
        }
        hideDropDown()
    }
}
