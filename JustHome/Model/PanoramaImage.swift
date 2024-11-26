//
//  PanoramaImage.swift
//  JustHome
//
//  Created by Huynh Nguyen Tuan Duy on 26/11/24.
//

import Foundation
struct PanoramaImage: Hashable, Codable, Identifiable, Equatable {
    var id: String {
        panoramaImageID
    }
    let panoramaImageID: String
    let title: String
    let image: String
    let projectID: String
}
