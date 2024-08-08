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
            result.handleNetworkResult(result) { response in
                self.zipList = response.data.favorites.map {
                    return ZipListCollectionViewCell.DataStruct(id: $0.id, title: $0.title, imageUrl: $0.imageType)
                }
            }
        }
    }
    
    func postZipBatchDelete(requestBody: PostZipBatchDeleteRequestDTO, completion: @escaping (Bool) -> Void) {
        NetworkService.shared.zipService.postZipBatchDelete(requesBody: requestBody) { result in
            result.handleNetworkResult(result)
        }
    }
}
