//
//  LoginController.swift
//  DrDomain
//
//  Created by TestUser on 09/05/2020.
//  Copyright © 2020 TestUser. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase

class RegisterController
{
    
    

    func createUser(_ email: String, _ password: String, _ name: String, _ gender: String, _ phone: String, completion:@escaping((Bool) ->()))
    {
        
        Auth.auth().createUser(withEmail: email, password: password)
        {
            (authResult, error) in
            
            //successfully authenticated user
            if(error == nil)
            {
                let newUserID = authResult?.user.uid
                let databaseRef = Database.database().reference(fromURL: "https://drdomain-b814f.firebaseio.com/")
                
                //set new user child reference
                databaseRef.child("users").child(newUserID!)
                
                let dbManager = DatabaseManager()
                
                dbManager.storeNewUserIntoFirebase(databaseRef, newUserID!, name, email, gender, phone)
                
            }
            
            completion(error == nil)
            
        }
    
    }

    
    
}

class LoginController
{
    
    func Login(_ email: String, _ password: String, completion:@escaping((Bool)->()))
    {
        
        Auth.auth().signIn(withEmail: email, password: password)
        {
            (authResult, error) in
            
            completion(error == nil)
        }
        
        
    }
    
}


