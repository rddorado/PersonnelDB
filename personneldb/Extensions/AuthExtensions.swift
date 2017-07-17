//
//  AuthExtensions.swift
//  personneldb
//
//  Created by Ronaldo II Dorado on 17/7/17.
//  Copyright © 2017 Ronaldo II Dorado. All rights reserved.
//

import Foundation
import Firebase

extension Auth {
    class func isLoggedIn() -> Bool{
        return Auth.auth().currentUser != nil
    }
    
    class func signOut() {
        do {
            try Auth.auth().signOut()
        } catch {
            print("Unable to Sign out")
        }
    }
}
