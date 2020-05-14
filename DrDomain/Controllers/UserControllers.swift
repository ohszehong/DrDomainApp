//
//  UserControllers.swift
//  DrDomain
//
//  Created by TestUser on 12/05/2020.
//  Copyright © 2020 TestUser. All rights reserved.
//

import Foundation
import UIKit

class UserControllers
{
    let dbManager = DatabaseManager()
 
    //user controllers will handle any requests that can be done by both doctors and patients (common function)
    
    func uploadProfileImage(_ selectedImage: UIImage, completion:@escaping(Data) -> ())
    {
        let uploadData = selectedImage.pngData()
        dbManager.uploadProfileImageIntoFirebase(uploadData!) {
            
            (imageUrlString) in
            
            let userProfileImgURLstr = imageUrlString
            
            let userProfileImgURL = URL(string: userProfileImgURLstr)
                
            URLSession.shared.dataTask(with: userProfileImgURL!, completionHandler: {
                    
            (data, response, error) in
                    
            if error != nil
            {
                print(error!)
                return
            }
                
            completion(data!)
                    
            }).resume()
        }
    }
    
    func editCommonInfo(_ InfoType: String , _ newInfo: String)
    {
        
        let userRef = dbManager.databaseRef.child("users").child(dbManager.currentUserID!)
        
        if InfoType == "Name"
        {
            let value = ["name": newInfo]
            
            userRef.updateChildValues(value)
            
        }
        else if InfoType == "Contact Number"
        {
            let value = ["phone": newInfo]
            userRef.updateChildValues(value)
        }
        
    }
    
    func deleteSocialPlatform(_ indexRow: Int, completion:@escaping(Array<String>) -> ())
    {
        let userRef = dbManager.databaseRef.child("users").child(dbManager.currentUserID!)
        
        userRef.observeSingleEvent(of: .value) { (snapshot) in
        let value = snapshot.value as? NSDictionary
        
        var socialplatformArray = value?["socialplatform"] as! Array<String>
        
        print(socialplatformArray)
        
        socialplatformArray.remove(at: indexRow)
        let newValue = ["socialplatform": socialplatformArray]
        userRef.updateChildValues(newValue)
        completion(socialplatformArray)
        
        }
                
    }

    
}
