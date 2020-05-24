//
//  DatabaseManager.swift
//  DrDomain
//
//  Created by TestUser on 10/05/2020.
//  Copyright © 2020 TestUser. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth

class DatabaseManager
{
    
    let databaseRef: DatabaseReference = Database.database().reference(fromURL: "https://drdomain-b814f.firebaseio.com/")
    let storageRef = Storage.storage().reference()
    let currentUserID = Auth.auth().currentUser?.uid
    
    func storeNewUserIntoFirebase(_ databaseReference: DatabaseReference, _ newUserID: String, _ newUserName: String, _ newUserEmail: String, _ newUserGender: String, _ newUserPhone: String)
    {
        //initialize an empty social platform array
        let socialplatform: Array<String> = ["none"]
        
        let defaultImageUrlStr = "https://firebasestorage.googleapis.com/v0/b/drdomain-b814f.appspot.com/o/defaultuserimage.png?alt=media&token=c8b4de7d-4b61-471c-9757-d26cfd8abe32"
        
        let databaseRef = databaseReference
        let UserRef = databaseRef.child("users").child(newUserID)
        
        let values = ["name": newUserName, "email": newUserEmail, "gender": newUserGender, "phone": newUserPhone, "profileImgURL": defaultImageUrlStr, "socialplatform": socialplatform] as [String : Any]
        
        UserRef.setValue(values)
        
    }
    
    func fetchCurrentUser(_ userID: String, completion:@escaping(CurrentUser) -> ())
    {
        
        var userName: String = ""
        var userEmail: String = ""
        var userGender: String = ""
        var userPhone: String = ""
        var userProfileImage: String = ""
        var userSocialPlatform: Array<String> = []
        
        let databaseRef = Database.database().reference(fromURL: "https://drdomain-b814f.firebaseio.com/")
        let UserRef = databaseRef.child("users").child(userID)
        
        UserRef.observeSingleEvent(of: .value, with:
        {
            
            (snapshot) in
            //get user value
            
            let value = snapshot.value as? NSDictionary

            userName = value?["name"] as! String
            userEmail = value?["email"] as! String
            userGender = value?["gender"] as! String
            userPhone = value?["phone"] as! String
            userProfileImage = value?["profileImgURL"] as! String
            userSocialPlatform = value?["socialplatform"] as! Array<String>
            
            let User = CurrentUser(userID, userName, userEmail, userGender, userPhone, userProfileImage, userSocialPlatform)
            completion(User)
            
        }, withCancel: {
            
            (error) in
            print(error.localizedDescription)
        })
        
     }
    
    func fetchCurrentDoctor(_ doctorID: String, completion:@escaping(Doctor) -> ())
       {
           
           var doctorName: String = ""
           var doctorDomain: String = ""
           var doctorEducation:Array<String> = []
           var doctorLocation:NSDictionary = [String: String]() as NSDictionary
           var totalPeopleRated: Int = 0
           var totalRating: Double = 0
           var meetingTimeInterval: Int = 0
           var acceptAppoint: Bool = true
           var doctorEmail: String = ""
           var doctorGender: String = ""
           var doctorPhone: String = ""
           var doctorProfileImage: String = ""
           var doctorSocialPlatform: Array<String> = []
           
           let databaseRef = Database.database().reference(fromURL: "https://drdomain-b814f.firebaseio.com/")
           let UserRef = databaseRef.child("doctors").child(doctorID)
           
           UserRef.observeSingleEvent(of: .value, with:
           {
               
               (snapshot) in
               //get user value
               
               let value = snapshot.value as? NSDictionary

               doctorName = value?["name"] as! String
               doctorDomain = value?["domain"] as! String
               doctorEmail = value?["email"] as! String
               doctorGender = value?["gender"] as! String
               doctorPhone = value?["phone"] as! String
               doctorProfileImage = value?["profileImgURL"] as! String
               doctorSocialPlatform = value?["socialplatform"] as! Array<String>
               doctorEducation = value?["education"] as! Array<String>
               doctorLocation = value?["location"] as! NSDictionary
               totalPeopleRated = value?["totalPeopleRated"] as! Int
               totalRating = value?["totalRating"] as! Double
               meetingTimeInterval = value?["meetingTimeInterval"] as! Int
               acceptAppoint = value?["acceptAppoint"] as! Bool
               
               let doctor = Doctor(doctorID, doctorName, doctorDomain, doctorEmail, doctorEducation, doctorGender, doctorPhone, doctorLocation, doctorProfileImage, doctorSocialPlatform, totalPeopleRated, totalRating, meetingTimeInterval, acceptAppoint)
            
               completion(doctor)
               
           }, withCancel: {
               
               (error) in
               print(error.localizedDescription)
           })
           
        }
    
    
}
