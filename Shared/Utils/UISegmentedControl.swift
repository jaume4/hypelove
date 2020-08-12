//
//  UISegmentedControl.swift
//  HypeLove
//
//  Created by Jaume on 12/08/2020.
//

import Foundation
import UIKit

extension UISegmentedControl {
  
    static func setAppareance() {
        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(.buttonMain)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor(.white)], for: .selected)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor(.buttonMain)], for: .normal)
        UISegmentedControl.appearance().setTitleTextAttributes([.font: UIFont.systemFont(ofSize: UIFont.systemFontSize, weight: UIFont.Weight.bold)], for: .normal)
    }
}
