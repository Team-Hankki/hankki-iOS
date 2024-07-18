//
//  ZipListViewModel.swift
//  Hankkijogbo
//
//  Created by 심서현 on 7/17/24.
//

import Foundation

final class ZipListViewModel {
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
                print("Failed to fetch university list.")
                completion(false)
            default:
                return
            }
        }
    }
    
    func postZip
}
