//
//  ProjectDetailView.swift
//  JustHome
//
//  Created by Huynh Nguyen Tuan Duy on 16/10/24.
//

import SwiftUI
import SceneKit
import SwiftUIPanoramaViewer
import Kingfisher

struct ProjectDetailView: View {
    //360 tour
    @State var fullScreen360:Bool = false
    @State var rotationIndicator:Float = 0.0
    //others
    @State private var isPresentedPickCategorySheet = false
    @StateObject private var viewModel: ProjectDetailViewModel
    let project: Project
    @Environment(\.dismiss) private var dismiss
    @Environment(\.properties) private var props
    init(project: Project){
        _viewModel = StateObject(wrappedValue: ProjectDetailViewModel(projectID: project.projectID))
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
                switch viewModel.loadingState {
                case .idle:
                    EmptyView()
                case .loading:
                    ProgressView()
                case .finished:
                    Button{
                        isPresentedPickCategorySheet = true
                    }label:{
                        if(viewModel.hasOpenForSale) {
                            Text("Đặt chỗ")
                                .textCase(.uppercase)
                                .bold()
                                .modifier(JHButtonModifier(buttonWidth: props.size.width * 0.95))
                        }else{
                            Text("Chưa có đợt mở bán nào")
                                .textCase(.uppercase)
                                .bold()
                                .modifier(JHButtonModifier(backgroundColor: Color.secondary, buttonWidth: props.size.width * 0.95))
                        }
                    }
                    .disabled(!viewModel.hasOpenForSale)
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
                                    .frame(width: props.size.width, height: props.size.height)
                                 
                            case .policy:
                                SalesPolicy()
                                    .frame(width: props.size.width, height:props.size.height)
                    
                            case .location:
                                VirtualTour()
                                    .frame(width: props.size.width, height:props.size.height)
                               
                            case .utilities:
                                VStack{
                                 Text("\(project.convenience)")
                                        .padding(.horizontal)
                                    Spacer()
                                }
                                    .frame(width: props.size.width, height:props.size.height)
                            case .related:
                                OpeningPropertyName()
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
        .fullScreenCover(isPresented: $fullScreen360, content:{
            VirtualTour()
        })
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
                        if let link = Route.buildDeepLink(from: .projects(project: project)){
                            ShareLink(item: link) {
                                Image(systemName: "square.and.arrow.up")
                                    .foregroundStyle(.tertiaryGreen)
                            }
                        }
                }
            }
            .sheet(isPresented: $isPresentedPickCategorySheet){
                PickProjectCategoryDetail(projectID: project.projectID, isPresented: $isPresentedPickCategorySheet)
//                    .presentationCornerRadius(50)
                    .presentationDetents([.medium, .large])
            }
            .fullScreenCover(isPresented: $viewModel.showImageViewer, content: {
                ImageView(viewModel: viewModel, images: project.images)
            })
    }
    @ViewBuilder
    func OpeningPropertyName() -> some View {
        VStack(alignment: .leading) {
            Text("Các loại hình đang và đã được mở bán:")
                .font(.title2.bold())
                .padding(.bottom)
            ForEach(viewModel.listOfProejctCategoryDetailName, id: \.self) { name in
                Text("☞\(name)")
                    .font(.title3)
                    .fontWeight(.light)
                    .fontDesign(.monospaced)
            }
            Spacer()
        }
    }

    @ViewBuilder
    func SalesPolicy() -> some View {
        VStack{
            VStack(alignment: .leading){
                Text("\(project.projectName) đang có chính sách bán hàng sau")
                    .font(.callout)
                    .italic()
                Text("Tên chính sách: \(viewModel.salesPolicy.first?.salesPolicyType ?? "N/A")")
                Text("Thời điểm áp dụng: \(viewModel.salesPolicy.first?.expressTime ?? "N/A")")
                Text("Đối tượng áp dụng: \(viewModel.salesPolicy.first?.peopleApplied ?? "N/A")")
                
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(.background)
                    .shadow(
                        color: Color.primaryGreen.opacity(0.7),
                        radius: 8,
                        x: 0,
                        y: 0
                    )
            )
            .padding(.horizontal, 5)
            .frame(maxWidth: .infinity)
            Spacer()
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
            .scrollClipDisabled()
            .listStyle(.grouped)
    }
    //MARK: 360 tour tab
    func VirtualTour() -> some View {
        ScrollView {
            VStack(spacing: 20) {
                if viewModel.panoramaImages.isEmpty {
                    Text("No Panorama Images Available")
                        .frame(maxWidth: .infinity, minHeight: 200)
                        .background(Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                } else {
                    ForEach(viewModel.panoramaImages, id: \.self) { panoramaImage in
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Tổng quan: \(panoramaImage.title)")
                                .font(.footnote)
                                .bold()
                                .padding(.horizontal, 20)
                                .padding(.vertical, 5)
                                .background(Color.gray.mask(Capsule()))
                                .foregroundColor(.white)
                                .cornerRadius(5)

                            AsyncImageView(urlString: panoramaImage.image)
                                .frame(height: UIScreen.main.bounds.height / 3)
                                .cornerRadius(10)
                        }
                        .padding(.horizontal)
                    }
                }
                Spacer(minLength: 20)
            }
            .padding(.vertical)
        }
    }
    struct FullScreen360View: View {
        let image: UIImage

        var body: some View {
            ZStack {
                Color.black.ignoresSafeArea()

                PanoramaViewer(image: SwiftUIPanoramaViewer.bindImage(image)) { key in }
                    cameraMoved: { pitch, yaw, roll in
                        print("Camera moved: Pitch: \(pitch), Yaw: \(yaw), Roll: \(roll)")
                    }
                    .ignoresSafeArea()

                Button(action: {
                    UIApplication.shared.windows.first { $0.isKeyWindow }?.rootViewController?.dismiss(animated: true)
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.white)
                        .font(.system(size: 30))
                }
                .position(x: 30, y: 50)
            }
        }
    }

    struct AsyncImageView: View {
        let urlString: String
        @State private var uiImage: UIImage? = nil
        @State private var isFullScreenPresented: Bool = false // Track full-screen state
        @State var rotationIndicator: Float = 0.0

        var body: some View {
            Group {
                if let uiImage = uiImage {
                    // 360 Cell with Full-Screen Support
                    ZStack(alignment: .bottomLeading) {
                        PanoramaViewer(image: SwiftUIPanoramaViewer.bindImage(uiImage)) { key in }
                            cameraMoved: { pitch, yaw, roll in
                                rotationIndicator = yaw
                            }
                            .gesture(
                                LongPressGesture()
                                    .onEnded { _ in
                                        isFullScreenPresented = true
                                    }
                            ) // Long press to trigger full screen

                        CompassView()
                            .frame(width: 50, height: 50)
                            .rotationEffect(Angle(degrees: Double(rotationIndicator)))
                            .padding(.horizontal)
                            .padding(.bottom, 20) // Positioned at the bottom
                    }
                    .fullScreenCover(isPresented: $isFullScreenPresented) {
                        FullScreen360View(image: uiImage)
                    }
                } else {
                    ProgressView()
                        .onAppear {
                            loadImage(from: urlString) { image in
                                DispatchQueue.main.async {
                                    self.uiImage = image
                                }
                            }
                        }
                }
            }
        }

        func loadImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
            guard let url = URL(string: urlString) else {
                completion(nil) // Invalid URL
                return
            }

            // Fetch image using Kingfisher
            KingfisherManager.shared.retrieveImage(with: url) { result in
                switch result {
                case .success(let value):
                    completion(value.image) // Return the loaded image
                case .failure(let error):
                    print("Error loading image: \(error)")
                    completion(nil) // Return nil on failure
                }
            }
        }
    }


}

#Preview {
    ProjectDetailView(project: Project.sample2)
}



