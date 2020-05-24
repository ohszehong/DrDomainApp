//
//  AppointmentModel.swift
//  DrDomain
//
//  Created by TestUser on 21/05/2020.
//  Copyright © 2020 TestUser. All rights reserved.
//

import Foundation

class Appointment
{
    
    var appointmentID: String?
    var appointmentDoctorID: String?
    var appointmentDoctorName: String?
    var appointmentPatientID: String?
    var appointmentPatientName: String?
    var appointmentStartTime: String?
    var appointmentEndTime: String?
    var appointmentActive: Bool?
    var appointmentIsCancel: Bool?
    
    init(_ appointmentID:String, _ appointmentDoctorID: String, _ appointmentDoctorName:String, _ appointmentPatientID: String, _ appointmentPatientName:String, _ appointmentStartTime: String, _ appointmentEndTime: String, _ appointmentActive: Bool, _ appointmentIsCancel: Bool)
    {
        self.appointmentID = appointmentID
        self.appointmentDoctorID = appointmentDoctorID
        self.appointmentDoctorName = appointmentDoctorName
        self.appointmentPatientID = appointmentPatientID
        self.appointmentPatientName = appointmentPatientName
        self.appointmentStartTime = appointmentStartTime
        self.appointmentEndTime = appointmentEndTime
        self.appointmentActive = appointmentActive
        self.appointmentIsCancel = appointmentIsCancel
    }
    
    init()
    {
        self.appointmentID = nil
        self.appointmentDoctorID = nil
        self.appointmentDoctorName = nil
        self.appointmentPatientID = nil
        self.appointmentPatientName = nil
        self.appointmentStartTime = nil
        self.appointmentEndTime = nil
        self.appointmentActive = nil
        self.appointmentIsCancel = nil
    }
    
}
