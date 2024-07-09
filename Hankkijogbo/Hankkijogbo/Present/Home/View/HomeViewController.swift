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
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupMap()
        setupPosition()
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
    func setupMap() {
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
