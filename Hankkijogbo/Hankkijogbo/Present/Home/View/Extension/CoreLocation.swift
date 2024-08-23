//
//  CoreLocation.swift
//  Hankkijogbo
//
//  Created by Gahyun Kim on 7/12/24.
//

import UIKit
import CoreLocation

import NMapsMap

/// HomeViewController의 extension을 통해 CoreLocation 관련 기능을 분리
extension HomeViewController: CLLocationManagerDelegate {
    
    // CLLocationManager 인스턴스
    var locationManager: CLLocationManager? {
        get {
            return objc_getAssociatedObject(self, &HomeViewController.locationManagerKey) as? CLLocationManager
        }
        set {
            objc_setAssociatedObject(self, &HomeViewController.locationManagerKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    private static var locationManagerKey: Int = 0
    
    // 위치 서비스 동의 요청
    func requestLocationAuthorization() {
        if locationManager == nil {
            locationManager = CLLocationManager()
            locationManager?.delegate = self
            locationManager?.desiredAccuracy = kCLLocationAccuracyBest
            locationManager?.distanceFilter = kCLDistanceFilterNone
        }
        
        // 위치 서비스 사용 가능 여부 확인
        if CLLocationManager.locationServicesEnabled() {
            locationManager?.requestWhenInUseAuthorization()
        } else {
            print("❌🌍❌ 위치 서비스가 비활성화 되었습니다. ❌🌍❌")
        }
    }
    
    // CLLocationManagerDelegate 메소드
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            print("❌🌍❌ 위치 접근 권한이 허용 되지 않았습니다. ❌🌍❌")
        case .restricted, .denied:
            print("❌🌍❌ 위치 접근 권한이 제한되거나 거부되었습니다. ❌🌍❌")
            showLocationAccessDeniedAlert()
        case .authorizedWhenInUse, .authorizedAlways:
            print("⭕️🌍⭕️ 위치 접근 권한이 허용되었습니다. ⭕️🌍⭕️")
            locationManager?.startUpdatingLocation()
        @unknown default:
            break
        }
    }
    
    // 위치 업데이트 성공
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("🌍 위치가 업데이트되었습니다. 🌍")
        if let location = locations.last {
            print("🌍 현재 위치: 위도 \(location.coordinate.latitude), 경도 \(location.coordinate.longitude) 🌍")
            moveCameraToCurrentLocation(location: location)
            manager.stopUpdatingLocation()
        } else {
            print("🌍 유효한 위치를 찾을 수 없습니다.🌍")
        }
    }
    
