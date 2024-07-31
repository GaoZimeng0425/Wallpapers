//
//  PlanMenu.swift
//  Wallpapers
//
//  Created by 高子蒙 on 2023/8/28.
//

import SwiftUI

struct PlanMenu: Commands {
    var body: some Commands {
      CommandGroup(before: .newItem) {
        Button("new") {
          print("new")
        }
        Button("new") {
          print("new")
        }
        Button("new") {
          print("new")
        }
      }
      CommandMenu("Click")  {
        Button("0")  {
          print("1")
        }
      }
      CommandMenu("Click")  {
        Button("0")  {
          print("1")
        }
      }
    }
}
