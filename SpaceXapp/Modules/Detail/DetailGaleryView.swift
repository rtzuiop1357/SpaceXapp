//
//  DetailGaleryView.swift
//  SpaceXapp
//
//  Created by vojta on 16.03.2022.
//

import SwiftUI

struct DetailGaleryView: View {
    @ObservedObject var viewModel: DetailViewModel
    @State var selected: ImageObject?
    
    var body: some View {
        GeometryReader { geo in
                TabView {
                    ForEach(viewModel.images) { image in
                        Image(uiImage: image.image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: geo.size.width, height: geo.size.height)
                            .clipped()
                            .onTapGesture {
                                selected = image
                            }
                    }
                }.tabViewStyle(.page)
                .popover(item: $selected) { item in
                    return Image(uiImage: item.image)
                }
        }
    }
}
