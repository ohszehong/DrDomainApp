//
//  PatientRecordCollectionViewCell.swift
//  DrDomain
//
//  Created by TestUser on 22/05/2020.
//  Copyright © 2020 TestUser. All rights reserved.
//

import UIKit

class PatientRecordCollectionViewCell: UICollectionViewCell {
    
    //UI elements
    @IBOutlet weak var lblRecordTitle: UILabel!
    @IBOutlet weak var lblTimeRange: UILabel!
    @IBOutlet weak var lblDay: UILabel!
    @IBOutlet weak var lblMonth: UILabel!
    @IBOutlet weak var lblRecordStatus: UILabel!
    
    //variables
    var doctorID: String = ""
    let AC = AppController()
       
    func setupBorder()
    {
        layer.borderWidth = 1
        layer.borderColor = UIColor.black.cgColor
    }
       
    func setupDoctorID(_ doctorID: String)
    {
           self.doctorID = doctorID
    }
    
    func setupStatus(_ isCancel: Bool)
    {
        if isCancel
        {
            lblRecordStatus.text = "Cancelled"
            lblRecordStatus.textColor = UIColor.systemRed
        }
        else
        {
            lblRecordStatus.text = "Completed"
            lblRecordStatus.textColor = UIColor.systemGreen
        }
    }
       
   /* func setupTappedGesture()
    {
           //add tapped Gesture for 4 grid block view
           let cellTappedGesture = UITapGestureRecognizer(target: self, action: #selector (handleMoveToLookIntoDoctorViewController))
                  
           self.addGestureRecognizer(cellTappedGesture)
                  
           self.isUserInteractionEnabled = true
    } */
       
     /*  @objc func handleMoveToLookIntoDoctorViewController()
       {
           AC.getThisDoctor(self.doctorID)
           {
               (thisDoctor) in
               
               ViewControllersLinkers.patientAppointmentsVC?.selectedDoctor = thisDoctor
               ViewControllersLinkers.patientAppointmentsVC?.performSegue(withIdentifier: "ViewDoctorInfo", sender: self)
           }
        
       } */
       
       func setupInfo(_ doctorName: String, _ startTime: String, _ endTime: String)
       {
           lblRecordTitle.text = "Appointment with \(doctorName)"
           
           let calendar = Calendar.current
           
           let startDate = startTime.toDate()
           let endDate = endTime.toDate()
           
            let startDateComponents = calendar.dateComponents([.day, .month, .year, .hour , .minute], from: startDate)
        
        let startHourAndMinute = startDate.toHourAndMinute()
        
        let endHourAndMinute = endDate.toHourAndMinute()
            
           
           lblDay.text = String(startDateComponents.day!)
           
           lblMonth.text = startDate.monthAsString()
           
           lblTimeRange.text = "\(startHourAndMinute) - \(String(endHourAndMinute))"
       }
    

    @IBAction func btnMoveToRateDoctorPage(_ sender: UIButton)
    {
        
        // get doctor instance using doctorID
        AC.getThisDoctor(doctorID) { (doctor) in
                  
        //use linker to set doctor value in super view
        ViewControllersLinkers.patientRecordsVC!.selectedDoctor = doctor
            
        ViewControllersLinkers.patientRecordsVC?.performSegue(withIdentifier: "RateDoctorPage", sender: self)
            
        }
    }
    
    
}

extension Date
{
    func toHourAndMinute() -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: self)
    }
}
