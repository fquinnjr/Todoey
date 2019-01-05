//
//  Item.swift
//  Todoey
//
//  Created by Frank A Quinn on 2018-12-21.
//  Copyright © 2018 Frank A Quinn. All rights reserved.
//

import Foundation
//Class must conform to the protocol Encodable so now the Item type is now able to encode itself into a plist or a JSON

//Old way to enforce protocols seperately...class Item: Encodable, Decodable
//New way just say Codable protocol which covers both Encodable and Decodable
class Item: Codable
{
//for the above conforming to be possible, all the properties must be standard data types
    var title : String = ""
    var done : Bool = false
    
    
}
