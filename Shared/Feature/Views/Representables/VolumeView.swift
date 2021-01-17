//
//  VolumeView.swift
//  HypeLove
//
//  Created by Jaume on 16/08/2020.
//

import SwiftUI
import MediaPlayer
import UIKit

struct VolumeView: UIViewRepresentable {

    func makeUIView(context: Context) -> MPVolumeView {
        MPVolumeView()
    }

    func updateUIView(_ view: MPVolumeView, context: Context) {

    }
}
