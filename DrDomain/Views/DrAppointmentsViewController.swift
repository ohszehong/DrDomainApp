//
//  DrAppointmentsViewController.swift
//  DrDomain
//
//  Created by TestUser on 22/05/2020.
//  Copyright © 2020 TestUser. All rights reserved.
//

import UIKit

class DrAppointmentsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
   
    //variables
    var appointmentList:Array<Appointment> = []
    
    //UI elements
    @IBOutlet weak var cvDoctorAppointments: UICollectionView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cvDoctorAppointments.delegate = self
        cvDoctorAppointments.dataSource = self
        
        //set linker
        ViewControllersLinkers.doctorAppointmentsVC = self
        
    }

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return appointmentList.count
       }
       
       func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
           
        
        var cell: DoctorAppointmentCollectionViewCell
        
        let currentAppointment = appointmentList[indexPath.row]
        
        cell = cvDoctorAppointments.dequeueReusableCell(withReuseIdentifier: "Appointment", for: indexPath) as! DoctorAppointmentCollectionViewCell
        
        cell.setupBorder()
        cell.setupButtonBorder()
        cell.setupParentView(self)
        cell.setupAppointmentID(currentAppointment.appointmentID!)
        cell.setupPatientID(currentAppointment.appointmentPatientID!)
        cell.setupInfo(currentAppointment.appointmentPatientName!, currentAppointment.appointmentStartTime!, currentAppointment.appointmentEndTime!)
                 
        return cell
        
       }

}
