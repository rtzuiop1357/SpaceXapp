//
//  DetailGaleryView.swift
//  SpaceXapp
//
//  Created by vojta on 16.03.2022.
//

import SwiftUI

struct DetailGaleryView: View {
    @ObservedObject var viewModel: DetailViewModel
    
    var body: some View {
        GeometryReader { geo in
            TabView {
                ForEach(viewModel.images) { image in
                    Image(uiImage: image.image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: geo.size.width, height: geo.size.height)
                        .clipped()
                        .onTapGesture(count: 2) {
                            print(image.image)
                        }
                }
            }.tabViewStyle(.page)
        }.ignoresSafeArea(.all, edges: [.leading,.trailing])
    }
}
