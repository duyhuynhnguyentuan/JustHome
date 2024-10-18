//
//  FeedRowPlaceHolder.swift
//  JustHome
//
//  Created by Huynh Nguyen Tuan Duy on 15/10/24.
//

import SwiftUI

struct FeedRowPlaceHolder: View {
    var body: some View {
        ForEach(0..<5){ _ in
            FeedRowView(project: Project.sample, isPlaceHolder: true)
                .redacted(reason: .placeholder)
                .shimmering()
        }
    }
}

#Preview {
    FeedRowPlaceHolder()
}
