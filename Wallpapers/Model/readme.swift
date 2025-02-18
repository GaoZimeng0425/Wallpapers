//
//  readme.swift
//  Wallpapers
//
//  Created by 高子蒙 on 2023/9/22.
//

import Foundation

class ReadmeViewModel: ObservableObject {
  @Published var readmeText = ""

  init() {
    guard let url = Bundle.main.url(forResource: "README", withExtension: "md") else { return }
    do {
      let data = try Data(contentsOf: url)
      let text = String(data: data, encoding: .utf8)!
      self.readmeText = text
    } catch {}
  }
}
