//
//  SetTimeIntervalPopUpViewController.swift
//  DrDomain
//
//  Created by TestUser on 23/05/2020.
//  Copyright © 2020 TestUser. All rights reserved.
//

import UIKit

class SetTimeIntervalPopUpViewController: UIViewController {

    
    //UI elements
    @IBOutlet weak var lblCurrentMinutes: UILabel!
    @IBOutlet weak var txtNewMinutes: UITextField!
    @IBOutlet weak var lblErrorText: UILabel!
    
    //variables
    let DC = DoctorController()
    var minutesInterval:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblCurrentMinutes.text = String(self.minutesInterval)
        
    }
    
    
    @IBAction func btnCancel(_ sender: UIButton)
    {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func btnSetTimeInterval(_ sender: UIButton)
    {
        if let newTimeInterval = txtNewMinutes.text
        {
            let trimmednewName = newTimeInterval.trimmingCharacters(in: .whitespacesAndNewlines)
                   
            if trimmednewName.isEmpty
            {
                self.lblErrorText.text = "*Please fill new time interval"
                self.lblErrorText.sizeToFit()
            }
                
            else if !newTimeInterval.stringIsInt()
            {
                self.lblErrorText.text = "*Invalid minute(s) input"
                self.lblErrorText.sizeToFit()
            }
                   
            else
            {
                let newTimeIntervalInInt = Int(newTimeInterval)
                DC.setNewTimeInterval(newTimeIntervalInInt!)
                ViewControllersLinkers.doctorMainPageVC?.doctorTimeInterval = newTimeIntervalInInt!
                dismiss(animated: true, completion: nil)
                       
            }
                   
        }

    }
    
}

extension String
{
    func stringIsInt() -> Bool
    {
        if Int(self) != nil
        {
            return true
        }
        else
        {
            return false
        }
    }
    
    
}
