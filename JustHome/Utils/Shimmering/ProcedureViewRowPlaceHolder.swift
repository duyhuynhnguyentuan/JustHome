//
//  ProcedureViewRowPlaceHolder.swift
//  JustHome
//
//  Created by Huynh Nguyen Tuan Duy on 18/11/24.
//

import SwiftUI

struct ProcedureViewRowPlaceHolder: View {
    var body: some View {
        ForEach(0..<5){ _ in
            ProcedureViewRow(contract: ContractByCustomerIDResponse.sample)
                .redacted(reason: .placeholder)
                .shimmering()
        }
    }
}

#Preview {
    ProcedureViewRowPlaceHolder()
}
