//
//  Category.swift
//  Todo-List
//
//  Created by Walid  on 7/27/20.
//  Copyright © 2020 Walid . All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var color: String = ""
    let items = List<Item>()
}
