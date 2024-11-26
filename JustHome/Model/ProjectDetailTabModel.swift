//
//  ProjectDetailTabModel.swift
//  JustHome
//
//  Created by Huynh Nguyen Tuan Duy on 18/10/24.
//

import Foundation

struct ProjectDetailTabModel: Identifiable {
    private(set) var id: Tab
    var size: CGSize = .zero
    var minX: CGFloat = .zero
    enum Tab: String, CaseIterable {
        case general = "Tổng quan"
        case policy = "Chính sách"
        case location = "360 Tour"
        case utilities = "Tiện ích"
        case related = "Các loại hình "
    }
}
