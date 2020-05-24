//
//  DoctorRecordCollectionViewCell.swift
//  DrDomain
//
//  Created by TestUser on 22/05/2020.
//  Copyright © 2020 TestUser. All rights reserved.
//

import UIKit

class DoctorRecordCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var lblRecordTitle: UILabel!
    @IBOutlet weak var lblDay: UILabel!
    @IBOutlet weak var lblMonthName: UILabel!
    @IBOutlet weak var lblTimeRange: UILabel!
    @IBOutlet weak var lblRecordStatus: UILabel!
    
    //variables
    var patientID: String = ""
          
       func setupBorder()
       {
          layer.borderWidth = 1
          layer.borderColor = UIColor.black.cgColor
       }
          
       func setupPatientID(_ patientID: String)
       {
        self.patientID = patientID
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
          
          
          func setupInfo(_ patientName: String, _ startTime: String, _ endTime: String)
          {
              lblRecordTitle.text = "Appointment with \(patientName)"
              
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
