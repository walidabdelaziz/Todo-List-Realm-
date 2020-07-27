//
//  Item.swift
//  Todo-List
//
//  Created by Walid  on 7/27/20.
//  Copyright © 2020 Walid . All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date?

    
    
    let parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