    // 위치 업데이트 실패
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("🌍 위치 업데이트 실패: \(error.localizedDescription) 🌍")
    }
    
    // 위치 접근 거부 경고 알림 표시
    func showLocationAccessDeniedAlert() {
        showAlert(titleText: "설정 > 개인정보보호 >\n위치서비스와 설정 > 한끼족보에서\n위치 정보 접근을 모두 허용해 주세요. ",
                  secondaryButtonText: "닫기",
                  primaryButtonText: "설정하기",
                  primaryButtonHandler: moveToSetting)
    }
    
    func moveToSetting() {
        if let appSettings = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(appSettings, options: [:], completionHandler: nil)
        }
    }
    
    @objc func targetButtonDidTap() {
        let status = CLLocationManager.authorizationStatus()
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            // 위치 접근 권한이 허용된 경우 현재 위치로 이동
            if let manager = locationManager {
                print("0824 현재 위치 \(locationManager)")
                manager.startUpdatingLocation()
            }
        case .restricted, .denied:
            // 위치 접근 권한이 거부된 경우 알림 표시
            showLocationAccessDeniedAlert()
        case .notDetermined:
            // 위치 접근 권한이 아직 결정되지 않은 경우 동의 요청
            requestLocationAuthorization()
        @unknown default:
            break
        }
    }
    
    func moveCameraToCurrentLocation(location: CLLocation) {
        guard isViewLoaded else { return }
        let position = NMGLatLng(lat: location.coordinate.latitude, lng: location.coordinate.longitude)
        let cameraUpdate = NMFCameraUpdate(scrollTo: position)

        DispatchQueue.main.async {
            self.rootView.mapView.moveCamera(cameraUpdate)
            print("🌍 현재 위치로 카메라가 이동 : \(position.lat), \(position.lng) 🌍")
        }
    }
    
    // 카메라를 선택한 대학교 위치로 이동
    func moveCameraToUniversityLocation() {
        guard let university = UserDefaults.standard.getUniversity() else { return }
        let position = NMGLatLng(lat: university.latitude, lng: university.longitude)
        let cameraUpdate = NMFCameraUpdate(scrollTo: position)
        rootView.mapView.moveCamera(cameraUpdate)
    }
    
    /// TargetButton Layout
    // MarkerCardInfoView가 노출될 때의 TargetButton Layout
    func showTargetButtonAtCardView() {
        self.rootView.targetButton.isHidden = false
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveLinear, animations: {
            self.rootView.targetButton.snp.remakeConstraints {
                $0.bottom.equalTo(self.markerInfoCardView!.snp.top).offset(-12)
                $0.trailing.equalToSuperview().inset(22)
            }
            self.view.layoutIfNeeded()
        })
    }
    
    // BottomSheet가 노출될 때의 TargetButton Layout
    func showTargetButtonAtBottomSheet() {
        self.rootView.targetButton.isHidden = false
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveLinear, animations: {
            if self.rootView.bottomSheetView.isExpanded {
                self.rootView.targetButton.isHidden = true
            } else {
                self.rootView.targetButton.snp.remakeConstraints {
                    $0.bottom.equalTo(self.rootView.bottomSheetView.snp.top).offset(-12)
                    $0.trailing.equalToSuperview().inset(22)
                }
            }
            self.view.layoutIfNeeded()
        })
    }
}

extension HomeViewController {
    func setupMap() {
        rootView.mapView.touchDelegate = self
    }
    
    func setupPosition() {
        var markers: [GetHankkiPinData] = viewModel.hankkiPins
        guard let university = UserDefaults.standard.getUniversity() else { return }
        var initialPosition: NMGLatLng?
        
        if university.latitude == 0.0 &&  university.longitude == 0.0 {
            startLocationUpdates()
        } else {
            initialPosition = NMGLatLng(lat: university.latitude, lng: university.longitude)
        }
        
        viewModel.getHankkiPinAPI(universityId: university.id, storeCategory: "", priceCategory: "", sortOption: "", completion: { [weak self] pins in
            
            markers = self?.viewModel.hankkiPins ?? []
            self?.rootView.mapView.positionMode = .direction
            if let initialPosition = initialPosition {
                self?.rootView.mapView.moveCamera(NMFCameraUpdate(scrollTo: initialPosition))
            }
            
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
    
    func setupPosition(with pins: [GetHankkiPinData]) {
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
    
    private func showMarkerInfoCard(at index: Int, pinId: Int) {
        guard selectedMarkerIndex != index else { return }
        selectedMarkerIndex = index
        
        if markerInfoCardView == nil {
            markerInfoCardView = MarkerInfoCardView()
            view.addSubview(markerInfoCardView!)
            markerInfoCardView?.snp.makeConstraints {
                $0.height.equalTo(109)
                $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(12)
                $0.horizontalEdges.equalToSuperview().inset(22)
            }
            markerInfoCardView?.makeRoundBorder(cornerRadius: 10, borderWidth: 0, borderColor: .clear)
            view.layoutIfNeeded()
        }
        
        viewModel.getThumbnailAPI(id: pinId) { [weak self] success in
            guard let self = self, success, let thumbnailData = self.viewModel.hankkiThumbnail else { return }
            DispatchQueue.main.async {
                self.markerInfoCardView?.bindData(model: thumbnailData)
                
                UIView.animate(withDuration: 0.3, animations: {
                    self.markerInfoCardView?.snp.updateConstraints {
                        $0.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).inset(12)
                    }
                    self.view.layoutIfNeeded()
                    self.markerInfoCardView!.addButton.addTarget(self, action: #selector(self.presentMyZipBottomSheet), for: .touchUpInside)
                })
                self.showTargetButtonAtCardView()
            }
        }
    }
    
    func hideMarkerInfoCard() {
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
