//
//  AppInfo.swift
//  HypeLove
//
//  Created by Jaume on 10/08/2020.
//

import Foundation

enum AppInfo {

    static let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown version"
    static let buildNumber = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "Unknown build"
    
}
