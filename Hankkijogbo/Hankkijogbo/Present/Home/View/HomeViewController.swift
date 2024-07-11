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
    
    private var rootView = HomeView()
    
    private var isButtonModified = false
    var customDropDown: DropDownViewController?
    var isDropDownVisible = false
    
    // 임시 dummy data
    let typedata = dummyType
    let pricedata = dummyPrice
    let sortdata = dummySort
    
    // MARK: - UI Components
    
    private var typeCollectionView = TypeCollectionView()
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupMap()
        setupPosition()
        
        setupDelegate()
        setupRegister()
        setupaddTarget()
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
}

// MARK: - MapView

extension HomeViewController {
    private func setupMap() {
        rootView.mapView.touchDelegate = self
    }
    
    func setupPosition() {
        let initialPosition = NMGLatLng(lat: 37.5665, lng: 126.9780)
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
            marker.touchHandler = { (overlay) in
                print("Marker \(index + 1) clicked")
                return true
            }
        }
    }
    
    private func setupaddTarget() {
        rootView.typeButton.addTarget(self, action: #selector(typeButtonDidTap), for: .touchUpInside)
        rootView.priceButton.addTarget(self, action: #selector(priceButtonDidTap), for: .touchUpInside)
        rootView.sortButton.addTarget(self, action: #selector(sortButtonDidTap), for: .touchUpInside)
    }
    
    @objc func typeButtonDidTap() {
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
    
    private func showDropDown(isPriceModel: Bool, buttonType: ButtonType) {
        customDropDown = DropDownViewController(isPriceModel: isPriceModel, buttonType: buttonType)
        customDropDown?.delegate = self
        
        guard let customDropDown = customDropDown else { return }
        
        view.addSubview(customDropDown)
        customDropDown.snp.makeConstraints {
            $0.top.equalTo(isPriceModel ? rootView.priceButton.snp.bottom : rootView.sortButton.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(0) // 초기 높이 0으로 설정
        }
        
        UIView.animate(withDuration: 0.3) {
            customDropDown.snp.updateConstraints {
                let height = isPriceModel ? self.pricedata.count * 44 : self.sortdata.count * 44
                $0.width.equalTo(112)
                $0.height.equalTo(height)
            }
            self.view.layoutIfNeeded()
        }
    }
    
    private func toggleDropDown(isPriceModel: Bool, buttonType: ButtonType) {
        if isDropDownVisible {
            hideDropDown()
        } else {
            showDropDown(isPriceModel: isPriceModel, buttonType: buttonType)
        }
        isDropDownVisible.toggle()
    }
    
    private func hideDropDown() {
        guard let customDropDown = customDropDown else { return }
        
        UIView.animate(withDuration: 0.3, animations: {
            customDropDown.snp.updateConstraints {
                $0.height.equalTo(0)
            }
            self.view.layoutIfNeeded()
        }) { _ in
            customDropDown.removeFromSuperview()
            self.customDropDown = nil
        }
    }
}

extension HomeViewController {
    func setupNavigationBar() {
        let type: HankkiNavigationType = HankkiNavigationType(hasBackButton: false,
                                                              hasRightButton: false,
                                                              mainTitle: .stringAndImage("한끼대학교", .icArrow),
                                                              rightButton: .string(""),
                                                              rightButtonAction: {})
        if let navigationController = navigationController as? HankkiNavigationController {
            navigationController.setupNavigationBar(forType: type)
        }
    }
}

extension HomeViewController: NMFMapViewCameraDelegate {}

extension HomeViewController: NMFMapViewTouchDelegate {
    func mapView(_ mapView: NMFMapView, didTapMap latlng: NMGLatLng, point: CGPoint) {
        print("Map clicked")
    }
}

extension HomeViewController {
    func setupDelegate() {
        typeCollectionView.collectionView.delegate = self
        typeCollectionView.collectionView.dataSource = self
    }
    
    func setupRegister() {
        typeCollectionView.collectionView.register(TypeCollectionViewCell.self,
                                                   forCellWithReuseIdentifier: TypeCollectionViewCell.className)
    }
}

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        typeCollectionView.isHidden = true
        changeButtonTitle(for: rootView.typeButton, newTitle: typedata[indexPath.item].menutype)
        print( typedata[indexPath.item].menutype, "이 클릭되었습니다. ")
    }
}

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 9
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TypeCollectionViewCell.className, for: indexPath) as? TypeCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.bindData(model: typedata[indexPath.item])
        return cell
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
}

extension HomeViewController {
    func changeButtonTitle(for button: UIButton, newTitle: String) {
        button.setTitle(newTitle, for: .normal)
        button.backgroundColor = .hankkiYellowLight
        button.layer.borderColor = UIColor.hankkiYellow.cgColor
        button.setImage(.icClose, for: .normal)
        button.removeTarget(self, action: nil, for: .touchUpInside)
        button.addTarget(self, action: #selector(revertButtonAction(_:)), for: .touchUpInside)
        button.sizeToFit()
        isButtonModified = true
    }
    
    @objc func revertButtonAction(_ sender: UIButton) {
        let filter: String
        if sender == rootView.priceButton {
            filter = "가격대"
        } else if sender == rootView.sortButton {
            filter = "정렬"
        } else {
            filter = "종류"
        }
        revertButton(for: sender, filter: filter)
    }
    
    func revertButton(for button: UIButton, filter: String) {
        button.setTitle(filter, for: .normal)
        button.backgroundColor = .white
        button.layer.borderColor = UIColor.gray300.cgColor
        button.setTitleColor(.gray400, for: .normal)
        button.setImage(.icArrow, for: .normal)
        button.removeTarget(self, action: nil, for: .touchUpInside)
        button.sizeToFit()
        isButtonModified = false
    }
}

extension HomeViewController: DropDownViewControllerDelegate {
    
    func dropDownViewController(_ controller: DropDownViewController, didSelectItem item: String, buttonType: ButtonType) {
        switch buttonType {
        case .price:
            changeButtonTitle(for: rootView.priceButton, newTitle: item)
        case .sort:
            changeButtonTitle(for: rootView.sortButton, newTitle: item)
        }
        hideDropDown()
    }
}
