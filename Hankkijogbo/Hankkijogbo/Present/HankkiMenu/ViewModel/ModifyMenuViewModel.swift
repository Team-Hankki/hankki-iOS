//
//  ModifyMenuViewModel.swift
//  Hankkijogbo
//
//  Created by 서은수 on 11/4/24.
//

import Moya

final class ModifyMenuViewModel {
    
    var updateButton: ((Bool) -> Void)?
    
    var storeId: Int
    var selectedMenu: SelectableMenuData
    var modifiedMenuData: PatchMenuRequestDTO = PatchMenuRequestDTO() {
        didSet {
            updateButton?(isMenuDataValid())
        }
    }
    
    init(storeId: Int, selectedMenu: SelectableMenuData) {
        self.storeId = storeId
        self.selectedMenu = selectedMenu
    }
}

extension ModifyMenuViewModel {
    
    func isMenuDataValid() -> Bool {
        guard let name = modifiedMenuData.name, let price = modifiedMenuData.price else { return false }
        return !(name.isEmpty) && (price <= 8000)
    }
    
    /// 메뉴 수정
    func modifyMenuAPI(completion: @escaping () -> Void) {
        if isMenuDataValid() {
            NetworkService.shared.menuService.patchMenu(storeId: storeId, id: selectedMenu.id, requestBody: modifiedMenuData) { result in
                result.handleNetworkResult { _ in completion() }
            }
        }
    }
}
