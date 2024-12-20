//
//  UnivSelectViewModel.swift
//  Hankkijogbo
//
//  Created by 심서현 on 7/8/24.
//

import Foundation
import UIKit

class UnivSelectViewModel {
    
    weak var delegate: NetworkResultDelegate?
    
    var currentUnivIndex: Int = -1
    
    var universityList: [UniversityModel] = [] {
        didSet {
            self.reloadCollectionView?()
        }
    }
    
    var reloadCollectionView: (() -> Void)?
    var currentSelectedUniversity: String = ""
}

extension UnivSelectViewModel {
    func getUniversityList() {
        NetworkService.shared.universityService.getUniversityList { [weak self] result in
            result.handleNetworkResult(delegate: self?.delegate) { response in
                self?.universityList = response.data.universities.map {
                    UniversityModel(id: $0.id,
                                    name: $0.name,
                                    longitude: $0.longitude,
                                    latitude: $0.latitude)
                }
            }
        }
    }

    func postMeUniversity(isNull: Bool = false) {
        var currentUniversity: UniversityModel
        if isNull {
            currentUniversity = UniversityModel(id: nil, name: StringLiterals.Home.entire, longitude: 0.0, latitude: 0.0)
        } else {
            currentUniversity = universityList[currentUnivIndex]
        }
        let request: PostMeUniversityRequestDTO = PostMeUniversityRequestDTO(universityId: currentUniversity.id,
                                                                             name: currentUniversity.name,
                                                                             longitude: currentUniversity.longitude,
                                                                             latitude: currentUniversity.latitude)
        
        NetworkService.shared.userService.postMeUniversity(requestBody: request) { result in
            result.handleNetworkResult(delegate: self.delegate) { _ in
                SetupAmplitude.shared.logEvent(AmplitudeLiterals.UnivSelect.tabSubmit,
                                               eventProperties: ["university_name": currentUniversity.name])
                // local에 대학 정보 저장
                UserDefaults.standard.saveUniversity(currentUniversity)
                NotificationCenter.default.post(name: NSNotification.Name(StringLiterals.NotificationName.locationDidUpdate), object: nil, userInfo: ["university": currentUniversity])
                
                // 홈 뷰로 돌아가기
                DispatchQueue.main.async {
                    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                       let rootViewController = windowScene.windows.first?.rootViewController as? UINavigationController { rootViewController.popToRootViewController(animated: true) }
                }
            }
        }
    }
}
