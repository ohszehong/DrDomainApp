//
//  DrRecordsViewController.swift
//  DrDomain
//
//  Created by TestUser on 22/05/2020.
//  Copyright © 2020 TestUser. All rights reserved.
//

import UIKit

class DrRecordsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    //UI elements
    @IBOutlet weak var cvDoctorRecords: UICollectionView!
    
    //variables
    var recordList:Array<Appointment> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cvDoctorRecords.delegate = self
        cvDoctorRecords.dataSource = self
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recordList.count
       }
       
       func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
           
        var cell: DoctorRecordCollectionViewCell
        
        let currentApppointment = recordList[indexPath.row]
        
        cell = cvDoctorRecords.dequeueReusableCell(withReuseIdentifier: "Record", for: indexPath) as! DoctorRecordCollectionViewCell
        
        cell.setupBorder()
        cell.setupStatus(currentApppointment.appointmentIsCancel!)
        cell.setupInfo(currentApppointment.appointmentPatientName!, currentApppointment.appointmentStartTime!, currentApppointment.appointmentEndTime!)
        cell.setupPatientID(currentApppointment.appointmentPatientID!)
        
        return cell
        
       }
       


}
