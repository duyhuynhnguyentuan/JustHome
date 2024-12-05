//
//  ActivityViewRow.swift
//  JustHome
//
//  Created by Huynh Nguyen Tuan Duy on 26/10/24.
//

import SwiftUI

struct ActivityViewRow: View {
    let bookings: Bookings
    var body: some View {
        VStack(alignment: .leading){
            Text(bookings.status)
                .foregroundStyle(bookings.statusColor)
                .font(.footnote.bold())
            Text(bookings.projectName)
                .foregroundStyle(.primaryText)
                .font(.title.bold())
            Text(bookings.createdTime)
                .foregroundStyle(.gray)
                .font(.caption)
            HStack(spacing: 2){
                Text("Chi tiết")
                    .font(.subheadline.bold())
                    .foregroundStyle(.primaryGreen)
                Image(systemName: "arrow.right.circle")
                    .font(.subheadline.bold())
                    .foregroundStyle(.primaryGreen)
            }
            Divider()
        }
    }
}

#Preview {
    ActivityViewRow(bookings: Bookings.sample)
}
