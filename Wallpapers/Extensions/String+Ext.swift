//
//  String+Ext.swift
//  Wallpapers
//
//  Created by GaoZimeng on 2/26/25.
//

import Foundation

extension String {
  func convertToHyphens() -> String {
    self.replacingOccurrences(of: " ", with: "-").lowercased()
  }
}
