//
//  HomeViewController.swift
//  Hankkijogbo
//
//  Created by Gahyun Kim on 2024/06/21.
//

import UIKit

import NMapsMap

final class HomeViewController: BaseViewController {
    
    private var rootView = HomeView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupMap()
        setupPosition()
    }
    
    override func setupHierarchy() {
        view.addSubview(rootView)
    }
    
    override func setupLayout() {
        rootView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(50)
            $0.horizontalEdges.bottom.equalToSuperview()
        }
    }
}

// MARK: - MapView Setting
extension HomeViewController {
    func setupMap() {
        rootView.mapView.touchDelegate = self
    }
    
    func setupPosition() {
        let initialPosition = NMGLatLng(lat: 37.5665, lng: 126.9780)
        rootView.mapView.positionMode = .direction
        rootView.mapView.moveCamera(NMFCameraUpdate(scrollTo: initialPosition))
        
        // 마커 추가
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

extension HomeViewController: NMFMapViewCameraDelegate {}

extension HomeViewController: NMFMapViewTouchDelegate {
    func mapView(_ mapView: NMFMapView, didTapMap latlng: NMGLatLng, point: CGPoint) {
        print("Map clicked at lat: \(latlng.lat), lng: \(latlng.lng)")
    }
}



//final class HomeViewController: UIViewController, NMFMapViewTouchDelegate, NMFMapViewCameraDelegate {
//
//    private var mymapView = NMFMapView()
//    
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        setupMap()
//        setupPosition()
//        
//    }
//    
//    
//    func setupMap() {
//        mymapView =  NMFMapView(frame: view.frame)
//        mymapView.touchDelegate = self
//        
//        view.addSubview(mymapView)
//        mymapView.snp.makeConstraints {
//            $0.edges.equalToSuperview().inset(20)
//        }
//    }
//    
//    func setupPosition() {
//        let initialPosition = NMGLatLng(lat: 37.5665, lng: 126.9780)
//        mymapView.positionMode = .direction
//        mymapView.moveCamera(NMFCameraUpdate(scrollTo: initialPosition))
//        
//        // 마커 추가
//        let markers = [
//            (lat: 37.5766102, lng: 126.9783881),
//            (lat: 37.5266102, lng: 126.9785881),
//            (lat: 37.5646102, lng: 126.9787881),
//            (lat: 37.5766152, lng: 126.9789881)
//        ]
//        
//        for (index, location) in markers.enumerated() {
//            let marker = NMFMarker()
//            marker.position = NMGLatLng(lat: location.lat, lng: location.lng)
//            marker.mapView = mymapView
//            marker.touchHandler = { (overlay) in
//                print("Marker \(index + 1) clicked")
//                return true
//            }
//        }
//    }
//    
//    // NMFMapViewTouchDelegate 메서드
//    func mapView(_ mapView: NMFMapView, didTapMap latlng: NMGLatLng, point: CGPoint) {
//        print("Map clicked at lat: \(latlng.lat), lng: \(latlng.lng)")
//    }
//}
//
