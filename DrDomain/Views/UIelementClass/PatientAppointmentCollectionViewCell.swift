//
//  PatientAppointmentCollectionViewCell.swift
//  DrDomain
//
//  Created by TestUser on 21/05/2020.
//  Copyright © 2020 TestUser. All rights reserved.
//

import UIKit

class PatientAppointmentCollectionViewCell: UICollectionViewCell {
    
    let AC = AppController()
    
    //UI elements
    @IBOutlet weak var lblDay: UILabel!
    @IBOutlet weak var lblMonthName: UILabel!
    @IBOutlet weak var lblTimeRange: UILabel!
    @IBOutlet weak var lblAppointmentTitle: UILabel!
    
    //variables
    var doctorID: String = ""
    
    func setupBorder()
    {
        layer.borderWidth = 1
        layer.borderColor = UIColor.black.cgColor
    }
    
    func setupDoctorID(_ doctorID: String)
    {
        self.doctorID = doctorID
    }
    
    func setupTappedGesture()
    {
        //add tapped Gesture for 4 grid block view
        let cellTappedGesture = UITapGestureRecognizer(target: self, action: #selector (handleMoveToLookIntoDoctorViewController))
               
        self.addGestureRecognizer(cellTappedGesture)
               
        self.isUserInteractionEnabled = true
    }
    
    @objc func handleMoveToLookIntoDoctorViewController()
    {
        AC.getThisDoctor(self.doctorID)
        {
            (thisDoctor) in
            
            ViewControllersLinkers.patientAppointmentsVC?.selectedDoctor = thisDoctor
            ViewControllersLinkers.patientAppointmentsVC?.performSegue(withIdentifier: "ViewDoctorInfo", sender: self)
        }
     
    }
    
    func setupInfo(_ doctorName: String, _ startTime: String, _ endTime: String)
    {
        lblAppointmentTitle.text = "Appointment with \(doctorName)"
        
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
    
}

extension Date
{
    func monthAsString() -> String {
            let df = DateFormatter()
            df.setLocalizedDateFormatFromTemplate("MMM")
            return df.string(from: self)
    }
}
