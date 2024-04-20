//
//  Collection+Extension.swift
//  LyricsXR-iOS
//
//  Created by Bexon Pak on 2024-04-19.
//

import Foundation

extension Collection {
  /// Returns the element at the specified index if it is within bounds, otherwise nil.
  subscript (safe index: Index) -> Element? {
    return indices.contains(index) ? self[index] : nil
  }
}
