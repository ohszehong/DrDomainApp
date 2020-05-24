//
//  DoctorController.swift
//  DrDomain
//
//  Created by TestUser on 22/05/2020.
//  Copyright © 2020 TestUser. All rights reserved.
//

import Foundation
import FirebaseAuth

class DoctorController
{
    
    let thisDoctorID = Auth.auth().currentUser?.uid
    let dbManager = DatabaseManager()
    
    func getCurrentDoctorInfoSet(completion:@escaping(Doctor) -> ())
    {
        dbManager.fetchCurrentDoctor(thisDoctorID!, completion: { (doctor) in
            
            completion(doctor)
            
        })
    
    }
    
    func completeAppointment(_ appointmentID: String, _ patientID: String)
    {
        let doctorRef = dbManager.databaseRef.child("doctors").child(thisDoctorID!)
        let patientRef = dbManager.databaseRef.child("users").child(patientID)
        
        let doctorAppointmentRef = doctorRef.child("Appointment").child(appointmentID)
        let patientAppointmentRef = patientRef.child("Appointment").child(appointmentID)
        
        let activeAndIsCancelValues = ["active": false,"isCancel":false]
        doctorAppointmentRef.updateChildValues(activeAndIsCancelValues)
        patientAppointmentRef.updateChildValues(activeAndIsCancelValues)
        
    }
    
    func updateAcceptAppointStatus(_ acceptAppoint: Bool)
    {
        let doctorRef = dbManager.databaseRef.child("doctors").child(thisDoctorID!)
        
        let acceptAppointValue = ["acceptAppoint": acceptAppoint]
        doctorRef.updateChildValues(acceptAppointValue)
    }
    
    func cancelAppointment(_ appointmentID: String, _ patientID: String)
    {
        let doctorRef = dbManager.databaseRef.child("doctors").child(thisDoctorID!)
        let patientRef = dbManager.databaseRef.child("users").child(patientID)
        
        let doctorAppointmentRef = doctorRef.child("Appointment").child(appointmentID)
        let patientAppointmentRef = patientRef.child("Appointment").child(appointmentID)
        
        let activeAndIsCancelValues = ["active": false,"isCancel":true]
        
        doctorAppointmentRef.updateChildValues(activeAndIsCancelValues)
        patientAppointmentRef.updateChildValues(activeAndIsCancelValues)
    }
    
    func setNewTimeInterval(_ timeInterval: Int)
    {
        let doctorRef = dbManager.databaseRef.child("doctors").child(thisDoctorID!)
    
        let newTimeIntervalValue = ["meetingTimeInterval":timeInterval]
        
        doctorRef.updateChildValues(newTimeIntervalValue)
        
    }
    
}
