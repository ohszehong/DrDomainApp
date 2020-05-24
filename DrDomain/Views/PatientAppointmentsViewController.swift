//
//  PatientAppointmentsViewController.swift
//  DrDomain
//
//  Created by TestUser on 21/05/2020.
//  Copyright © 2020 TestUser. All rights reserved.
//

import UIKit

class PatientAppointmentsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    //variables
    let AC = AppController()
    var AppointmentList:Array<Appointment> = []
    var selectedDoctor:Doctor = Doctor()

    
    //UI elements
    @IBOutlet weak var cvAppointments: UICollectionView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        cvAppointments.delegate = self
        cvAppointments.dataSource = self
        
        //setup linker
        ViewControllersLinkers.patientAppointmentsVC = self
            
    }
 

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.AppointmentList.count
        
    }

    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      
        let currentAppointment = self.AppointmentList[indexPath.row]
          
        var cell: PatientAppointmentCollectionViewCell
           
        cell = self.cvAppointments.dequeueReusableCell(withReuseIdentifier: "Appointment", for: indexPath) as! PatientAppointmentCollectionViewCell
             
        cell.setupTappedGesture()
        cell.setupBorder()
        cell.setupDoctorID(currentAppointment.appointmentDoctorID!)
        cell.setupInfo(currentAppointment.appointmentDoctorName!, currentAppointment.appointmentStartTime!, currentAppointment.appointmentEndTime!)
             
        return cell
              
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ViewDoctorInfo"
        {
            if let destinationViewController = segue.destination as? LookIntoDoctorViewController
            {
                destinationViewController.thisDoctor = self.selectedDoctor
            }
        }
        
    }
           

}
