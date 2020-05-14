//
//  UserModel.swift
//  DrDomain
//
//  Created by TestUser on 08/05/2020.
//  Copyright © 2020 TestUser. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

class CurrentUser
{
    
    var UID: String
    var name: String
    var email: String
    var gender: String
    var phone: String
    var profileImageURL: String
    var socialplatform: Array<String>
    

    init(_ UID: String, _ name: String, _ email: String, _ gender: String, _ phone: String, _ profileImageURL: String, _ socialplatform: Array<String>) {
        self.UID = UID
        self.name = name
        self.email = email
        self.gender = gender
        self.phone = phone
        self.profileImageURL = profileImageURL
        self.socialplatform = socialplatform
        }
    
}

class Doctor
{
    
    var UID: String
    var name: String
    var domain: String
    var email: String
    var education: Array<String>
    var gender: String
    var phone: String
    var location: String
    var profileImgURL: String
    var socialplatform: Array<String>
    
    init(_ UID: String, _ name: String, _ domain: String, _ email: String, _ education: Array<String>, _ gender: String, _ phone: String, _ location: String, _ profileImgURL: String, _ socialplatform: Array<String>) {
        self.UID = UID
        self.name = name
        self.domain = domain
        self.email = email
        self.education = education
        self.gender = gender
        self.phone = phone
        self.location = location
        self.profileImgURL = profileImgURL
        self.socialplatform = socialplatform
    }
    
    
    
}



