//
//  Item.swift
//  Todoey
//
//  Created by Mateusz Sarnowski on 08/05/2020.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    // a backward relationship or reverse
    let parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
