//
//  Query.swift
//  Ngecek
//
//  Created by Wendy Kurniawan on 03/09/20.
//  Copyright © 2020 Wendy Kurniawan. All rights reserved.
//

import Foundation

struct Query: Decodable {
    let pageids: [String]
    let pages: [Int: Page]
}
