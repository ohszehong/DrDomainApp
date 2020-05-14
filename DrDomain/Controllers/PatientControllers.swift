//
//  PatientControllers.swift
//  DrDomain
//
//  Created by TestUser on 11/05/2020.
//  Copyright © 2020 TestUser. All rights reserved.
//

import Foundation
import FirebaseAuth

class PatientControllers
{
    let thisUserID = Auth.auth().currentUser?.uid
    let dbManager = DatabaseManager()
    
    func getCurrentUserInfoSet(completion:@escaping(CurrentUser) -> ())
    {
        dbManager.fetchCurrentUser(thisUserID!) { (User)  in
        completion(User)
    }
    
    }
    
    
}
