//
//  GridImageView.swift
//  JustHome
//
//  Created by Huynh Nguyen Tuan Duy on 17/10/24.
//

import SwiftUI

struct GridImageView: View {
    @ObservedObject var projectDetailViewModel: ProjectDetailViewModel
    var images: [String]
    var index: Int
    @Environment(\.properties) private var props
    var body: some View {
        Button{
            withAnimation(.easeInOut){
                projectDetailViewModel.selectedImageID = images[index]
                projectDetailViewModel.showImageViewer.toggle()
            }
        }label: {
            ZStack{
                //showing only four grids..
                if index <= 3 {
                    AsyncImage(url: URL(string: images[index])){ image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: (props.size.width * 0.9) / 2, height: 100, alignment: .center)
                            .cornerRadius(12)
                    }placeholder: {
                        Color(.secondarySystemBackground)
                            .frame(width: (props.size.width * 0.9) / 2, height: 100, alignment: .center)
                            .cornerRadius(12)
                    }
                }
                if images.count > 4 && index == 3 {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.black.opacity(0.3))
                        .frame(width: (props.size.width * 0.9) / 2, height: 100, alignment: .center)
                    let remaningImages = images.count - 4
                    Text("+ \(remaningImages)")
                        .font(.title)
                        .fontWeight(.heavy)
                        .foregroundStyle(.white)
                }
            }
        }
    }
}

//#Preview {
//    GridImageView(images: ["",""], index: 2)
//}
