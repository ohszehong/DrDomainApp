//
//  EditInfoPopUpViewController.swift
//  DrDomain
//
//  Created by TestUser on 13/05/2020.
//  Copyright © 2020 TestUser. All rights reserved.
//

import UIKit

class EditInfoPopUpViewController: UIViewController {

    // UI elements
    @IBOutlet weak var UIViewEditBox: UIView!
    
    @IBOutlet weak var lblEditTitle: UILabel!
    
    @IBOutlet weak var txtEditText: UITextField!
    @IBOutlet weak var btnSaveChanges: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var lblErrorText: UILabel!
    
    
    //variables
    var editBoxTitle = ""
    var editTextplaceholder = ""
    let UC = UserControllers()
    var userRole = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupEditBox()
    }
    

    
    func setupEditBox()
    {
        lblEditTitle.text = editBoxTitle
        txtEditText.placeholder = editTextplaceholder
    }
    
    @IBAction func btnCancel(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func btnSaveChange(_ sender: UIButton) {
        
        if lblEditTitle.text == "Change Name"
        {
            if let newName = txtEditText.text
            {
                let trimmednewName = newName.trimmingCharacters(in: .whitespacesAndNewlines)
                
                if trimmednewName.isEmpty
                {
                    self.lblErrorText.text = "*Please fill in your name"
                    self.lblErrorText.sizeToFit()
                }
                
                
                else
                {
     
                    UC.editCommonInfo("Name", newName, userRole)
                    dismiss(animated: true, completion: nil)
                    
                }
                
            }
        }
        
        else if lblEditTitle.text == "Change Contact Number"
        {
            if let newPhone = txtEditText.text
            {
                if !newPhone.isValidPhone(phone: newPhone)
                {
                    self.lblErrorText.text = "*Invalid phone numbers"
                    self.lblErrorText.sizeToFit()
                }
                
                else
                {
                    UC.editCommonInfo("Contact Number", newPhone, userRole)
                    dismiss(animated: true, completion: nil)
                }
                
            }
        }
        
    }
    
    
    
}
