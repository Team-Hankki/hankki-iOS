//
//  AddNewMenuViewModel.swift
//  Hankkijogbo
//
//  Created by 서은수 on 10/8/24.
//

import Moya

final class AddNewMenuViewModel {
    var updateButton: ((Bool) -> Void)?
    
    var menus: [MenuData] = [MenuData()] {
        didSet {
            checkStatus()
        }
    }
    var validMenus: [MenuData] = []
    var isValid: Bool? {
        didSet {
            updateButton?(isValid ?? false)
        }
    }
}

private extension AddNewMenuViewModel {
    
    func checkStatus() {
        if !menus.isEmpty {
            isValid = menus.allSatisfy { menu in
                !menu.name.isEmpty && menu.price > 0 && menu.price <= 8000
            }
        } else {
            isValid = false
        }
    }
}

extension AddNewMenuViewModel {
    
    /// 메뉴 추가
    func postMenuAPI(storeId: Int, requestBody: [MenuData], completion: @escaping () -> Void) {
        validMenus = menus.filter { $0.name != "" && $0.price > 0 && $0.price <= 8000 }
        
        NetworkService.shared.menuService.postMenu(storeId: storeId, requestBody: validMenus) { result in
            result.handleNetworkResult { _ in
                completion()
            }
        }
    }
    
    /// 메뉴 수정
    func modifyMenuAPI(storeId: Int, id: Int, requestBody: [MenuData], completion: @escaping () -> Void) {
        NetworkService.shared.menuService.patchMenu(storeId: storeId, id: id, requestBody: requestBody) { result in
            result.handleNetworkResult { _ in
                completion()
            }
        }
    }
    
    /// 메뉴 삭제
    func deleteMenuAPI(storeId: Int, id: Int, completion: @escaping () -> Void) {
        NetworkService.shared.menuService.deleteMenu(storeId: storeId, id: id) { result in
            result.handleNetworkResult { _ in
                completion()
            }
        }
    }
}
