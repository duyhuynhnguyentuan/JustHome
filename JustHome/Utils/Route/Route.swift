//
//  Route.swift
//  JustHome
//
//  Created by Huynh Nguyen Tuan Duy on 16/10/24.
//

import Foundation
import SwiftUI

enum Route {
    //route for feed detail view aka project detail view
    case projects(project: Project)
}

extension Route {
    //TODO: write buildDeepLink func for sharing an item of project
    static func buildDeepLink(){
        
    }
}

extension Route: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.hashValue)
    }
    static func == (lhs: Route, rhs: Route) -> Bool {
        switch (lhs, rhs){
        case (.projects(let lhsItem), .projects(let rhsItem)):
            return lhsItem == rhsItem
        default:
            return false
        }
    }
}

extension Route: View {
    var body: some View {
        switch self {
        case .projects(let project):
            ProjectDetailView(project: project)
                .navigationBarBackButtonHidden()
        }
    }
}
