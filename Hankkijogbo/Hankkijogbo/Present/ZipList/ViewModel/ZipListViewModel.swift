//
//  ZipListViewModel.swift
//  Hankkijogbo
//
//  Created by 심서현 on 7/17/24.
//

import Foundation

final class ZipListViewModel {
    var showAlert: ((String) -> Void)?
    
    var reloadCollectionView: (() -> Void)?
    
    var zipList: [ZipListCollectionViewCell.DataStruct] = [] {
        didSet {
            self.reloadCollectionView?()
        }
    }
}

extension ZipListViewModel {
    func getZipList(completion: @escaping (Bool) -> Void) {
        NetworkService.shared.userService.getMeZipList { result in
            print(result)
            switch result {
            case .success(let response):
                if let responseData = response {
                    self.zipList = responseData.data.favorites.map {
                        return ZipListCollectionViewCell.DataStruct(id: $0.id, title: $0.title, imageUrl: $0.imageType)
                    }
                } else { print("레전드 오류 발생") }
                completion(true)
            case .unAuthorized, .networkFail:
                self.showAlert?("Failed")
                completion(false)
            default:
                return
            }
        }
    }
    
    func postZipBatchDelete(requestBody: PostZipBatchDeleteRequestDTO, completion: @escaping (Bool) -> Void) {
        NetworkService.shared.zipService.postZipBatchDelete(requesBody: requestBody) { result in
            switch result {
            case .unAuthorized, .networkFail:
                self.showAlert?("Failed")
                print("족보 삭제 실패")
                completion(false)
            default:
                self.getZipList(completion: {_ in})
                return
            }
            
        }
    }
}
