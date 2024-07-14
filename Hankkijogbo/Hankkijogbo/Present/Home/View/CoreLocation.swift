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
    private var locationManager: CLLocationManager? {
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
        }
        
        // 위치 서비스 사용 가능 여부 확인
        if CLLocationManager.locationServicesEnabled() {
            locationManager?.requestWhenInUseAuthorization()   // 앱 사용 중 위치 접근 권한 요청
        } else {
            print("Location Services Disabled.")
        }
    }
    
    // CLLocationManagerDelegate 메소드
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            print("Location authorization not determined")
        case .restricted, .denied:
            print("Location authorization restricted or denied")
            // 위치 접근 권한이 거부된 경우 알림 표시 등 처리
            showLocationAccessDeniedAlert()
        case .authorizedWhenInUse, .authorizedAlways:
            print("Location authorized")
            // 위치 접근 권한이 허용된 경우 위치 업데이트 시작
            locationManager?.startUpdatingLocation()
        @unknown default:
            break
        }
    }
    
    // 위치 업데이트 성공
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            moveCameraToLocation(location: location)
        }
    }
    
    // 위치 업데이트 실패
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get location: \(error.localizedDescription)")
    }
    
    // 위치 접근 거부 경고 알림 표시
    func showLocationAccessDeniedAlert() {
        let alert = UIAlertController(title: "위치 접근 거부", message: "설정에서 위치 접근을 허용해 주세요.", preferredStyle: .alert)
        let settingsAction = UIAlertAction(title: "설정", style: .default) { _ in
            if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(appSettings, options: [:], completionHandler: nil)
            }
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alert.addAction(settingsAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    // targetButton 클릭 시의 동작 처리
    @objc func targetButtonDidTap() {
        let status = CLLocationManager.authorizationStatus()
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            // 위치 접근 권한이 허용된 경우 현재 위치로 이동
            if let manager = locationManager, let location = manager.location {
                print("Moving to current location: \(location.coordinate.latitude), \(location.coordinate.longitude)")
                moveCameraToLocation(location: location)
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
    
    // 카메라를 현재 위치로 이동
    func moveCameraToLocation(location: CLLocation) {
        let position = NMGLatLng(lat: location.coordinate.latitude, lng: location.coordinate.longitude)
        let cameraUpdate = NMFCameraUpdate(scrollTo: position)
        rootView.mapView.moveCamera(cameraUpdate)
    }
}
