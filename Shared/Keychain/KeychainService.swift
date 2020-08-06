//
//  KeychainService.swift
//  HypeLove
//
//  Created by Jaume on 06/08/2020.
//  Copyright © 2020 Jaume. All rights reserved.
//

import Foundation

struct KeychainService {
    
    private init() {}
    private static let serviceName = "co.corbi.hypeLove"
    private static let serviceGroup: String? = nil//"co.corbi.hypeLove.sharedData"
    
    static func save(userName: String, token: String) {
        let item = KeychainPasswordItem(service: serviceName, account: userName, accessGroup: serviceGroup)
        do {
         try item.savePassword(token)
        } catch {
            print("Error saving data to keychain: \(error)")
        }
    }
    
    static func getUserData() -> (userName: String, token: String)? {
        do {
            let passwordItems = try KeychainPasswordItem.passwordItems(forService: serviceName, accessGroup: serviceGroup)
            guard let userInfo = passwordItems.first else { return nil }
            let password = try userInfo.readPassword()
            return (userInfo.account, password)
        } catch {
            print("Error reading user data: \(error)")
            return nil
        }
    }
    
    static func deleteData() {
        do {
            try KeychainPasswordItem.passwordItems(forService: serviceName, accessGroup: serviceGroup).forEach {
                do {
                    try $0.deleteItem()
                } catch {
                    print("Error deleting item for \($0.account): \(error)")
                }
            }
        } catch {
            print("Error accesing pasword items: \(error)")
        }
    }
}
