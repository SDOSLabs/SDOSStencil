//
//  Person.swift
//  SDOSStencil
//
//  Created by Alex SDOS on 09/01/2020.
//Copyright © 2020 SDOS. All rights reserved.
//

import Foundation
import RealmSwift

//sourcery:RealmFields
class PersonRealm: Object {

    var name = ""
    var identifier = UUID().uuidString
    
    @objc dynamic var avatar: Data? = nil
    
    let dogs = List<DogRealm>()
    
    override class func primaryKey() -> String? {
        return PersonRealm.Attributes.identifier
    }

}
