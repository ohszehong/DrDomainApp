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
    
    func bookAppointment(_ thisDoctor:Doctor, _ thisUser:CurrentUser, _ startTime: String, _ endTime: String, completion:@escaping(Bool,Appointment?) -> ())
    {
        
        let databaseRef = dbManager.databaseRef
        let doctorRef = databaseRef.child("doctors").child(thisDoctor.UID!)
        
        let doctorAppointmentList = doctorRef.child("Appointment")
        
        //check if doctor has any appointment before
        doctorRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if !snapshot.hasChild("Appointment")
            {
                //if doctor does not has any appointment before
                let AppointmentID = "\(startTime)>\(endTime)"
                let doctorAppointmentInAppointmentList = doctorAppointmentList.child(AppointmentID)
                
                //save appointment into firebase (user)
                let userRef = databaseRef.child("users").child(self.thisUserID!)
                let userAppointmentList = userRef.child("Appointment")
                let userAppointmentInAppointmentList = userAppointmentList.child(AppointmentID)
                           
                let value = ["patientID":self.thisUserID!,"patientName":thisUser.name!, "doctorID":thisDoctor.UID!,"doctorName": thisDoctor.name!, "startTime":startTime,"endTime":endTime,"active":true, "isCancel":false] as [String : Any]
                
                //create Appointment
                let newCreatedAppointment = Appointment(AppointmentID, thisDoctor.UID!, thisDoctor.name!, self.thisUserID!, thisUser.name!, startTime, endTime, true, false)
                           
                //set value for patient and doctor
                doctorAppointmentInAppointmentList.setValue(value)
                userAppointmentInAppointmentList.setValue(value)
                completion(true,newCreatedAppointment)
            }
            
           else
           {
                //get all appointment keys
                doctorAppointmentList.observeSingleEvent(of: .value, with:
                { (snapshot) in
                                 
                //appointment id
                //let AppointmentID = snapshot.value as! String
                                 
                //appointment id's dictionary
                let appointmentList = snapshot.value as! NSDictionary
                let allAppointments = appointmentList.allKeys as! Array<String>
                    
                var finalResult: Bool = true
                    
                for appointment in allAppointments
                {
                    let eachAppointment = appointmentList.value(forKey: appointment) as! NSDictionary
                    
                    if eachAppointment.value(forKey: "active") as! Bool
                    {
                        let appointmentStartTimeStr = eachAppointment.value(forKey: "startTime") as! String
                        let appointmentEndTimeStr = eachAppointment.value(forKey: "endTime") as! String
                                             
                        let appointmentStartTime = appointmentStartTimeStr.toDate()
                        let appointmentEndTime = appointmentEndTimeStr.toDate()
                                                 
                        let selectedStartTime = startTime.toDate()
                        let selectedEndTime = endTime.toDate()
                                             
                        //compare datetime
                        if appointmentStartTime == selectedStartTime
                        {
                           finalResult = false
                        }
                                             
                        else if (appointmentStartTime >= selectedStartTime && appointmentStartTime < selectedEndTime) || (appointmentEndTime >= selectedStartTime && appointmentEndTime < selectedEndTime)
                        {
                            finalResult = false
                        }
                                             
                    }
                    
                }
                
                //after comparing all the active existing start date and end date
                if finalResult == true
                {
                    
                    let AppointmentID = "\(startTime)>\(endTime)"
                    
                     //save appointment into firebase (doctor)
                    let doctorAppointmentInAppointmentList = doctorAppointmentList.child(AppointmentID)
                    
                    //save appointment into firebase (user)
                    let userRef = databaseRef.child("users").child(self.thisUserID!)
                    let userAppointmentList = userRef.child("Appointment")
                    let userAppointmentInAppointmentList = userAppointmentList.child(AppointmentID)
                    
                                                                                           
                    let value = ["patientID":self.thisUserID!,"patientName":thisUser.name!, "doctorID":thisDoctor.UID!,"doctorName":thisDoctor.name!, "startTime":startTime,"endTime":endTime,"active":true, "isCancel":false] as [String : Any]
                                                                                     
                    //create Appointment
                    let newCreatedAppointment = Appointment(AppointmentID, thisDoctor.UID!, thisDoctor.name!, self.thisUserID!, thisUser.name!, startTime, endTime, true, false)
                    
                    //set value for both doctor's and patient's appointment list
                    doctorAppointmentInAppointmentList.setValue(value)
                    userAppointmentInAppointmentList.setValue(value)
                    completion(finalResult,newCreatedAppointment)
                }
                    
                else
                {
                    completion(finalResult,nil)
                }
                    
                    
            })
        }
            
    })
    
    }
    
    func rateDoctor(_ doctorID: String, _ rating: Double)
    {
        
        let databaseRef = dbManager.databaseRef
        let doctorRef = databaseRef.child("doctors").child(doctorID)
        
        let doctorRatingRef = doctorRef.child("ratingList")
        let patientInDoctorRatingRef = doctorRatingRef.child(thisUserID!)
        
        let ratingValue = ["rating":rating]
        patientInDoctorRatingRef.updateChildValues(ratingValue)
        
        //get child count in doctorRatingRef
        doctorRatingRef.observeSingleEvent(of: .value) { (snapshot) in
            
            var totalRating = 0.0
            
            let ratingList = snapshot.value as! NSDictionary
            let totalPeopleRated = snapshot.childrenCount
            
            ratingList.forEach { (key,value) in
                
                let thisUser = value as! NSDictionary
                let thisUserRating = thisUser.value(forKey: "rating") as! Double
                
                totalRating = totalRating + thisUserRating
                
            }
            
        //update the totalPeopleRated and totalRating for this doctor
            let totalPeopleRatedValue = ["totalPeopleRated": totalPeopleRated]
            let totalRatingValue = ["totalRating": totalRating]
            
            doctorRef.updateChildValues(totalPeopleRatedValue)
            doctorRef.updateChildValues(totalRatingValue)
            
        }
        
    }
    
    
}
