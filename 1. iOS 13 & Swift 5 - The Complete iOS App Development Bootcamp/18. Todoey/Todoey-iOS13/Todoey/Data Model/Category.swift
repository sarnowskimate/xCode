//
//  Category.swift
//  Todoey
//
//  Created by Mateusz Sarnowski on 08/05/2020.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    //a forward relationship
    let items = List<Item>()
}
