//
//  Publisher+WeakAssign.swift
//  HypeLove
//
//  Created by Jaume on 13/08/2020.
//

import Foundation
import Combine

extension Publisher where Failure == Never {
    func weakAssign<Root: AnyObject>(on: ReferenceWritableKeyPath<Root, Output>, object: Root, store: inout Set<AnyCancellable>) {
        self
            .sink(receiveValue: { [weak object] in
                    object?[keyPath: on] = $0
                
            })
            .store(in: &store)
    }
}

