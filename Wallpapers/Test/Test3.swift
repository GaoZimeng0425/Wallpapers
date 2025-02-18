//
//  Test3.swift
//  Wallpapers
//
//  Created by 高子蒙 on 2023/8/29.
//

import SwiftUI

struct Test3: View {
  var body: some View {
    VStack {
      HSplitView {
        /*@START_MENU_TOKEN@*/Text("Leading")/*@END_MENU_TOKEN@*/.frame(width: 200)
        /*@START_MENU_TOKEN@*/Text("Trailing")/*@END_MENU_TOKEN@*/.frame(width: 200)
      }.frame(maxWidth: .infinity, maxHeight: .infinity)

      Menu("Actions") {
        Button("Duplicate", action: {})
        Button("Rename", action: {})
        Button("Delete…", action: {})
        Menu("Copy") {
          Button("Copy", action: {})
          Button("Copy Formatted", action: {})
          Button("Copy Library Path", action: {})
        }
      }
    }
  }
}

struct Test3_Previews: PreviewProvider {
  static var previews: some View {
    Test3()
  }
}
