//
//  RegisterPageViewController.swift
//  DrDomain
//
//  Created by TestUser on 09/05/2020.
//  Copyright © 2020 TestUser. All rights reserved.
//

import UIKit

class RegisterPageViewController: UIViewController {

    //variables
    var RC = RegisterController()
    var gender: String = ""
    var name: String = ""
    var email: String = ""
    var phone: String = ""
    
    //UI elements
    @IBOutlet weak var UIViewIconContainer: UIView!
    @IBOutlet weak var UIViewEmailIconContainer: UIView!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var UIViewPasswordIconContainer: UIView!
    @IBOutlet weak var UIViewCfPasswordIconContainer: UIView!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtCfPassword: UITextField!
    @IBOutlet weak var UIViewGenderIconContainer: UIView!
    @IBOutlet weak var btnGender: UIButton!
    @IBOutlet var btnGenderList: [UIButton]!
    @IBOutlet weak var UIViewPhoneIconContainer: UIView!
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var btnRegister: CustomButton!
    @IBOutlet weak var lblErrorText: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupIconContainer()
        setupTextField()
        
        for button in btnGenderList
        {
             button.isHidden = !button.isHidden
        }
            
    }
    
    func setupIconContainer()
    {
        UIViewIconContainer.layer.borderWidth = 0.3
        UIViewIconContainer.layer.borderColor = UIColor.lightGray.cgColor
        UIViewEmailIconContainer.layer.borderWidth = 0.3
        UIViewEmailIconContainer.layer.borderColor = UIColor.lightGray.cgColor
        UIViewPasswordIconContainer.layer.borderWidth = 0.3
             UIViewPasswordIconContainer.layer.borderColor = UIColor.lightGray.cgColor
        UIViewCfPasswordIconContainer.layer.borderWidth = 0.3
        UIViewCfPasswordIconContainer.layer.borderColor = UIColor.lightGray.cgColor
        UIViewGenderIconContainer.layer.borderWidth = 0.3
              UIViewGenderIconContainer.layer.borderColor = UIColor.lightGray.cgColor
        
        UIViewPhoneIconContainer.layer.borderWidth = 0.3
        UIViewPhoneIconContainer.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    func setupTextField()
    {
        txtName.layer.borderWidth = 0.3
        txtName.layer.borderColor = UIColor.lightGray.cgColor
        txtName.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0)
        
        txtEmail.layer.borderWidth = 0.3
        txtEmail.layer.borderColor = UIColor.lightGray.cgColor
        txtEmail.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0)
        
        txtPassword.layer.borderWidth = 0.3
        txtPassword.layer.borderColor = UIColor.lightGray.cgColor
        txtPassword.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0)
        
        txtCfPassword.layer.borderWidth = 0.3
        txtCfPassword.layer.borderColor = UIColor.lightGray.cgColor
        txtCfPassword.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0)
        
        btnGender.layer.borderWidth = 0.3
        btnGender.layer.borderColor = UIColor.lightGray.cgColor
        btnGender.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0)
        
        for btnGender in btnGenderList
        {
            btnGender.layer.borderWidth = 0.3
            btnGender.layer.borderColor = UIColor.lightGray.cgColor
            btnGender.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0)
        }
        
        txtPhone.layer.borderWidth = 0.3
        txtPhone.layer.borderColor = UIColor.lightGray.cgColor
        txtPhone.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0)
      
    }
    
    //gender button
    @IBAction func handleSelection(_ sender: UIButton)
    {
        btnGenderList.forEach{
        (button) in
            UIView.animate(withDuration: 0.3, animations: {
                 button.isHidden = !button.isHidden
                self.view.layoutIfNeeded()
            })
           
        }
    }
    
    
    @IBAction func genderTapped(_ sender: UIButton)
    {
      
        btnGender.setTitle(sender.currentTitle, for: .normal)
        
        btnGender.tintColor = UIColor.black
        
        gender = btnGender.currentTitle!
        
        btnGenderList.forEach{
        (button) in
            UIView.animate(withDuration: 0.3, animations: {
                 button.isHidden = !button.isHidden
                self.view.layoutIfNeeded()
            })
           
        }
        
    }
    
    
    @IBAction func btnRegister(_ sender: CustomButton) {
        
        //check password
        let password = txtPassword.text
        let cfpassword = txtCfPassword.text
        let phone = txtPhone.text
        let name = txtName.text
        let email = txtEmail.text
        let gender = btnGender.title(for: .normal)
        
        lblErrorText.text = ""
        
        if name!.isEmpty
        {
            lblErrorText.text = "* Name is required"
            return
        }
            
        else if email!.isEmpty
        {
            lblErrorText.text = "* Email is required."
        }
        
        else if !password!.isValidLength
        {
            lblErrorText.text = "* Password must contains at least 8 characters"
            return
        }
        
        //if false
        else if !password!.isAlphanumeric()
        {
            lblErrorText.text = "* Password must be alphanumeric"
            return
        }
        
        else if cfpassword != password
        {
            lblErrorText.text = "* Incorrect confirm password"
            return
        }
        
        else if btnGender.title(for: .normal) == "Select Gender"
        {
            lblErrorText.text = "* Please select a gender"
            return
        }
        
        else if !(phone?.isValidPhone(phone: phone!))!
        {
            lblErrorText.text = "* Invalid phone numbers"
            return
        }
        
        //validate email and register using registercontroller
        var message = ""

        RC.createUser(email!, password!, name!, gender!, phone!)
        { canRegister in
        if canRegister
        {
            message = "Welcome to Dr Domain"
            
            let alert = UIAlertController(title: "Register Success", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Back", style: .default, handler:
            {   Void in
                self.dismiss(animated: true, completion: nil)
                    
            }))
            self.present(alert,animated:true, completion:nil)
            
            return
        }
            
        else
        {
            self.lblErrorText.text = "Invalid email format or email already existed"
            return
        }
       }
        
    }
    
    
   /* func setupForm()
    {
        UIViewRegisterForm.layer.shadowColor = UIColor.black.cgColor
        UIViewRegisterForm.layer.shadowOffset = CGSize(width: 0.0, height: 4.0)
        UIViewRegisterForm.layer.shadowRadius = 5
        UIViewRegisterForm.layer.shadowOpacity = 0.4
        UIViewRegisterForm.clipsToBounds = true
        UIViewRegisterForm.layer.cornerRadius = 25
        UIViewRegisterForm.layer.borderWidth = 3.0
        UIViewRegisterForm.layer.borderColor = UIColor.darkGray.cgColor
        
    
    } */
    
}

extension String
{
    //validate PhoneNumber
    func isValidPhone(phone: String) -> Bool {
        let phoneRegex = "^[0-9+]{0,1}+[0-9]{5,16}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phoneTest.evaluate(with: phone)
    }
    
    //validate password alphanumeric and length
    func isAlphanumeric() -> Bool {
         
        var digitCount = 0
        var strCount = 0
        
        for char in self
        {
            if (char.isLetter)
            {
             strCount = strCount + 1
            }
            
            else if (char.isNumber)
            {
            digitCount = digitCount + 1
            }
            
            if (strCount > 0 && digitCount > 0)
            {
                return true
            }
        }
        
        return false
        
      }


    var isValidLength: Bool {
        
        return self.count > 7
        
    }
    
}

