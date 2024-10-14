//
//  JHEndpoint.swift
//  JustHome
//
//  Created by Huynh Nguyen Tuan Duy on 2/10/24.
//

import Foundation

/// API Endpoints
@frozen enum JHEndpoint: String, CaseIterable, Hashable {
    ///endpoint to customer
    case customers
    ///enpoint for auth
    case auth
}
