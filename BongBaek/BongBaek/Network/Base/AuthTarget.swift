//
//  AuthTarget.swift
//  BongBaek
//
//  Created by 임재현 on 7/10/25.
//

import Moya


enum APITarget {
    case login
    case signUp
    case retryToken
}


extension APITarget: TargetType {
    var baseURL: URL {
        <#code#>
    }
    
    var path: String {
        <#code#>
    }
    
    var method: Moya.Method {
        <#code#>
    }
    
    var task: Moya.Task {
        <#code#>
    }
    
    var headers: [String : String]? {
        <#code#>
    }
    
    
}
