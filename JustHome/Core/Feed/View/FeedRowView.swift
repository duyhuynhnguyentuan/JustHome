//
//  FeedRowView.swift
//  JustHome
//
//  Created by Huynh Nguyen Tuan Duy on 15/10/24.
//

import SwiftUI

struct FeedRowView: View {
    let project: Project
    let isPlaceHolder: Bool 
    @Environment(\.properties) var props
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        VStack(alignment: .center){
        VStack(alignment: .leading) {
            // Image with status view
            ZStack(alignment: .bottomLeading) {
                if isPlaceHolder {
                    Image(.logo)
                        .resizable()
                        .scaledToFill()
                        .frame(width: props.size.width * 0.95, height: props.size.width / 1.75)
                        .cornerRadius(15)
                    
                } else {
                    // Show the AsyncImage when not in placeholder mode
                    AsyncImage(url: URL(string: project.images.first!)) { image in
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: props.size.width * 0.95, height: props.size.width / 1.75)
                            .cornerRadius(15)
                    } placeholder: {
                        Color(.secondarySystemBackground)
                            .frame(width: props.size.width * 0.95, height: props.size.width / 1.75)
                            .cornerRadius(15)
                    }
                }
                
                // Status text with conditional background and text color
                Text(project.status)
                    .font(.footnote)
                    .bold()
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(statusBackgroundColor
                        .mask(Capsule()))
                    .foregroundColor(statusTextColor)
                    .cornerRadius(5)
                    .padding([.leading, .bottom], 10)
            }
            
            VStack(alignment: .leading){
                Text("Dự án \(project.projectName)")
                    .font(.title)
                    .bold()
                HStack{
                    Image(systemName: "location.circle")
                    Text(project.location)
                }.foregroundStyle(.primaryGreen)
                .font(.footnote)
                // Small below info View
                HStack(spacing: 25) {
                    ApartmentInfoView()
                    AreaInfoView()
                    Divider()
                        .frame(height: 30)
                    Text(project.investor)
                        .font(.caption)
                        .bold()
                }
            }
        }
    }
    }

    // Small info view of number of apartments
    @ViewBuilder
    func ApartmentInfoView() -> some View {
        HStack(spacing: 10) {
            Image(.apartmentIcon)
                .renderingMode(.template)
                .resizable()
                .scaledToFit()
                .frame(width: 20, height: 30)
            VStack(alignment: .leading) {
                Text(project.totalNumberOfApartment)
                    .font(.caption)
                    .bold()

                Text("Căn hộ")
                    .font(.caption2)
            }
            .frame(height: 20)
        }
    }

    // Small info view of area
    @ViewBuilder
    func AreaInfoView() -> some View {
        HStack(spacing: 10) {
            Image(.expandIcon)
                .renderingMode(.template)
                .resizable()
                .scaledToFit()
                .frame(width: 20, height: 30)
            VStack(alignment: .leading) {
                Text(project.scale)
                    .font(.caption)
                    .bold()
                Text("Diện tích")
                    .font(.caption2)
            }
            .frame(height: 20)
        }
    }

    // Computed properties to determine background and text color based on status
    private var statusBackgroundColor: Color {
        switch project.status {
        case "Sắp mở bán":
            return Color.gray.opacity(0.3)
        case "Đang mở bán":
            return Color.red.opacity(0.7)
        case "Đã bàn giao":
            return Color.green.opacity(0.95)
        default:
            return Color.black.opacity(0.7) // Fallback color
        }
    }

    private var statusTextColor: Color {
        switch project.status {
        case "Sắp mở bán", "Đang mở bán", "Đã bàn giao":
            return Color.white
        default:
            return Color.white // Fallback text color
        }
    }
}

#Preview {
    FeedRowView(project: Project.sample, isPlaceHolder: false)
}

