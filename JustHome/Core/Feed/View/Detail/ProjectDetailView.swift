//
//  ProjectDetailView.swift
//  JustHome
//
//  Created by Huynh Nguyen Tuan Duy on 16/10/24.
//

import SwiftUI

struct ProjectDetailView: View {
    @State private var isPresentedPickCategorySheet = false
    @StateObject private var viewModel: ProjectDetailViewModel
    let project: Project
    @Environment(\.dismiss) private var dismiss
    @Environment(\.properties) private var props
    init(project: Project){
        _viewModel = StateObject(wrappedValue: ProjectDetailViewModel())
        self.project = project
    }
    @State private var tabs: [ProjectDetailTabModel] = [
        .init(id: ProjectDetailTabModel.Tab.general),
        .init(id: ProjectDetailTabModel.Tab.policy),
        .init(id: ProjectDetailTabModel.Tab.location),
        .init(id: ProjectDetailTabModel.Tab.utilities),
        .init(id: ProjectDetailTabModel.Tab.related)
    ]
    @State private var activeTab: ProjectDetailTabModel.Tab = .general
    @State private var tabBarScrollState: ProjectDetailTabModel.Tab?
    @State private var mainViewScrollState: ProjectDetailTabModel.Tab?
    var body: some View {
        ScrollView{
            VStack(alignment: .center, spacing: 20) {
                let columns = Array(repeating: GridItem(.flexible(), spacing: 10), count: 2)
                LazyVGrid(columns: columns, alignment: .center) {
                    ForEach(project.images.indices, id: \.self){ index in
                        GridImageView(projectDetailViewModel: viewModel ,images: project.images, index: index)
                    }
                }
                VStack(alignment: .leading){
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
                .frame(maxWidth: props.size.width * 0.95, alignment: .leading)
                //MARK: Booking button
                    Button{
                        isPresentedPickCategorySheet = true
                    }label:{
                        Text("Đặt chỗ")
                            .textCase(.uppercase)
                            .bold()
                            .modifier(JHButtonModifier( buttonWidth: props.size.width * 0.95))
                    }
                //MARK: Contact section
                ContactView()
                //MARK: Scrollable TabView
                CustomTabBar()
                ScrollView(.horizontal) {
                    LazyHStack(spacing: 0) {
                        ForEach(tabs){ tab in
                            switch tab.id {
                            case .general:
                                GeneralTabView()
                                    .frame(width: props.size.width, height: props.size.height * 2)
                                 
                            case .policy:
                                Text("dit")
                                    .frame(width: props.size.width, height:props.size.height)
                    
                            case .location:
                                Text("me")
                                    .frame(width: props.size.width, height:props.size.height)
                               
                            case .utilities:
                                Text("me")
                                    .frame(width: props.size.width, height:props.size.height)
                            case .related:
                                Text("may")
                                    .frame(width: props.size.width, height:props.size.height)
                            }
                     
                        }
                    }
                    .scrollTargetLayout()
                }
                .scrollPosition(id: $mainViewScrollState)
                .scrollIndicators(.hidden)
                .scrollTargetBehavior(.viewAligned)
                .onChange(of: mainViewScrollState){ oldValue, newValue in
                    if let newValue{
                        withAnimation(.smooth) {
                            tabBarScrollState = newValue
                            activeTab = newValue
                        }
                    }
                }
              }
            }
            .scrollIndicators(.hidden)
            .padding()
            .navigationTitle(project.projectName)
            .toolbar {
                ToolbarItemGroup(placement: .topBarLeading) {
                    Button{
                        dismiss()
                    } label: {
                        Image(systemName: "arrow.left")
                            .foregroundStyle(.tertiaryGreen)
                    }
                }
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button{
                        
                    }label: {
                        Image(systemName: "square.and.arrow.up")
                            .foregroundStyle(.tertiaryGreen)
                    }
                    Button{
                        
                    }label: {
                        Image(systemName: "heart")
                            .foregroundStyle(.red)
                    }
                }
            }
            .sheet(isPresented: $isPresentedPickCategorySheet){
                PickProjectCategoryDetail(projectID: project.projectID)
                    .presentationCornerRadius(50)
                    .presentationDetents([.medium, .large])
            }
            .fullScreenCover(isPresented: $viewModel.showImageViewer, content: {
                ImageView(viewModel: viewModel, images: project.images)
            })
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
    @ViewBuilder
    func ContactView() -> some View {
        HStack{
            VStack(alignment: .leading, spacing: 10){
                Text(project.investor)
                    .bold()
              
                Text("Bên bán")
                    .font(.footnote)
            }
            Spacer()
            HStack{
                Label("Liên hệ", systemImage: "phone.bubble")
                    .foregroundStyle(.white)
            }
            .padding()
            .background(
                Capsule()
                    .fill(Color.primaryGreen)
            )
        }
        .padding()
        .background{
            RoundedRectangle(cornerRadius: 12)
                .stroke(.primaryGreen, lineWidth: 2)
        }
    }
    @ViewBuilder
    func CustomTabBar() -> some View {
        ScrollView(.horizontal){
            HStack(spacing: 20){
                ForEach(tabs){ tab in
                    VStack(spacing: 0){
                        Button {
                            withAnimation(.smooth){
                                activeTab = tab.id
                                mainViewScrollState = tab.id
                                tabBarScrollState = tab.id
                            }
                        } label: {
                            Text(tab.id.rawValue)
                                .padding(.vertical,12)
                                .foregroundStyle(activeTab == tab.id ? Color.primary : .primaryGreen)
                                .contentShape(.rect)
                            
                        }
                        .buttonStyle(.plain)
                        if activeTab == tab.id {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.primaryGreen)
                                .frame(height: 5)
                          
                        }
                    }
                    .background(activeTab == tab.id ? Color.lightGreen.opacity(0.3) : .clear)
                    .frame(width: props.size.width / 5)
                }
            }
            .scrollTargetLayout()
        }
        .scrollPosition(id: .init(get: {
            return tabBarScrollState
        }, set: { _ in
            
        }), anchor: .center)
        .overlay(alignment: .bottom){
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(.gray.opacity(0.3))
                    .frame(height: 1)
            }
        }
        .scrollIndicators(.hidden)
        
    }
    //MARK: GeneralTab
    @ViewBuilder
    func GeneralTabView() -> some View {
            List{
                // Trạng thái
                VStack(alignment: .leading, spacing: 5) {
                    Text("Trạng thái")
                        .font(.headline)
                        .foregroundColor(.primaryGreen)
                    Text(project.status)
                        .foregroundColor(.red)
                }
                
                // Tên dự án
                VStack(alignment: .leading, spacing: 5) {
                    Text("Tên dự án")
                        .font(.headline)
                        .foregroundColor(.primaryGreen)
                    Text(project.projectName)
                }
                
                // Chủ đầu tư
                VStack(alignment: .leading, spacing: 5) {
                    Text("Chủ đầu tư")
                        .font(.headline)
                        .foregroundColor(.primaryGreen)
                    Text(project.investor)
                }
                
                // Tổng thầu xây dựng
                VStack(alignment: .leading, spacing: 5) {
                    Text("Tổng thầu xây dựng")
                        .font(.headline)
                        .foregroundColor(.primaryGreen)
                    Text(project.generalContractor)
                }
                
                // Đơn vị thiết kế
                VStack(alignment: .leading, spacing: 5) {
                    Text("Đơn vị thiết kế")
                        .font(.headline)
                        .foregroundColor(.primaryGreen)
                    Text(project.designUnit)
                }
                
                // Tổng diện tích
                VStack(alignment: .leading, spacing: 5) {
                    Text("Tổng diện tích")
                        .font(.headline)
                        .foregroundColor(.primaryGreen)
                    Text(project.totalArea)
                }
                
                // Quy mô
                VStack(alignment: .leading, spacing: 5) {
                    Text("Quy mô")
                        .font(.headline)
                        .foregroundColor(.primaryGreen)
                    Text(project.scale)
                }
                
                // Mật độ xây dựng
                VStack(alignment: .leading, spacing: 5) {
                    Text("Mật độ xây dựng")
                        .font(.headline)
                        .foregroundColor(.primaryGreen)
                    Text(project.buildingDensity)
                }
                
                // Tổng số căn hộ
                VStack(alignment: .leading, spacing: 5) {
                    Text("Tổng số căn hộ")
                        .font(.headline)
                        .foregroundColor(.primaryGreen)
                    Text(project.totalNumberOfApartment)
                }
                
                // Tình trạng pháp lý
                VStack(alignment: .leading, spacing: 5) {
                    Text("Tình trạng pháp lý")
                        .font(.headline)
                        .foregroundColor(.primaryGreen)
                    Text(project.legalStatus)
                }
                
                // Thời gian bàn giao
                VStack(alignment: .leading, spacing: 5) {
                    Text("Thời gian bàn giao")
                        .font(.headline)
                        .foregroundColor(.primaryGreen)
                    Text(project.handOver)
                }
            }
            .scrollDisabled(true)
            .listStyle(.grouped)
    }
}

#Preview {
    ProjectDetailView(project: Project.sample2)
}
