//
//  ProjectDetailViewModel.swift
//  JustHome
//
//  Created by Huynh Nguyen Tuan Duy on 18/10/24.
//

import Foundation

class ProjectDetailViewModel: ObservableObject {
    @Published var showImageViewer = false
    @Published var selectedImageID: String = ""
}
