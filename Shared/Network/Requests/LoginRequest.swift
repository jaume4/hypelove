//
//  LoginRequest.swift
//  HypeLove
//
//  Created by Jaume on 06/08/2020.
//  Copyright © 2020 Jaume. All rights reserved.
//

import Foundation

enum LoginError: String {
    case wrongPassword = "Wrong password"
    case wrongUsername = "Wrong username"
}

struct LoginRequest: NetworkFormRequest {
    
    typealias Response = LoginResponse
    typealias CustomError = LoginError
    
    let endPoint = "get_token"
    let method = HTTPMethod.post
    let params: [String : String]
    let deviceID: String = {
        let chars = "0123456789abcdef"
        var randomID = ""
        for _ in 0..<32 {
            let char = chars.randomElement()
            randomID.append(char!)
        }
        return randomID
}()
    
    init(userName: String, password: String) {
        params = ["device_id": deviceID,
                "password": password,
                "username": userName]
    }
}

struct LoginResponse: Codable {
    
    let status, username, hmToken: String

    enum CodingKeys: String, CodingKey {
        case status, username
        case hmToken = "hm_token"
    }
}
