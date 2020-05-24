//
//  File.swift
//  DrDomain
//
//  Created by TestUser on 16/05/2020.
//  Copyright © 2020 TestUser. All rights reserved.
//

import Foundation

class Doctor
{
    
    var UID: String?
    var name: String?
    var domain: String?
    var email: String?
    var education: Array<String>?
    var gender: String?
    var phone: String?
    var location: NSDictionary?
    var profileImgURL: String?
    var socialplatform: Array<String>?
    var totalPeopleRated: Int?
    var totalRating: Double?
    var meetingTimeInterval: Int?
    var acceptAppoint: Bool?
    
    init(_ UID: String, _ name: String, _ domain: String, _ email: String, _ education: Array<String>, _ gender: String, _ phone: String, _ location: NSDictionary, _ profileImgURL: String, _ socialplatform: Array<String>, _ totalPeopleRated: Int, _ totalRating: Double, _ meetingTimeInterval: Int, _ acceptAppoint: Bool) {
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
        self.totalPeopleRated = totalPeopleRated
        self.totalRating = totalRating
        self.meetingTimeInterval = meetingTimeInterval
        self.acceptAppoint = acceptAppoint
    }
    
    init()
    {
        self.UID = nil
        self.name = nil
        self.domain = nil
        self.email = nil
        self.education = nil
        self.gender = nil
        self.phone = nil
        self.location = nil
        self.profileImgURL = nil
        self.socialplatform = nil
        self.totalPeopleRated = nil
        self.totalRating = nil
    }
    
}
