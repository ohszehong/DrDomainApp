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
    let PC = PatientControllers()
    let DC = DoctorController()
    
    func getTotalDoctor(completion:@escaping(Int) -> ())
    {
        let databaseRef = dbManager.databaseRef
        
        let doctorRef = databaseRef.child("doctors")
        
        
        doctorRef.observe(.value, with: {
            
            snapshot in
            
            let totalDoctor = Int(snapshot.childrenCount)
            
            completion(totalDoctor)
            
        })
           
           
    }
    
    //get doctor list and load to patient side
    func getDoctorList(completion:@escaping(Array<Doctor>) -> ())
    {
        let databaseRef = dbManager.databaseRef
        
        let doctorRef = databaseRef.child("doctors")
        
        var doctorArray: Array<Doctor> = []
        
        doctorRef.observe(.value) {
            
            (snapshot) in
            
            let doctorList = snapshot.value as! NSDictionary
            
            doctorList.forEach { (key, value) in
                //intialize each doctor and put into an array
                let doctorID = key as! String
                let doctorInfo = value as! NSDictionary
                
                let doctorDomain = doctorInfo.value(forKey: "domain") as! String
                let doctorEdu = doctorInfo.value(forKey: "education") as! Array<String>
                let doctorEmail = doctorInfo.value(forKey: "email") as! String
                let doctorGender = doctorInfo.value(forKey: "gender") as! String
                
                let doctorLocation = doctorInfo.value(forKey: "location") as! NSDictionary
                
                let doctorName = doctorInfo.value(forKey: "name") as! String
                let doctorPhone = doctorInfo.value(forKey: "phone") as! String
                let doctorProfileImage = doctorInfo.value(forKey: "profileImgURL") as! String
                let doctorSocialPlatform = doctorInfo.value(forKey: "socialplatform") as! Array<String>
                
                let doctorMeetingTimeInterval = doctorInfo.value(forKey: "meetingTimeInterval") as! Int
                let doctorAcceptAppoint = doctorInfo.value(forKey: "acceptAppoint") as! Bool
                
                let totalPeopleRated = doctorInfo.value(forKey: "totalPeopleRated") as! Int
                let totalRating = doctorInfo.value(forKey: "totalRating") as! Double
                
                let thisDoctor = Doctor(doctorID, doctorName, doctorDomain, doctorEmail, doctorEdu, doctorGender, doctorPhone, doctorLocation, doctorProfileImage, doctorSocialPlatform, totalPeopleRated, totalRating, doctorMeetingTimeInterval, doctorAcceptAppoint)
                
                doctorArray.append(thisDoctor)
            
                completion(doctorArray)
                
            }
            
        }
        
    }
    
    func getPatientAppointmentsList(completion:@escaping(Array<Appointment>)-> ())
    {
        let databaseRef = dbManager.databaseRef
        let patientRef = databaseRef.child("users").child(PC.thisUserID!)
        
        
        var appointmentArray:Array<Appointment> = []
        
        patientRef.observeSingleEvent(of: .value, with: { (snapshot) in
        if snapshot.hasChild("Appointment")
        {
        
        patientRef.observeSingleEvent(of: .value, with: {
                   
        (snapshot) in
                   
        let patientInfo = snapshot.value as! NSDictionary
        let appointmentList = patientInfo.value(forKey: "Appointment") as! NSDictionary
                   
        appointmentList.forEach { (key, value) in
        //intialize each appointment and put into array
            
        let appointmentID = key as! String
        let appointmentInfo = value as! NSDictionary
            
        let appointmentDoctorID = appointmentInfo.value(forKey: "doctorID") as! String
        let appointmentDoctorName = appointmentInfo.value(forKey: "doctorName") as! String
        let appointmentPatientID = appointmentInfo.value(forKey: "patientID") as! String
        let appointmentPatientName = appointmentInfo.value(forKey: "patientName") as! String
        let appointmentStartTime = appointmentInfo.value(forKey: "startTime") as! String
        let appointmentEndTime = appointmentInfo.value(forKey: "endTime") as! String
        let appointmentActive = appointmentInfo.value(forKey: "active") as! Bool
        let appointmentIsCancel = appointmentInfo.value(forKey: "isCancel") as! Bool
      
        //create appointment
        let thisAppointment = Appointment(appointmentID, appointmentDoctorID, appointmentDoctorName, appointmentPatientID, appointmentPatientName, appointmentStartTime, appointmentEndTime, appointmentActive, appointmentIsCancel)
            
            appointmentArray.append(thisAppointment)
            completion(appointmentArray)
        }
                   
    })
    }
        
    })
    }
    
    func getDoctorAppointmentsList(completion:@escaping(Array<Appointment>)-> ())
       {
           let databaseRef = dbManager.databaseRef
           let doctorRef = databaseRef.child("doctors").child(DC.thisDoctorID!)
           
           
           var appointmentArray:Array<Appointment> = []
           
           doctorRef.observeSingleEvent(of: .value, with: { (snapshot) in
           if snapshot.hasChild("Appointment")
           {
           
           doctorRef.observeSingleEvent(of: .value, with: {
                      
           (snapshot) in
                      
           let doctorInfo = snapshot.value as! NSDictionary
           let appointmentList = doctorInfo.value(forKey: "Appointment") as! NSDictionary
                      
           appointmentList.forEach { (key, value) in
           //intialize each appointment and put into array
               
           let appointmentID = key as! String
           let appointmentInfo = value as! NSDictionary
               
           let appointmentDoctorID = appointmentInfo.value(forKey: "doctorID") as! String
           let appointmentDoctorName = appointmentInfo.value(forKey: "doctorName") as! String
           let appointmentPatientID = appointmentInfo.value(forKey: "patientID") as! String
           let appointmentPatientName = appointmentInfo.value(forKey: "patientName") as! String
           let appointmentStartTime = appointmentInfo.value(forKey: "startTime") as! String
           let appointmentEndTime = appointmentInfo.value(forKey: "endTime") as! String
           let appointmentActive = appointmentInfo.value(forKey: "active") as! Bool
           let appointmentIsCancel = appointmentInfo.value(forKey: "isCancel") as! Bool
         
           //create appointment
           let thisAppointment = Appointment(appointmentID, appointmentDoctorID, appointmentDoctorName, appointmentPatientID, appointmentPatientName, appointmentStartTime, appointmentEndTime, appointmentActive, appointmentIsCancel)
               
               appointmentArray.append(thisAppointment)
               completion(appointmentArray)
           }
                      
       })
       }
           
       })
       }
        
    func getThisDoctor(_ doctorID: String, completion:@escaping(Doctor)->())
    {
        let databaseRef = dbManager.databaseRef
        let doctorRef = databaseRef.child("doctors").child(doctorID)
        
        doctorRef.observe(.value) { (snapshot) in
            
            let doctorInfo = snapshot.value as! NSDictionary
            
            let doctorName = doctorInfo.value(forKey: "name") as! String
            let doctorDomain = doctorInfo.value(forKey: "domain") as! String
            let doctorEmail = doctorInfo.value(forKey: "email") as! String
            let doctorEducation = doctorInfo.value(forKey: "education") as! Array<String>
            let doctorGender = doctorInfo.value(forKey: "gender") as! String
            let doctorPhone = doctorInfo.value(forKey: "phone") as! String
            let doctorLocation = doctorInfo.value(forKey: "location") as! NSDictionary
            let doctorProfileImgURL = doctorInfo.value(forKey: "profileImgURL") as! String
            let doctorSocialplatform = doctorInfo.value(forKey: "socialplatform") as! Array<String>
            let doctorTotalPeopleRated = doctorInfo.value(forKey: "totalPeopleRated") as! Int
            let doctorTotalRating = doctorInfo.value(forKey: "totalRating") as! Double
            let doctorMeetingTimeInterval = doctorInfo.value(forKey: "meetingTimeInterval") as! Int
            let doctorAcceptAppoint = doctorInfo.value(forKey: "acceptAppoint") as! Bool
            
            let thisDoctor = Doctor(doctorID, doctorName, doctorDomain, doctorEmail, doctorEducation, doctorGender, doctorPhone, doctorLocation, doctorProfileImgURL, doctorSocialplatform, doctorTotalPeopleRated, doctorTotalRating, doctorMeetingTimeInterval, doctorAcceptAppoint)
            
            completion(thisDoctor)
            
        }
        
    }
    
    func getThisPatient(_ patientID: String, completion:@escaping(CurrentUser)->())
    {
        let databaseRef = dbManager.databaseRef
        let patientRef = databaseRef.child("users").child(patientID)
        
        patientRef.observeSingleEvent(of: .value , with: { (snapshot) in
            
            let patientInfo = snapshot.value as! NSDictionary
            
            let patientName = patientInfo.value(forKey: "name") as! String
            let patientEmail = patientInfo.value(forKey: "email") as! String
            let patientGender = patientInfo.value(forKey: "gender") as! String
            let patientPhone = patientInfo.value(forKey: "phone") as! String
            let patientProfileImgURL = patientInfo.value(forKey: "profileImgURL") as! String
            let patientSocialplatform = patientInfo.value(forKey: "socialplatform") as! Array<String>
            
            let thisPatient = CurrentUser(patientID, patientName, patientEmail, patientGender, patientPhone, patientProfileImgURL, patientSocialplatform)
            completion(thisPatient)
            
        })
        
    }
        
    func getHospitalList()
    {
        
    }

}

