//
//  UserTargetType.swift
//  Hankkijogbo
//
//  Created by 심서현 on 7/17/24.
//

import Foundation
import Moya

enum UserTargetType {
    
}

extension UserTargetType: BaseTargetType {
    var headerType: HeaderType {
        <#code#>
    }
    
    var utilPath: UtilPath {
        <#code#>
    }
    
    var pathParameter: String? {
        <#code#>
    }
    
    var queryParameter: [String : Any]? {
        <#code#>
    }
    
    var requestBodyParameter: (any Codable)? {
        <#code#>
    }
    
    var path: String {
        <#code#>
    }
    
    var method: Moya.Method {
        <#code#>
    }
    
    
}

