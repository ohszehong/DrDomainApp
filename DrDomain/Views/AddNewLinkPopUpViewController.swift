//
//  AddNewLinkPopUpViewController.swift
//  DrDomain
//
//  Created by TestUser on 14/05/2020.
//  Copyright © 2020 TestUser. All rights reserved.
//

import UIKit

class AddNewLinkPopUpViewController: UIViewController {

    
    //UI elements
    @IBOutlet weak var txtNewLink: UITextField!
    @IBOutlet weak var btnAddLink: UIButton!
    @IBOutlet weak var UIViewEditBox: UIView!
    @IBOutlet weak var lblErrorText: UILabel!
    
    //variables
    let UC = UserControllers()
    var userRole = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

    @IBAction func btnCancel(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func btnAddLink(_ sender: UIButton) {
        
        if let newLink = txtNewLink.text
        {
            let trimmednewLink = newLink.trimmingCharacters(in: .whitespacesAndNewlines)
            
            if trimmednewLink.isEmpty
            {
                lblErrorText.text = "*Please fill in the link address"
                lblErrorText.sizeToFit()
            }
                
            else if !newLink.isValidURL
            {
                lblErrorText.text = "*Please enter a valid link"
                lblErrorText.sizeToFit()
            }
            
            else
            {
                if userRole == "patient"
                {
                    UC.addNewLink(newLink, ViewControllersLinkers.patientInfoVC!.userSocialPlatform, userRole)
                    {
                        (updatedArray) in
                                      
                        ViewControllersLinkers.patientInfoVC!.userSocialPlatform = updatedArray
                        dismiss(animated: true) {
                        //reload the collectionview in PatientPersonalInfoViewController
                        let indexSet = IndexSet(integer: 0)
                            ViewControllersLinkers.patientInfoVC?.cvSocialPlatform.performBatchUpdates({
                            ViewControllersLinkers.patientInfoVC?.cvSocialPlatform.reloadSections(indexSet)
                            }, completion: nil)
                        }
                    }
                }
                
                else if userRole == "doctor"
                {
                    UC.addNewLink(newLink, ViewControllersLinkers.doctorInfoVC!.doctorSocialPlatform, userRole)
                    {
                        (updatedArray) in
                                      
                        ViewControllersLinkers.doctorInfoVC!.doctorSocialPlatform = updatedArray
                        dismiss(animated: true) {
                        //reload the collectionview in DrPersonalInfoViewController
                        let indexSet = IndexSet(integer: 0)
                        ViewControllersLinkers.doctorInfoVC?.cvSocialPlatform.performBatchUpdates({
                        ViewControllersLinkers.doctorInfoVC?.cvSocialPlatform.reloadSections(indexSet)
                        }, completion: nil)
                       }
                    }
                }
              
            }
            
        }
        
    }
    
}
