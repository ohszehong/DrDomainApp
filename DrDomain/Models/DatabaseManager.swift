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
    
    //upload profile image into firebase
    func uploadProfileImageIntoFirebase(_ imageData: Data, completion:@escaping(_ imageUrlString: String) -> ())
    {
        //get user id as profileimage name
        let userID = Auth.auth().currentUser?.uid
        let newImageName = userID! + ".png"
        
        let profileImageStorageRef = storageRef.child("user_profileImage").child(newImageName)
        profileImageStorageRef.putData(imageData, metadata: nil) { (metadata, error) in
            if error != nil
            {
                print(error!)
                return
            }
            
            print(metadata!)
            //update user profile image URL in real time database as well
            let userRef = self.databaseRef.child("users").child(userID!)
            
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
                    
                    completion(imageUrlString)
                    
                }
            }
            
        }
        
    }
    
}
