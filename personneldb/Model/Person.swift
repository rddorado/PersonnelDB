//
//  Personnel.swift
//  personneldb
//
//  Created by Ronaldo II Dorado on 17/7/17.
//  Copyright © 2017 Ronaldo II Dorado. All rights reserved.
//

import Foundation

struct Person {
    var name: String
    var jobTitle: String
    var yearsOfExperience: String
    var description: String
    
    init(firebaseResult: [String:Any]) {
        name = firebaseResult["name"] as? String ?? ""
        jobTitle = firebaseResult["jobTitle"] as? String ?? ""
        yearsOfExperience = firebaseResult["yearsOfExpreience"] as? String ?? ""
        description = firebaseResult["description"] as? String ?? ""
    }
}
