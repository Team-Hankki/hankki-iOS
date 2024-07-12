//
//  CoreLocation.swift
//  Hankkijogbo
//
//  Created by Gahyun Kim on 7/12/24.
//

import UIKit
import CoreLocation

/// HomeViewController의 extension을 통해 CoreLocation 관련 기능을 분리
extension HomeViewController: CLLocationManagerDelegate {
    
    // CLLocationManager 인스턴스 생성
    private var locationManager: CLLocationManager {
        get {
            // locationManager 저장
            let manager = objc_getAssociatedObject(self, &HomeViewController.locationManagerKey) as? CLLocationManager
            if let manager = manager {
                return manager
            }
            let newManager = CLLocationManager()
            objc_setAssociatedObject(self, &HomeViewController.locationManagerKey, newManager, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return newManager
        }
        set {
            objc_setAssociatedObject(self, &HomeViewController.locationManagerKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    private static var locationManagerKey: Int = 0
    
    // 위치 서비스 동의 요청
    func requestLocationAuthorization() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest

        // 위치 서비스 사용 가능 여부 확인
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestWhenInUseAuthorization()   // 앱 사용 중 위치 접근 권한 요청
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
        case .authorizedWhenInUse, .authorizedAlways:
            print("Location authorized")
            // 위치 접근 권한이 허용된 경우 위치 업데이트 시작
            locationManager.startUpdatingLocation()
        default:
            break
        }
    }
    
    // 위치 접근 거부 경고 알림 표시
    private func showLocationAccessDeniedAlert() {
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
    
    // 위치 업데이트 성공
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            print("Current location: \(location.coordinate.latitude), \(location.coordinate.longitude)")
        }
    }
    
    // 위치 업데이트 실패
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get location: \(error.localizedDescription)")
    }
    
    // targetButton 클릭 시의 동작 처리
    @objc func targetButtonDidTap() {
        let status = CLLocationManager.authorizationStatus()
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            // 위치 접근 권한이 허용된 경우 현재 위치로 이동
            if let location = locationManager.location {
                print("Moving to current location: \(location.coordinate.latitude), \(location.coordinate.longitude)")
                // TODO: - 현재 위치로 이동하는 코드 추가
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
}
