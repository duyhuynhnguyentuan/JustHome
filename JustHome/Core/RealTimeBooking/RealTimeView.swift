//
//  RealTimeView.swift
//  JustHome
//
//  Created by Huynh Nguyen Tuan Duy on 8/11/24.
//

import SwiftUI

struct RealTimeView: View {
    @State private var selectedZoneName: String = ""
    @State private var selectedBlockName: String = ""
    @State private var selectedNumFloor: Int? = nil
    @Environment(\.dismiss) private var dismiss
    let categoryDetailID: String
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]
    @StateObject private var viewmodel: RealTimeViewModel
    init(categoryDetailID: String) {
        self.categoryDetailID = categoryDetailID
        _viewmodel = StateObject(wrappedValue: RealTimeViewModel(PropertyService: PropertyService(httpClient: HTTPClient()), categoryDetailID: categoryDetailID))
    }
    @State private var isPresentedSheet: Bool = false
    var body: some View {
        ScrollView(.vertical) {
            VStack {
                //TODO: Check nếu ng dùng chưa tới lựt
                Text(viewmodel.properties.first?.projectName ?? "N/A")
                    .font(.headline)
                
                VStack(alignment: .leading, spacing: 5) {
                    Text("Trạng thái")
                    StatusFilter()
                    PropertyList()
                        .padding(.top)
                }
                .frame(maxWidth: .infinity, alignment: .leading) // Adjust frame to align text to leading
                Spacer()
                Text("Giá: \(Decimal(viewmodel.selectedProperty?.priceSold ?? 0), format: .currency(code: "VND"))")
                    .font(.subheadline.bold())
                    .foregroundStyle(.red)
                Button{
                    Task{
                        //TODO: add confirmation diaglog here insteal
                       let response =  try await viewmodel.selectProperty(by: viewmodel.selectedProperty?.propertyID ?? "N/A")
                        if response?.message != nil {
                            dismiss()
                        }
                    }
                }label: {
                    if let property = viewmodel.selectedProperty {
                        Text("Hoàn tất".uppercased())
                            .font(.title2.bold())
                            .modifier(JHButtonModifier())
                    }else{
                        Text("Bạn chưa chọn cái nào".uppercased())
                            .font(.title2.bold())
                            .modifier(JHButtonModifier(backgroundColor: Color.gray))
                    }
                }
                .disabled(viewmodel.selectedProperty == nil)
                
            }
            .sheet(isPresented: $isPresentedSheet){
                OptionSheet()
                    .presentationDetents([.medium])
                    .presentationDragIndicator(.visible)
                    .presentationCornerRadius(22)

            }
            .padding(.horizontal)
            .frame(maxWidth: .infinity) // Fill the width of the screen
        }
        .onDisappear {
                viewmodel.disconnect()
        }
    }
    @ViewBuilder
    func StatusFilter() -> some View {
        HStack(spacing: 16) {
            ForEach(PropertyFilter.allCases, id: \.self) { filter in
                let count = viewmodel.propertyStatusCounts[filter] ?? 0
                Text("\(filter.rawValue)\n (\(count))")
                    .font(.footnote)
                    .padding(.horizontal)
                    .padding(.vertical, 4)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(filter.color)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(viewmodel.currentFilter == filter ? .green : .clear, lineWidth: 3)
                    )
                    .onTapGesture {
                        withAnimation {
                            viewmodel.currentFilter = filter
                        }
                    }
            }
        }
    }

    @ViewBuilder
    func PropertyList() -> some View {
        Text("Đang mở bán: \(viewmodel.properties.first?.propertyCategoryName ?? "N/A")")
            .font(.title3.bold())
            .foregroundStyle(.primaryGreen)
        VStack {
            HStack {
                Text("Tầng \(viewmodel.selectedNumFloor ?? 0) - \(viewmodel.selectedZoneName) - \(viewmodel.selectedBlockName)")
                Spacer()
                Button {
                    isPresentedSheet.toggle()
                } label: {
                    Text("Lựa chọn")
                        .modifier(JHButtonModifier(buttonWidth: 100))
                }
            }
            Divider()
            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(viewmodel.filteredProperties, id: \.self) { property in
                    PropertyListCell(property: property)
                        .onTapGesture {
                            withAnimation {
                                viewmodel.selectedProperty = property
                            }
                            //TODO: dismiss if property. status = Giu cho
                        }
                }
            }
        }
        .padding(8)
        .background(
            RoundedRectangle(cornerRadius: 5)
                .stroke(Color.black, lineWidth: 2)
        )
    }

    @ViewBuilder
    func PropertyListCell(property: Property) -> some View {
        VStack(spacing: 0) {
            // Top section with a taller frame
            Text(property.propertyCode)
                .font(.title3.bold())
                .foregroundStyle(.white)
                .padding()
                .frame(maxWidth: .infinity) // Make it expand to fill the available width
                .frame(height: 100) // Set a specific height to make it taller
                .background(
                    Rectangle()
                        .fill(property.statusColor) // Change color based on status
                )
            
            // Bottom section
            VStack(spacing: 4) {
                HStack {
                    HStack(spacing: 2) {
                        Image(.expandIcon)
                            .resizable()
                            .renderingMode(.template)
                            .frame(width: 14, height: 14)
                        Text("\(String(format: "%.1f", property.netFloorArea ?? 0.0)) m²")
                            .font(.footnote)
                    }
                    Spacer()
                    HStack(spacing: 2) {
                        Image(.bedRoom)
                            .resizable()
                            .renderingMode(.template)
                            .frame(width: 14, height: 14)
                        Text("\(property.bedRoom)")
                            .font(.footnote)
                    }
                    HStack(spacing: 2) {
                        Image(.bathRoom)
                            .resizable()
                            .renderingMode(.template)
                            .frame(width: 14, height: 14)
                        Text("\(property.bathRoom)")
                            .font(.footnote)
                    }
                }
                HStack {
                    Text("Lầu (nếu có): \(property.numberFloor ?? 0)")
                        .font(.footnote)
                    Spacer()
                }
                HStack {
                    Text("View: \(property.view)")
                        .font(.footnote)
                        .lineLimit(viewmodel.selectedProperty?.propertyID == property.propertyID ? 3 : 1)
                        .truncationMode(.tail)
                    Spacer()
                }
            }
            .padding(.vertical, 4)
            .foregroundStyle(.white)
            .padding(.horizontal, 4)
            .frame(maxWidth: .infinity) // Make it expand to fill the available width
            .background(
                Rectangle()
                    .fill(Color.primaryGreen)
            )
        }
        .frame(maxWidth: UIScreen.main.bounds.width / 2.5) // Set the maxWidth only here
        .overlay(
            viewmodel.selectedProperty?.propertyID == property.propertyID ?
                RoundedRectangle(cornerRadius: 8)
                .stroke(Color.green, lineWidth: 4)
                : nil
        )
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
    @ViewBuilder
    func OptionSheet() -> some View {
        NavigationView {
            Form {
                Picker("Zone (Khu)", selection: $viewmodel.selectedZoneName) {
                    ForEach(viewmodel.properties.compactMap { $0.zoneName }.unique(), id: \.self) { zoneName in
                        Text(zoneName).tag(zoneName)
                    }
                }
                
                Picker("Block (Tòa)", selection: $viewmodel.selectedBlockName) {
                    ForEach(viewmodel.properties.compactMap { $0.blockName }.unique(), id: \.self) { blockName in
                        Text(blockName).tag(blockName)
                    }
                }
                
                Picker("Floor (Tầng)", selection: $viewmodel.selectedNumFloor) {
                    ForEach(viewmodel.properties.compactMap { $0.numFloor }.unique(), id: \.self) { numFloor in
                        Text("Floor \(numFloor)").tag(numFloor)
                    }
                }
            }
            .navigationTitle("Bộ lọc")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Apply") {
                        // Close the sheet
                        isPresentedSheet = false
                    }
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        isPresentedSheet = false
                    }
                }
            }
        }
    }
}
extension Array where Element: Hashable {
    func unique() -> [Element] {
        var set = Set<Element>()
        return filter { set.insert($0).inserted }
    }
}

#Preview {
    RealTimeView(categoryDetailID: "99bf357c-ff7f-45cf-b187-914a816189cc")
}
