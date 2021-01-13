//
//  PostData.swift
//  H4X0R News
//
//  Created by Mateusz Sarnowski on 27/04/2020.
//  Copyright © 2020 Mateusz Sarnowski. All rights reserved.
//

import Foundation

struct Results: Decodable {
    let hits: [Post]
}

struct Post: Decodable, Identifiable {
    var id: String {
        return objectID
    }
    let objectID: String
    let title: String
    let url: String?
    let points: Int
}
