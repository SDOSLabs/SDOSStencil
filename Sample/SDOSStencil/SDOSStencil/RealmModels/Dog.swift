//
//  Dog.swift
//  DIA-iOS
//
//  Created by Alex SDOS on 07/01/2020.
//  Copyright © 2020 SDOS. All rights reserved.
//

import Foundation
import RealmSwift

//sourcery:RealmFields
class DogRealm: Object {
 
    var name = ""
    var identifier = 0
    
    override class func primaryKey() -> String? {
        return DogRealm.Attributes.identifier
    }
    
}
