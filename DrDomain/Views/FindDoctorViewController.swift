//
//  FindDoctorViewController.swift
//  DrDomain
//
//  Created by TestUser on 15/05/2020.
//  Copyright © 2020 TestUser. All rights reserved.
//

import UIKit

class FindDoctorViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    //variables
    let AC = AppController()
    var doctorList: Array<Doctor> = []
    var filteredDoctorList: Array<Doctor> = []
    var domainList = DomainSet.domainSet
    var hospitalList = HospitalSet.hospitalSet
    static var thisUser:CurrentUser = CurrentUser()
    
    //UI elements
    @IBOutlet weak var pickerDomain: UIPickerView!
    @IBOutlet weak var txtDomain: UITextField!
    @IBOutlet weak var pickerHospital: UIPickerView!
    @IBOutlet weak var txtHospital: UITextField!
    @IBOutlet weak var btnSearchDoctor: UIButton!
    @IBOutlet weak var txtDoctorName: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set default value for filters
        txtDomain.text = "All"
        txtHospital.text = "All"
        
        //set delegate and datasource for pickers
        pickerDomain.delegate = self
        pickerDomain.dataSource = self
        pickerHospital.delegate = self
        pickerHospital.dataSource = self
        txtDomain.delegate = self
        txtHospital.delegate = self
        
        setupPickerView()
        
        //get doctorList from Appcontrollers
        AC.getDoctorList { (doctorList) in
            self.doctorList = doctorList
        }

    }
    
    func setupPickerView()
    {
        pickerDomain.layer.borderWidth = 1.5
        pickerDomain.layer.borderColor = UIColor.black.cgColor
        
        pickerHospital.layer.borderWidth = 1.5
        pickerHospital.layer.borderColor = UIColor.black.cgColor
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 40
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //reset the doctor array
        filteredDoctorList.removeAll()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        if pickerView == pickerDomain
        {
            return domainList.count
        }
        else if pickerView == pickerHospital
        {
            return hospitalList.count
        }
        
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        self.view.endEditing(true)
        if pickerView == pickerDomain
        {
            return domainList[row]
        }
            
        else if pickerView == pickerHospital
        {
            return hospitalList[row]
        }
        
        return "N/A"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if pickerView == pickerDomain
        {
            self.txtDomain.text = domainList[row]
            self.pickerDomain.isHidden = true
        }
        
        else if pickerView == pickerHospital
        {
            self.txtHospital.text = hospitalList[row]
            self.pickerHospital.isHidden = true
        }
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == self.txtDomain
        {
            self.pickerDomain.isHidden = false
            textField.endEditing(true)
        }
        
        else if textField == self.txtHospital
        {
            self.pickerHospital.isHidden = false
            textField.endEditing(true)
        }
        
    }
    
    
    @IBAction func btnSearchDoctor(_ sender: UIButton) {
        
        self.performSegue(withIdentifier: "SearchDoctorResultPage", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "SearchDoctorResultPage"
        {
            
            if let destinationViewController = segue.destination as? SearchDoctorResultViewController
            {
                
                //filter the doctor list
                if txtDomain.text == "All" && txtHospital.text == "All" && txtDoctorName.text == ""
                {
                    destinationViewController.filteredDoctorList = self.doctorList
                }
                else if txtDomain.text == "All" && txtDoctorName.text == ""
                {
                    
                   for doctor in doctorList
                   {
                    
                    let locationKeys = doctor.location!.allKeys
                    let workingHospital = doctor.location!.value(forKey: locationKeys[0] as! String) as! String
                    
                    if txtHospital.text == workingHospital
                    {
                        filteredDoctorList.append(doctor)
                    }
                    
                   }
                    
                    destinationViewController.filteredDoctorList = self.filteredDoctorList
                    
                }
                    
                else if txtHospital.text == "All" && txtDoctorName.text == ""
                {
                    for doctor in doctorList
                    {
                        let doctorDomain = doctor.domain
                        
                        if txtDomain.text == doctorDomain
                        {
                            filteredDoctorList.append(doctor)
                        }
                    }
                    
                    destinationViewController.filteredDoctorList = self.filteredDoctorList
                }
                
                else if txtDoctorName.text == ""
                {
                    for doctor in doctorList
                    {
                        let locationKeys = doctor.location!.allKeys
                        let workingHospital = doctor.location!.value(forKey: locationKeys[0] as! String) as! String
                        
                        
                        let doctorDomain = doctor.domain
                        
                        if txtDomain.text == doctorDomain && txtHospital.text == workingHospital
                        {
                            filteredDoctorList.append(doctor)
                        }
                        
                    }
                    
                    destinationViewController.filteredDoctorList = self.filteredDoctorList
                    
                }
                    
                else if txtHospital.text == "All" && txtDomain.text == "All"
                {
                    for doctor in doctorList
                    {
                        let doctorName = doctor.name
                                          
                            if txtDoctorName.text == doctorName
                            {
                                filteredDoctorList.append(doctor)
                            }
                    }
                                      
                    destinationViewController.filteredDoctorList = self.filteredDoctorList
                                      
                }
                    
                else if txtDomain.text == "All"
                {
                    for doctor in doctorList
                    {
                        
                        let doctorName = doctor.name
                        
                        let locationKeys = doctor.location!.allKeys
                        let workingHospital = doctor.location!.value(forKey: locationKeys[0] as! String) as! String
                        
                        if txtDoctorName.text == doctorName && txtHospital.text == workingHospital
                        {
                            filteredDoctorList.append(doctor)
                        }
                        
                    }
                    
                    destinationViewController.filteredDoctorList = self.filteredDoctorList
                    
                }
                    
                else if txtHospital.text == "All"
                {
                    for doctor in doctorList
                    {
                        let doctorName = doctor.name
                        
                        let doctorDomain = doctor.domain
                        
                        if txtDoctorName.text == doctorName && txtDomain.text == doctorDomain
                        {
                            filteredDoctorList.append(doctor)
                        }
                    }
                    
                    destinationViewController.filteredDoctorList = self.filteredDoctorList
                    
                }
                
                else
                {
                    for doctor in doctorList
                    {
                        
                        let doctorName = doctor.name
                        
                        let locationKeys = doctor.location!.allKeys
                        let workingHospital = doctor.location!.value(forKey: locationKeys[0] as! String) as! String
                        
                        
                        let doctorDomain = doctor.domain
                        
                        if txtDomain.text == doctorDomain && txtHospital.text == workingHospital && txtDoctorName.text == doctorName
                        {
                            filteredDoctorList.append(doctor)
                        }
                        
                    }
                    
                    destinationViewController.filteredDoctorList = self.filteredDoctorList
                }
                
            }
        }
    }
    

}
