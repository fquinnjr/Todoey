//
//  Item.swift
//  Todoey
//  This file represents our Item entity using properties rather than attributes that was done previously using Core Data .

//  Created by Frank A Quinn on 2019-02-05.
//  Copyright © 2019 Frank A Quinn. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    /*  dynamic is a declaration modifier that tells the runtime to use dynamic dispatch over standard static dispatch. This allows the properties name and age to be monitored for changes during runtime. This allows Realm to dynamically update the values of the properties in the database at runtime. This dynamic dispatch comes from Objective C APIs. */
    
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
/*  Linking Objects are auto linking containers that represent 0 or more objects that are linked to its owning model object through a property relationship. This is basically the inverse relationship of items. */
    
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items"
    )
/* Each Item has a parentCategory that is of the type Category and it comes from the property called "items". */
}
