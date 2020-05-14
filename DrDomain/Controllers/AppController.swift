//
//  AppController.swift
//  DrDomain
//
//  Created by TestUser on 11/05/2020.
//  Copyright © 2020 TestUser. All rights reserved.
//

import Foundation

class AppController
{
    let dbManager = DatabaseManager()
    
    func getTotalDoctor(completion:@escaping(Int) -> ())
    {
        let databaseRef = dbManager.databaseRef
        
        let DoctorRef = databaseRef.child("doctors")
        
        
        DoctorRef.observe(.value, with: {
            
            snapshot in
            
            let totalDoctor = Int(snapshot.childrenCount)
            
            completion(totalDoctor)
            
        })
           
           
       }

}
