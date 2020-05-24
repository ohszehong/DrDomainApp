//
//  SelectAppointmentDateViewController.swift
//  DrDomain
//
//  Created by TestUser on 18/05/2020.
//  Copyright © 2020 TestUser. All rights reserved.
//

import UIKit

class SelectAppointmentDateViewController: UIViewController, UITextFieldDelegate
{
    
    //UI elements
    @IBOutlet weak var txtStartTime: UITextField!
    @IBOutlet weak var pickerStartTime: UIDatePicker!
    @IBOutlet weak var btnBookMeeting: UIButton!
    @IBOutlet weak var UIViewSelectBox: UIView!
    @IBOutlet weak var txtEstimatedEndTime: UITextField!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var imgBookedSuccess: UIImageView!
    @IBOutlet weak var lblBookedSuccess: UILabel!
    
    //variables
    var thisDoctor: Doctor = Doctor()
    let PC = PatientControllers()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        txtStartTime.delegate = self

        setupDatePicker()
        
        lblBookedSuccess.layer.borderWidth = 1.5
        lblBookedSuccess.layer.borderColor = UIColor.systemGreen.cgColor
    }
    
    func setupDatePicker()
    {
        let currentDate = Date()
        pickerStartTime.minimumDate = currentDate
        pickerStartTime.minuteInterval = thisDoctor.meetingTimeInterval!
        
        //set max day, > current day by 20 days
        let maxDate = Calendar.current.date(byAdding: .day, value: 20, to: Date())
        pickerStartTime.maximumDate = maxDate
        
        pickerStartTime.addTarget(self, action: #selector(handleSelectedDate), for: .valueChanged)
        
        pickerStartTime.layer.borderWidth = 1
        pickerStartTime.layer.borderColor = UIColor.black.cgColor
        
        pickerStartTime.backgroundColor = UIColor.white
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        imgBookedSuccess.isHidden = true
        lblBookedSuccess.isHidden = true
    }
    
    
    @objc func handleSelectedDate(_ datePicker: UIDatePicker)
    {
        txtStartTime.text = datePicker.date.toString()
        datePicker.isHidden = true
        
        //set estimated end time
        let estimatedEndTime = Calendar.current.date(byAdding: .minute, value: thisDoctor.meetingTimeInterval!, to: datePicker.date)
        
        txtEstimatedEndTime.text = estimatedEndTime?.toString()
    }
    
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == txtStartTime
        {
            textField.endEditing(true)
            pickerStartTime.isHidden = false
        }
        
    }
    
    
    
    @IBAction func btnCancel(_ sender: UIButton) {
    
        dismiss(animated: true, completion: nil)
            
    }
    

    
    
    @IBAction func btnBookMeeting(_ sender: UIButton) {
       
        let currentDate = Date()
       
        if txtStartTime.text == ""
        {
            lblDesc.text = "Please insert date"
        }
            
        else
        {
            
        let selectedDate = txtStartTime.text?.toDate()
               
        //check if selectedDate is lesser than current date
        if selectedDate! < currentDate
        {
            lblDesc.text = "Current time has passed, please reselect the date"
        }
            
        else
        {
            PC.bookAppointment(thisDoctor, UserLinker.thisUser, txtStartTime.text!, txtEstimatedEndTime.text!) { (success,appointment) in
            
            print(success)
                
            if success
            {
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                     //reload the PatientAppointmentCollectionView
                    self.dismiss(animated: true) {
                    //reload the collectionview in PatientPersonalInfoViewController
                                       
                    //access to patientAppointments
                        ViewControllersLinkers.patientAppointmentsVC?.AppointmentList.append(appointment!)
                                       
                    let indexSet = IndexSet(integer: 0)
                                    ViewControllersLinkers.patientAppointmentsVC?.cvAppointments.performBatchUpdates({
                                           ViewControllersLinkers.patientAppointmentsVC?.cvAppointments.reloadSections(indexSet)
                                       }, completion: nil)
                    }
                    
                }
                
                self.imgBookedSuccess.isHidden = false
                self.lblBookedSuccess.isHidden = false
                
            }
            else
            {
                self.lblDesc.text = "Please select another date, schedule already taken"
            }

        }
            
        }
    }
        
    }
    
}

extension Date
{
    func toString() -> String
    {
        let formatter = DateFormatter()
        
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        return formatter.string(from: self)
    }

}

extension String
{
    func toDate() -> Date
    {
        let formatter = DateFormatter()
        
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        return formatter.date(from: self)!
    }
}
