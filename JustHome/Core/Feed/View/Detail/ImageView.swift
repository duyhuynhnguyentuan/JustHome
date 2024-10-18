//
//  ImageView.swift
//  JustHome
//
//  Created by Huynh Nguyen Tuan Duy on 18/10/24.
//

import SwiftUI

struct ImageView: View {
    @ObservedObject var viewModel: ProjectDetailViewModel
    var images: [String]
    var body: some View {
        ZStack{
            Color.black.ignoresSafeArea()
            TabView(selection: $viewModel.selectedImageID) {
                ForEach(images, id: \.self){ image in
                    AsyncImage(url: URL(string: image)){ image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    }placeholder: {
                        ProgressView()
                    }
                    .tag(image)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
            .overlay(
                    Button{
                        withAnimation(.default){
                            viewModel.showImageViewer.toggle()
                        }
                    }label: {
                        Image(systemName: "xmark")
                            .foregroundStyle(.white)
                            .padding()
                            .background(Color.white.opacity(0.35))
                            .clipShape(Circle())
                    }
                    .padding(10)
                    ,alignment: .topTrailing)
        }
    }
}

//#Preview {
//    ImageView()
//}
