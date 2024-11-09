//
//  ActivityRowPlaceHolder.swift
//  JustHome
//
//  Created by Huynh Nguyen Tuan Duy on 26/10/24.
//

import SwiftUI

struct ActivityRowPlaceHolder: View {
    var body: some View {
                ForEach(0..<5){ _ in
                ActivityViewRow(bookings: Bookings.sample)
                        .redacted(reason: .placeholder)
                    .shimmering()
        }
    }
}

#Preview {
    ActivityRowPlaceHolder()
}
