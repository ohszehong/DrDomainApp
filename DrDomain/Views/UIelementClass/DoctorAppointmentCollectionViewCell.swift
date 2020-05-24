//
//  DoctorAppointmentCollectionViewCell.swift
//  DrDomain
//
//  Created by TestUser on 22/05/2020.
//  Copyright © 2020 TestUser. All rights reserved.
//

import UIKit

class DoctorAppointmentCollectionViewCell: UICollectionViewCell
{
    
    //UI elements
    @IBOutlet weak var lblAppointmentTitle: UILabel!
    @IBOutlet weak var lblTimeRange: UILabel!
    @IBOutlet weak var lblDay: UILabel!
    @IBOutlet weak var lblMonthName: UILabel!

    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnDone: UIButton!
    @IBOutlet weak var btnMakeCall: UIButton!
    
    //variables
    var patientID: String = ""
    var patientPhone: String = ""
    var appointmentID: String = ""
    let AC = AppController()
    let DC = DoctorController()
    var parentView: DrAppointmentsViewController? = nil
    
    func setupButtonBorder()
    {
        btnDone.layer.borderWidth = 1
        btnDone.layer.borderColor = UIColor.systemGreen.cgColor
    
        
        btnCancel.layer.borderWidth = 1
        btnCancel.layer.borderColor = UIColor.systemRed.cgColor
    
    }
       
    func setupBorder()
    {
        layer.borderWidth = 1
        layer.borderColor = UIColor.black.cgColor
    }
    
    func setupParentView(_ parentView: DrAppointmentsViewController)
    {
        self.parentView = parentView
    }
       
    func setupPatientID(_ patientID: String)
    {
        self.patientID = patientID
        
        //get patient phone at the same time
        AC.getThisPatient(patientID) { (patient) in
            self.patientPhone = patient.phone!
        }
    
    }
    
    func setupAppointmentID(_ appointmentID: String)
    {
        self.appointmentID = appointmentID
    }
    

    @IBAction func btnMakeCall(_ sender: UIButton)
      {
        let url:NSURL = URL(string: "TEL://\(self.patientPhone)")! as NSURL
             UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
      }
    
       func setupInfo(_ patientName: String, _ startTime: String, _ endTime: String)
       {
          lblAppointmentTitle.text = "Appointment with \(patientName)"
              
              let calendar = Calendar.current
              
              let startDate = startTime.toDate()
              let endDate = endTime.toDate()
              
               let startDateComponents = calendar.dateComponents([.day, .month, .year, .hour , .minute], from: startDate)
           
           let startHourAndMinute = startDate.toHourAndMinute()
           
           let endHourAndMinute = endDate.toHourAndMinute()
               
              
              lblDay.text = String(startDateComponents.day!)
              
              lblMonthName.text = startDate.monthAsString()
              
              lblTimeRange.text = "\(startHourAndMinute) - \(String(endHourAndMinute))"
       }
    
    
    //update the appointment to inactive and reload collection view
    @IBAction func btnDoneAppointment(_ sender: UIButton) {

        DC.completeAppointment(self.appointmentID, self.patientID)
            
        //update array in parent view
        AC.getDoctorAppointmentsList
        {
                (appointmentList) in
                
                ViewControllersLinkers.doctorAppointmentsVC?.appointmentList = []
                            
                var filteredAppointment:Array<Appointment> = []
                            
                for appointment in appointmentList
                {
                    if appointment.appointmentActive!
                    {
                        filteredAppointment.append(appointment)
                    }
        
                }
                            
                ViewControllersLinkers.doctorAppointmentsVC?.appointmentList
                             = filteredAppointment
                
                
                self.parentView?.cvDoctorAppointments.performBatchUpdates({
                    
                    let indexSet = IndexSet(integer: 0)
                    
                    self.parentView?.cvDoctorAppointments.reloadSections(indexSet)
                }, completion: nil)
            }
    }
    
    //update the appointment to inactive and isCancel = true and reload collection view
    
    @IBAction func btnCancelAppointment(_ sender: UIButton)
    {
        DC.cancelAppointment(self.appointmentID, self.patientID)
               
               //update array in parent view
               AC.getDoctorAppointmentsList
               {
                   (appointmentList) in
                         
                   ViewControllersLinkers.doctorAppointmentsVC?.appointmentList = []
                                     
                   var filteredAppointment:Array<Appointment> = []
                                     
                   for appointment in appointmentList
                   {
                       if appointment.appointmentActive!
                       {
                           filteredAppointment.append(appointment)
                       }
                 
                   }
                                     
                   ViewControllersLinkers.doctorAppointmentsVC?.appointmentList
                               = filteredAppointment
                   
                   ViewControllersLinkers.doctorAppointmentsVC?.cvDoctorAppointments.performBatchUpdates({
                       
                       let indexSet = IndexSet(integer: 0)
                       
                       ViewControllersLinkers.doctorAppointmentsVC?.cvDoctorAppointments.reloadSections(indexSet)
                       
                   }, completion: nil)
                  
               }
    }
}
