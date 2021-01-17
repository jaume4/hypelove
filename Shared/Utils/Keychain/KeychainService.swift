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
    
    static func getSavedToken(userName: String) -> String? {
        do {
            let passwordItem = KeychainPasswordItem(service: serviceName, account: userName, accessGroup: serviceGroup)
            let password = try passwordItem.readPassword()
            return password
        } catch {
            print("Error reading user data: \(error)")
            return nil
        }
    }
    
    static func deleteData(userName: String) {
        do {
            let passwordItem = KeychainPasswordItem(service: serviceName, account: userName, accessGroup: serviceGroup)
            try passwordItem.deleteItem()
        } catch {
            print("Error deleting item for \(userName): \(error)")
        }
    }
}
