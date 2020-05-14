//
//  PatientMainPageViewController.swift
//  DrDomain
//
//  Created by TestUser on 10/05/2020.
//  Copyright © 2020 TestUser. All rights reserved.
//

import UIKit
import FirebaseAuth

class PatientMainPageViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    //variables
    let PC = PatientControllers()
    let UC = UserControllers()
    var userInfoDict: NSMutableDictionary = [:]
    var userSocialPlatform: Array<String> = []
    
    //UI elemments
    @IBOutlet weak var imgProfileImage: UIImageView!
    
    @IBOutlet weak var lblPatientName: UILabel!
    
    @IBOutlet weak var UIViewFindDoctor: UIView!
    
    @IBOutlet weak var UIViewFindHospital: UIView!
    
    @IBOutlet weak var UIViewAppointments: UIView!
    
    @IBOutlet weak var UIViewRecords: UIView!
    
    @IBOutlet weak var lblTotalDoctors: UILabel!
    
    @IBOutlet weak var lblTotalHospital: UILabel!
    
    @IBOutlet weak var lblTotalAppointments: UILabel!
    
    @IBOutlet weak var lblTotalRecords: UILabel!
    
    @IBOutlet weak var imgPersonalInfo: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
        PC.getCurrentUserInfoSet { (User) in
            self.loadDescription(User)
            self.userInfoDict = ["uid": User.UID,"name": User.name,"gender": User.gender,"email": User.email,"phone":User.phone, "profileimage": User.profileImageURL]
            self.userSocialPlatform = User.socialplatform
        }
        
        setupImageGesture()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //reload name
        self.lblPatientName.text = self.userInfoDict["name"] as? String
    }
    
    func setupImageGesture()
    {
        //add tappedGesture for profile image view
        imgProfileImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector (handleSelectProfileImage)))
               
        imgProfileImage.isUserInteractionEnabled = true
        
        imgPersonalInfo.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleMoveToPersonalInfoViewController)))
        
        imgPersonalInfo.isUserInteractionEnabled = true
    }

    @objc func handleMoveToPersonalInfoViewController()
    {
        self.performSegue(withIdentifier: "UserInfoPage", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //passing user info dict to PatientPersonalInfoViewController
        if segue.identifier == "UserInfoPage"
        {
            if let destinationViewController = segue.destination as? PatientPersonalInfoViewController
            {
                destinationViewController.userInfoDict = self.userInfoDict
                destinationViewController.userSocialPlatform = self.userSocialPlatform
            }
        }
    }
        
    @objc func handleSelectProfileImage()
    {
        //create picker controller and present it
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        
        present(picker, animated: true, completion: nil)
        
    }
    
    //if image is selected from UIpicker controller
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
       
        var selectedImage: UIImage?
        
        //retrieve image from picker
        if let editedImage = info[.editedImage] as? UIImage
        {
            selectedImage = editedImage
        }
        else if let originalImage = info[.originalImage] as? UIImage
        {
            selectedImage = originalImage
        }
        
        UC.uploadProfileImage(selectedImage!) {
            (data) in
            
            DispatchQueue.main.async {
                self.imgProfileImage.image = UIImage(data: data)
            }
        }
        
        dismiss(animated: true, completion: nil)
        
    }
    
    
    
    func setupView()
    {
        UIViewFindDoctor.layer.borderWidth = 0.3
        UIViewFindDoctor.layer.cornerRadius = 15
        
        UIViewFindHospital.layer.borderWidth = 0.3
        UIViewFindHospital.layer.cornerRadius = 15
        
        UIViewAppointments.layer.borderWidth = 0.3
        UIViewAppointments.layer.cornerRadius = 15
        
        UIViewRecords.layer.borderWidth = 0.3
        UIViewRecords.layer.cornerRadius = 15

        imgProfileImage.layer.cornerRadius = imgProfileImage.frame.height/2
        imgProfileImage.layer.borderWidth = 3
        imgProfileImage.clipsToBounds = true
    }
    
    
    func loadDescription(_ thisUser: CurrentUser)
    {
        let AC = AppController()
        
        lblPatientName.text = thisUser.name
     
        let userProfileImgURLstr = thisUser.profileImageURL
        
        let userProfileImgURL = URL(string: userProfileImgURLstr)
            
        URLSession.shared.dataTask(with: userProfileImgURL!, completionHandler: {
                
        (data, response, error) in
                
        if error != nil
        {
            print(error!)
            return
        }
        
        DispatchQueue.main.async
        {
        self.imgProfileImage.image = UIImage(data: data!)
        }
                
        }).resume()
        
        
        //load total hospitals
        
        //load total doctors
        AC.getTotalDoctor {
            (TotalDoctor) in
            self.lblTotalDoctors.text = String(TotalDoctor) + " doctors"
        }
        
        //load total appointments
        
        //load total records
        
    }
    
    
}
