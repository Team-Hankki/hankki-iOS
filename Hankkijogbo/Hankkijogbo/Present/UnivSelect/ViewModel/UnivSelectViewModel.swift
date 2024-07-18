//
//  UnivSelectViewModel.swift
//  Hankkijogbo
//
//  Created by 심서현 on 7/8/24.
//

import Foundation
import UIKit

class UnivSelectViewModel {
    
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
            switch result {
            case .success(let response):
                if let responseData = response {
                    self?.universityList = responseData.data.universities.map {
                        UniversityModel(id:$0.id,
                                        name: $0.name,
                                        longitude: $0.longitude,
                                        latitude: $0.latitude)
                    }
                }

//                completion(true)
            case .unAuthorized, .networkFail:
                print("Failed to fetch university list.")
//                completion(false)
            default:
                return
//                completion(false)
            }
        }
    }
    
    func postMeUniversity() {
        let currentUniversity: UniversityModel = universityList[currentUnivIndex]
        UserDefaults.standard.saveUniversity(currentUniversity)
        let request: PostMeUniversityRequestDTO = PostMeUniversityRequestDTO(universityId: currentUniversity.id,
                                                                             name: currentUniversity.name,
                                                                             longitude: currentUniversity.longitude,
                                                                             latitude: currentUniversity.latitude)
        
        NetworkService.shared.userService.postMeUniversity(requestBody: request) { result in
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    // 홈 뷰로 돌아간다~
                    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                        let rootViewController = windowScene.windows.first?.rootViewController as? UINavigationController { rootViewController.popToRootViewController(animated: true) }
                  }
            case .unAuthorized, .networkFail:
                print("Failed to fetch university list.")
            default:
                return
            }
        }
    }
}
