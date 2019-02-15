//
//  Category.swift
//  Todoey
//
//  Created by Frank A Quinn on 2019-02-05.
//  Copyright © 2019 Frank A Quinn. All rights reserved.
//

import Foundation
import RealmSwift

class Category : Object {
    @objc dynamic var name : String = ""
   
    
    /*List is a Realm data collection type. We initialize it as holding Item type objects*/
    /* Let's give some syntactic examples to clarify using collection type declarations...
     let array = [1,2,3]...This is type inference of integers.
     let array : [Int]()... an empty array of integers.
     let array : [Int] = [1,2,3] array with initial values.
     let array : Array<Int> = [1,2,3]...same as before but the type is a collection type Array containing integers 1 2 and 3 in that order.
     All these expressions above are valid.
     You can also declare an empty array of integers as...
     let array = Array<Int>()
     
     let items = List<Item>... is the forward relationship*/
     let items  = List<Item>()
    
    /* The inverse relationship of Category is defined in the Item.swift file and we create the relationship ourselves. */
    }

