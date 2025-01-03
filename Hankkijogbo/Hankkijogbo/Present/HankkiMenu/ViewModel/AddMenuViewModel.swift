//
//  AddMenuViewModel.swift
//  Hankkijogbo
//
//  Created by 서은수 on 10/8/24.
//

import Moya

final class AddMenuViewModel {
    
    var updateButton: ((Bool) -> Void)?
    
    var storeId: Int
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
    
    init(storeId: Int) {
        self.storeId = storeId
    }
}

private extension AddMenuViewModel {
    
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

extension AddMenuViewModel {
    
    /// 메뉴 추가
    func postMenuAPI(completion: @escaping () -> Void) {
        validMenus = menus.filter { $0.name != "" && $0.price > 0 && $0.price <= 8000 }
        
        let requestBody: [MenuRequestDTO] = validMenus.map { $0.toMenuRequestDTO() }
        NetworkService.shared.menuService.postMenu(storeId: storeId, requestBody: requestBody) { result in
            result.handleNetworkResult { _ in
                completion()
            }
        }
    }
}
