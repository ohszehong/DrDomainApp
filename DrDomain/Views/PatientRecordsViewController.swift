//
//  PatientRecordsViewController.swift
//  DrDomain
//
//  Created by TestUser on 22/05/2020.
//  Copyright © 2020 TestUser. All rights reserved.
//

import UIKit

class PatientRecordsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    

    //variables
    var RecordList:Array<Appointment> = []
    var selectedDoctor: Doctor = Doctor()
    
    //UI elements
    @IBOutlet weak var cvPatientRecords: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cvPatientRecords.delegate = self
        cvPatientRecords.dataSource = self
        
        //set linker
        ViewControllersLinkers.patientRecordsVC = self
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return RecordList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var cell: PatientRecordCollectionViewCell
        
        let currentRecord = RecordList[indexPath.row]
        
        cell = self.cvPatientRecords.dequeueReusableCell(withReuseIdentifier: "Record", for: indexPath) as! PatientRecordCollectionViewCell
        
        cell.setupBorder()
        cell.setupInfo(currentRecord.appointmentDoctorName!, currentRecord.appointmentStartTime!, currentRecord.appointmentEndTime!)
        
        cell.setupDoctorID(currentRecord.appointmentDoctorID!)
        cell.setupStatus(currentRecord.appointmentIsCancel!)
        
        return cell
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "RateDoctorPage"
        {
            if let destinationViewController = segue.destination as? RateDoctorViewController
            {
                destinationViewController.thisDoctor = self.selectedDoctor
            }
        }
        
    }
    

}
