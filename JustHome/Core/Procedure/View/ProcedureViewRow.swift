//
//  ProcedureViewRow.swift
//  JustHome
//
//  Created by Huynh Nguyen Tuan Duy on 18/11/24.
//

import SwiftUI

struct ProcedureViewRow: View {
    let contract: ContractByCustomerIDResponse
    var body: some View {
        HStack{
            VStack(alignment: .leading){
                Text(contract.projectName)
                    .font(.title3.bold())
                Text("Mã căn: \(contract.propertyCode)")
                    .font(.headline)
                    .foregroundStyle(.secondary)
                Text("Giai đoạn thủ tục: \(contract.status)")
                    .font(.caption.bold())
                    .foregroundStyle(.red)
                    .multilineTextAlignment(.leading)
    
            }
            Spacer()
            VStack(alignment: .leading){
                Text("Tổng tiền: ")
                Text(contract.priceSold, format: .currency(code: "VND"))
            }.foregroundStyle(.primaryGreen)
        }
        .fontDesign(.rounded)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.primaryGreen, lineWidth: 3)
        )
        .padding(.horizontal)
    }
}

//#Preview {
//    ProcedureViewRow()
//}
