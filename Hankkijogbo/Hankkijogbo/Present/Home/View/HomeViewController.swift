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
    
    private let viewModel = HomeViewModel()
    var isButtonModified = false
    var isDropDownVisible = false
    
    // MARK: - UI Components
    
    private var typeCollectionView = TypeCollectionView()
    var rootView = HomeView()
    var customDropDown: DropDownView?
    var totalListBottomSheetView = TotalListBottomSheetView()
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMap()
        setupPosition()
        
        setupDelegate()
        setupRegister()
        setupaddTarget()
        bindViewModel()
        
        viewModel.getHankkiListAPI(universityid: 1, storeCategory: "", priceCategory: "", sortOption: "", completion: {_ in})
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
        viewModel.hankkiListsDidChange = { [weak self] _ in
            DispatchQueue.main.async {
                self?.totalListBottomSheetView.totalListCollectionView.reloadData()
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
        var initialPosition = NMGLatLng(lat: 37.5665, lng: 126.9780)
        
        rootView.mapView.positionMode = .direction
        rootView.mapView.moveCamera(NMFCameraUpdate(scrollTo: initialPosition))
        
        let markers = [
            (lat: 37.5766102, lng: 126.9783881),
            (lat: 37.5266102, lng: 126.9785881),
            (lat: 37.5646102, lng: 126.9787881),
            (lat: 37.5766152, lng: 126.9789881)
        ]
        
        for (index, location) in markers.enumerated() {
            let marker = NMFMarker()
            marker.position = NMGLatLng(lat: location.lat, lng: location.lng)
            marker.mapView = rootView.mapView
            marker.touchHandler = { _ in
                print("Marker \(index + 1) clicked")
                return true
            }
        }
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
                                                              hasRightButton: true,
                                                              mainTitle: .stringAndImage(university, .btnDropdown),
                                                              rightButton: .string("편지"),
                                                              rightButtonAction: presentUniversity)
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
    
//    func showDropDown(isPriceModel: Bool, buttonType: ButtonType) {
//        customDropDown = DropDownView(isPriceModel: isPriceModel, buttonType: buttonType, viewModel: viewModel)
//        customDropDown?.delegate = self
//        
//        guard let customDropDown = customDropDown else { return }
//        
//        view.addSubview(customDropDown)
//        
//        customDropDown.snp.makeConstraints {
//            $0.top.equalTo(isPriceModel ? rootView.priceButton.snp.bottom : rootView.sortButton.snp.bottom).offset(10)
//            switch buttonType {
//            case .price:
//                $0.centerX.equalTo(rootView.priceButton)
//            case .sort:
//                $0.centerX.equalTo(rootView.sortButton)
//            }
//            $0.width.height.equalTo(0)
//        }
//        
//        customDropDown.snp.updateConstraints {
//            let height = isPriceModel ? viewModel.priceFilters.count * 44 : viewModel.sortOptions.count * 44
//            $0.width.equalTo(112)
//            $0.height.equalTo(height)
//        }
//        self.view.layoutIfNeeded()
//    }
    
//    func toggleDropDown(isPriceModel: Bool, buttonType: ButtonType) {
//        if isDropDownVisible {
//            hideDropDown()
//        } else {
//            showDropDown(isPriceModel: isPriceModel, buttonType: buttonType)
//        }
//        isDropDownVisible.toggle()
//    }
//    func hideDropDown() {
//        guard let customDropDown = customDropDown else { return }
//        
//        UIView.animate(withDuration: 0.3, animations: {
//            customDropDown.snp.updateConstraints {
//                $0.height.equalTo(0)
//            }
//            self.view.layoutIfNeeded()
//        }) { _ in
//            customDropDown.removeFromSuperview()
//            self.customDropDown = nil
//        }
//    }
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

//extension HomeViewController {
//    func changeButtonTitle(for button: UIButton, newTitle: String) {
//        button.do {
//            $0.setTitle(newTitle, for: .normal)
//            $0.backgroundColor = .hankkiYellowLight
//            $0.layer.borderColor = UIColor.hankkiYellow.cgColor
//            $0.setImage(.icClose, for: .normal)
//            $0.removeTarget(self, action: nil, for: .touchUpInside)
//            $0.addTarget(self, action: #selector(revertButtonAction(_:)), for: .touchUpInside)
//            $0.sizeToFit()
//        }
//        isButtonModified = true
//    }
//    
//    @objc func revertButtonAction(_ sender: UIButton) {
//        let filter: String
//        if sender == rootView.priceButton {
//            filter = "가격대"
//        } else if sender == rootView.sortButton {
//            filter = "정렬"
//        } else {
//            filter = "종류"
//        }
//        revertButton(for: sender, filter: filter)
//    }
//    
//    func revertButton(for button: UIButton, filter: String) {
//        button.do {
//            $0.setTitle(filter, for: .normal)
//            $0.backgroundColor = .white
//            $0.layer.borderColor = UIColor.gray300.cgColor
//            $0.setTitleColor(.gray400, for: .normal)
//            $0.setImage(.icArrowClose, for: .normal)
//            $0.removeTarget(self, action: nil, for: .touchUpInside)
//            $0.sizeToFit()
//        }
//        if button == rootView.priceButton {
//            viewModel.priceCategory = ""
//        } else if button == rootView.sortButton {
//            viewModel.sortOption = ""
//        } else {
//            viewModel.storeCategory = ""
//        }
//        isButtonModified = false
//    }
//}

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
    
    func presentUniversity() {
        let univSelectViewController = UnivSelectViewController()
        navigationController?.pushViewController(univSelectViewController, animated: true)
    }
}
