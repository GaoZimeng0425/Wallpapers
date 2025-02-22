//
//  SelectView.swift
//  Wallpapers
//
//  Created by 高子蒙 on 2023/9/15.
//

import Kingfisher
import SwiftUI

struct ImageSelect: Identifiable {
  let title: String
  let image: Image

  //  var service: any API
  var service: ServiceNames
  var supplier: Suplier

  var id: String {
    title
  }
}

let SelectItems: [ImageSelect] = ServiceNames.allCases.map { item in
  ImageSelect(title: item.name, image: item.display, service: item, supplier: item.supplier)
}

struct SelectView: View {
  let service: ServiceNames
  var onServiceChange: ((_ service: ServiceNames) -> Void)?

  private let columns: [GridItem] = Array(repeating: GridItem(.flexible(), spacing: 10), count: 2)
  private var index: Int {
    SelectItems.firstIndex(where: { $0.service == service }) ?? 0
  }

  var body: some View {
    ScrollView(showsIndicators: false) {
      LazyVGrid(columns: columns, spacing: 15) {
        ForEach(Array(SelectItems.enumerated()), id: \.offset) { i, item in
          GeometryReader { geo in
            Button(action: {
              onServiceChange?(item.service)
            }) {
              item.image
                .resizable()
                .scaledToFill()
                .frame(width: geo.size.width, height: geo.size.height)
                .cornerRadius(10)
                .clipped()
                .overlay {
                  if index == i {
                    RoundedRectangle(cornerRadius: 10)
                      .stroke(Color.white.opacity(0.75), lineWidth: 10).cornerRadius(5)
                  }
                }
            }
            .buttonStyle(.borderless)
            .overlay(alignment: .bottomLeading) {
              ZStack {
                Text(item.title).padding(.vertical, 10).padding(.horizontal, 10)
                  .foregroundColor(Color.white)
                  .frame(minWidth: 10 * 10)
                  .background(Color.black.opacity(0.75))
                  .cornerRadius(5)
              }.padding(15)
                .allowsHitTesting(false)
            }
            .overlay(alignment: .topTrailing) {
              VStack(alignment: .trailing, spacing: 3) {
                item.supplier.image.padding(2)
                  .background(Color.white)
                  .cornerRadius(3)
              }
              .padding(15)
              .allowsHitTesting(false)
            }
            .hoverPoint()
          }.aspectRatio(contentMode: .fill)
        }
      }.frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(10)
    }
  }
}

struct SelectView_Previews: PreviewProvider {
  static var previews: some View {
    ScrollView {
      SelectView(service: .Space)
    }.frame(maxHeight: .infinity)
  }
}
