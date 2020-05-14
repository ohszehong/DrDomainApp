//
//  LoginRegisterViewController.swift
//  DrDomain
//
//  Created by TestUser on 08/05/2020.
//  Copyright © 2020 TestUser. All rights reserved.
//

import UIKit
import Foundation
import FirebaseAuth

class LoginRegisterViewController: UIViewController
{
    //variables
    let LC = LoginController()
    
    //UI elements
    @IBOutlet weak var txtEmail: CustomTextField!
    @IBOutlet weak var imgAppLogo: UIImageView!
    @IBOutlet weak var btnSignIn: CustomButton!
    @IBOutlet weak var txtPassword: CustomTextField!
    @IBOutlet weak var btnCreateAccount: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLogo()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.dismiss(animated: false, completion: nil)
    }
    
    func setLogo()
    {
        imgAppLogo.image = UIImage(named: "applogo")
        imgAppLogo.layer.cornerRadius = imgAppLogo.frame.size.width/2
        imgAppLogo.clipsToBounds = true
        
    }
    

    @IBAction func btnCreateAccount(_ sender: UIButton) {
        
        self.performSegue(withIdentifier: "RegisterPage", sender: self)
        
    }
    

    @IBAction func btnSignIn(_ sender: CustomButton) {
        
        let email = txtEmail.text
        let password = txtPassword.text
        var message = ""
        
         LC.Login(email!, password!)
              { canLogin in
              if canLogin
              {
                //check if email prefix is doctor
                var tempStr = ""
                
                //to stop the loop
                var prefixCount = 0
                
                for char in email!
                {
                    tempStr = tempStr + String(char)
                    prefixCount = prefixCount + 1
                    if prefixCount == 6
                    {
                        break
                    }
                }
                
                //is a prefix for doctor email
                if tempStr == "doctor"
                {
                    self.performSegue(withIdentifier: "DoctorMainPage", sender: self)
                }
                else
                {
                    self.performSegue(withIdentifier: "PatientMainPage", sender: self)
                }
                
              }
                  
              else
              {
                message = "Invalid email or password"
                                
               let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
               alert.addAction(UIAlertAction(title: "Back", style: .default))
               self.present(alert, animated: false, completion: nil)
               return
              }
                
            }
    }
    
}
