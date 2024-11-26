//
//  LikedProjectsView.swift
//  JustHome
//
//  Created by Huynh Nguyen Tuan Duy on 26/11/24.
//



import SwiftUI
import CoreData

struct LikedProjectsView: View {
    @FetchRequest(
        entity: LikedProject.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \LikedProject.projectName, ascending: true)]
    ) var likedProjects: FetchedResults<LikedProject>
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                Text("Tổng số: \(likedProjects.count)")
                    .font(.title)
                    .padding()

                List(likedProjects, id: \.id) { likedProject in
                    VStack(alignment: .leading) {
                        Text(likedProject.projectName ?? "Unknown Project")
                            .font(.headline)
                        Text(likedProject.location ?? "Unknown Location")
                            .font(.subheadline)
                    }
                    
                }.listStyle(.insetGrouped)
                
            }
            .navigationTitle("Dự án yêu thích")
        }
    }
}


#Preview {
    LikedProjectsView()
}
