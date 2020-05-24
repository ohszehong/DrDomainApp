//
//  UserControllers.swift
//  DrDomain
//
//  Created by TestUser on 12/05/2020.
//  Copyright © 2020 TestUser. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth

class UserControllers
{
    //interact with database
    let dbManager = DatabaseManager()
 
    //user controllers will handle any requests that can be done by both doctors and patients (common function)
    
    /*func uploadProfileImage(_ selectedImage: UIImage, completion:@escaping(Data) -> ())
    {
        
    }*/
    
    func editCommonInfo(_ InfoType: String , _ newInfo: String, _ userRole: String)
    {
        
        
        if InfoType == "Name"
        {
            let value = ["name": newInfo]
            
            if userRole == "patient"
            {
               let userRef = dbManager.databaseRef.child("users").child(dbManager.currentUserID!)
               userRef.updateChildValues(value)
            }
            else if userRole == "doctor"
            {
                let doctorRef = dbManager.databaseRef.child("doctors").child(dbManager.currentUserID!)
                doctorRef.updateChildValues(value)
            }
            
        }
        else if InfoType == "Contact Number"
        {
            let value = ["phone": newInfo]
            
            if userRole == "patient"
            {
               let userRef = dbManager.databaseRef.child("users").child(dbManager.currentUserID!)
               userRef.updateChildValues(value)
            }
            else
            {
                let doctorRef = dbManager.databaseRef.child("doctors").child(dbManager.currentUserID!)
                doctorRef.updateChildValues(value)
            }
          
        }
        
    }
    
    func addNewLink(_ newLink: String, _ dataSourceArray: Array<String>, _ userRole: String, completion:(Array<String>) -> ())
    {
        if userRole == "patient"
        {
            let patientRef = dbManager.databaseRef.child("users").child(dbManager.currentUserID!)
                   
            var value = dataSourceArray
            value.append(newLink)
                   
            patientRef.updateChildValues(["socialplatform": value])
            completion(value)
        }
        else if userRole == "doctor"
        {
            let doctorRef = dbManager.databaseRef.child("doctors").child(dbManager.currentUserID!)
            
            var value = dataSourceArray
            value.append(newLink)
            
            doctorRef.updateChildValues(["socialplatform": value])
            completion(value)
        }
       
        
    }
    
    func deleteSocialPlatform(_ indexRow: Int, _ userRole: String, completion:@escaping(Array<String>) -> ())
    {
        if userRole == "patient"
        {
            let patientRef = dbManager.databaseRef.child("users").child(dbManager.currentUserID!)
                 
            patientRef.observeSingleEvent(of: .value) { (snapshot) in
            let value = snapshot.value as? NSDictionary
                 
            var socialplatformArray = value?["socialplatform"] as! Array<String>
                 
            socialplatformArray.remove(at: indexRow)
            let newValue = ["socialplatform": socialplatformArray]
            patientRef.updateChildValues(newValue)
            completion(socialplatformArray)
                 
            }
        }
        else if userRole == "doctor"
        {
            let doctorRef = dbManager.databaseRef.child("doctors").child(dbManager.currentUserID!)
                 
            doctorRef.observeSingleEvent(of: .value) { (snapshot) in
            let value = snapshot.value as? NSDictionary
                 
            var socialplatformArray = value?["socialplatform"] as! Array<String>
                 
            socialplatformArray.remove(at: indexRow)
            let newValue = ["socialplatform": socialplatformArray]
            doctorRef.updateChildValues(newValue)
            completion(socialplatformArray)
                 
            }
        }
     
                
    }
    
       //upload profile image into firebase
    func uploadProfileImage(_ selectedImage: UIImage, _ userType: String, completion:@escaping(Data) -> ())
      {
          let storageRef = dbManager.storageRef
          let databaseRef = dbManager.databaseRef
        
          //get user id as profileimage name
          let userID = dbManager.currentUserID
          let newImageName = userID! + ".png"
        
          let imageData = selectedImage.pngData()
          
          let profileImageStorageRef = storageRef.child("user_profileImage").child(newImageName)
          profileImageStorageRef.putData(imageData!, metadata: nil) { (metadata, error) in
              if error != nil
              {
                  print(error!)
                  return
              }
              
              print(metadata!)
              //update user profile image URL in real time database as well
            
            var userRef = databaseRef
            
            if userType == "patient"
            {
                userRef = databaseRef.child("users").child(userID!)
            }
            else if userType == "doctor"
            {
                userRef = databaseRef.child("doctors").child(userID!)
            }
              
              profileImageStorageRef.downloadURL { (url, error) in
                  guard let downloadURL = url
                      
                  else
                  {
                      print(error!)
                      return
                  }
                  
                  let imageUrlString = downloadURL.absoluteString
                  let value = ["profileImgURL": imageUrlString]
                  userRef.updateChildValues(value) { (error, databaseRef) in
                      
                      if error != nil
                      {
                          print(error!)
                          return
                      }
                      
                    let userProfileImgURL = URL(string: imageUrlString)
                    URLSession.shared.dataTask(with: userProfileImgURL!) {
                        (data, response, error) in
                        
                        if error != nil
                        {
                            print(error!)
                            return
                        }
                        
                        completion(data!)
                        
                    }.resume()
                      
                  }
              }
              
          }
    
    }
    
    
    func logout()
    {
        do
        {
            try Auth.auth().signOut()
            print("logout Success")
        }
        catch (let error)
        {
            print(error.localizedDescription)
        }
        
    }
    
    
}
