//
//  String+Chunk.swift
//  HypeLove
//
//  Created by Jaume on 22/08/2020.
//

import Foundation

extension String {
    
    func chuncked(size: Int) -> [String] {
        return stride(from: 0, to: indices.count, by: size)
            .map { (start: indices.index(startIndex, offsetBy: $0), end: indices.index(startIndex, offsetBy: min($0 + size, indices.count)))  }
            .map { String(self[$0.start..<$0.end]) }
    }
}
