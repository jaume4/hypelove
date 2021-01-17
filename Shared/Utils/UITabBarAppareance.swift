//
//  UITabBarAppareance.swift
//  HypeLove
//
//  Created by Jaume on 10/08/2020.
//  This is super hacky but didn't want to use a hosting controller

import Foundation
import UIKit
import Combine

extension UITabBar {
    
    static let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    static var exchangedImplementations = false
    
    static func setBlurAppareance() {
        let appearence = UITabBar.appearance()
        appearence.backgroundImage = UIImage()
        appearence.isTranslucent = true
//        UITabBar.blurView.frame = UIScreen.main.bounds
        UITabBar.blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        appearence.insertSubview(UITabBar.blurView, at: 1)
        
//        exchangeImplementations()
    }
    
//    static func exchangeImplementations() {
//
//        guard !exchangedImplementations else { return }
//        exchangedImplementations = true
//
//        guard let original = class_getInstanceMethod(UITabBar.self, #selector(UITabBar.traitCollectionDidChange(_:))) else { return }
//        guard let new = class_getInstanceMethod(UITabBar.self, #selector(UITabBar.swizzledTraitCollectionDidChange(_:))) else { return }
//        method_exchangeImplementations(original, new)
//    }
//
//    @objc
//    func swizzledTraitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
//        swizzledTraitCollectionDidChange(previousTraitCollection)
//        UITabBar.blurView.effect = UIBlurEffect(style: traitCollection.userInterfaceStyle == .dark ? .dark : .light)
//    }
}
