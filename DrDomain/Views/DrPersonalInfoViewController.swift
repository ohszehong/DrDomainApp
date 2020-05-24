//
//  DrPersonalInfoViewController.swift
//  DrDomain
//
//  Created by TestUser on 22/05/2020.
//  Copyright © 2020 TestUser. All rights reserved.
//

import UIKit

class DrPersonalInfoViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    
    //get the user info from previous view controller
    var doctorInfoDict: NSMutableDictionary = [:]
    var doctorSocialPlatform: Array<String> = []
    var doctorEducation: Array<String> = []
    
    //UI elements
    @IBOutlet weak var lblGender: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblContactNumber: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var cvSocialPlatform: UICollectionView!
    @IBOutlet weak var scrollPersonalInfo: UIScrollView!
    @IBOutlet weak var UIViewPhoneInfoBox: UIView!
    @IBOutlet weak var UIViewUserInfoBox: UIView!
    @IBOutlet weak var UIViewEmailInfoBox: UIView!
    @IBOutlet weak var cvDoctorEducation: UICollectionView!
    
     override func viewDidLoad() {
            super.viewDidLoad()
            
            loadDescription()
            //set delegate for collection view
            self.cvSocialPlatform.delegate = self
            self.cvSocialPlatform.dataSource = self
        self.cvDoctorEducation.delegate = self
        self.cvDoctorEducation.dataSource = self
            
            //set the linker
        ViewControllersLinkers.doctorInfoVC = self
        
       
           
        }
        
        override func viewWillAppear(_ animated: Bool) {
            reloadNameAndPhone()
            loadDescription()
        }
        
        func reloadCollectionView()
        {
            let indexSet = IndexSet(integer: 0)
        
            cvSocialPlatform.performBatchUpdates({
                cvSocialPlatform.reloadSections(indexSet)
            }, completion: nil)
        }
       
        
        func reloadNameAndPhone()
        {
            //reload name and phone
            let DC = DoctorController()
            DC.getCurrentDoctorInfoSet(completion: { (doctor) in
                self.doctorInfoDict["name"] = doctor.name
                self.doctorInfoDict["phone"] = doctor.phone
            })
        }
        
        func loadDescription()
        {
            lblGender.text = doctorInfoDict["gender"] as? String
            lblName.text = doctorInfoDict["name"] as? String
            lblContactNumber.text = doctorInfoDict["phone"] as? String
            lblEmail.text = doctorInfoDict["email"] as? String
            
        }
        
        func setupInfoBoxBorder()
        {
            UIViewUserInfoBox.layer.borderWidth = 1
            UIViewUserInfoBox.layer.borderColor = UIColor.black.cgColor
            UIViewUserInfoBox.layer.shadowColor = UIColor.black.cgColor
            UIViewUserInfoBox.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
            UIViewUserInfoBox.layer.shadowRadius = 5
            UIViewUserInfoBox.layer.shadowOpacity = 0.4
            UIViewUserInfoBox.clipsToBounds = true
            
            UIViewPhoneInfoBox.layer.borderWidth = 1
            UIViewPhoneInfoBox.layer.borderColor = UIColor.black.cgColor
            UIViewPhoneInfoBox.layer.shadowColor = UIColor.black.cgColor
            UIViewPhoneInfoBox.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
            UIViewPhoneInfoBox.layer.shadowRadius = 5
            UIViewPhoneInfoBox.layer.shadowOpacity = 0.4
            UIViewPhoneInfoBox.clipsToBounds = true
            
            UIViewEmailInfoBox.layer.borderWidth = 1
            UIViewEmailInfoBox.layer.borderColor = UIColor.black.cgColor
            UIViewEmailInfoBox.layer.shadowColor = UIColor.black.cgColor
            UIViewEmailInfoBox.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
            UIViewEmailInfoBox.layer.shadowRadius = 5
            UIViewEmailInfoBox.layer.shadowOpacity = 0.4
            UIViewEmailInfoBox.clipsToBounds = true
            
        }
        
        
        //collection view function
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            
            var returnCount = 0
            
            if collectionView == self.cvSocialPlatform
            {
                returnCount = doctorSocialPlatform.count
            }
            
            else if collectionView == self.cvDoctorEducation
            {
                returnCount =  doctorEducation.count
            }
            
            return returnCount
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
            
            if collectionView == self.cvSocialPlatform
            {
            
            //if is first element of array
            if indexPath.row == 0
            {
                let cell = cvSocialPlatform.dequeueReusableCell(withReuseIdentifier: "DefaultCell", for: indexPath) as! SocialPlatformCollectionViewCell
                cell.setupCommon("socialmedialinkgrey", "defaultCell")
                cell.setupbtnInfoText("Add new link")
                cell.parentCollectionView = self.cvSocialPlatform
                
                return cell
            }
            
            else
            {
                let cell = cvSocialPlatform.dequeueReusableCell(withReuseIdentifier: "AddedCell", for: indexPath) as! SocialPlatformCollectionViewCell
                
             
                cell.setupCommon("socialmedialink", "addedCell")
                cell.setupInfoTextStr(doctorSocialPlatform[indexPath.row])
                cell.setupIndex(indexPath.row)
                cell.parentCollectionView = self.cvSocialPlatform
                cell.setupTextTapppedGesture()
                cell.setupUserRole("doctor")
                
                return cell
            }
                
            }
            
            else 
            {
                
                let currentEducation = self.doctorEducation[indexPath.row]
                
                let cell = cvDoctorEducation.dequeueReusableCell(withReuseIdentifier: "DoctorEducation", for: indexPath) as! DoctorEducationCollectionViewCell
                
                cell.setupEducationTextForPersonalInfo(currentEducation)
                
                return cell
            }
  
            
        }
        
        
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            
            if segue.identifier == "EditDoctorName"
            {
                if let destinationViewController = segue.destination as? EditInfoPopUpViewController
                {
                    destinationViewController.editBoxTitle = "Change Name"
                    destinationViewController.editTextplaceholder = "Enter new name"
                    destinationViewController.userRole = "doctor"
                }
            }
            
            else if segue.identifier == "EditDoctorContactNumber"
            {
                if let destinationViewController = segue.destination as? EditInfoPopUpViewController
                {
                    destinationViewController.editBoxTitle = "Change Contact Number"
                    destinationViewController.editTextplaceholder = "Enter new phone number"
                    destinationViewController.userRole = "doctor"
                }
            }
            
            else if segue.identifier == "AddNewLink"
            {
                if let destinationViewController = segue.destination as? AddNewLinkPopUpViewController
                {
                    destinationViewController.userRole = "doctor"
                }
            }
        
        }
        
        @IBAction func btnEditName(_ sender: UIButton) {
            performSegue(withIdentifier: "EditDoctorName", sender: self)
        }
        
        @IBAction func btnEditContactNumber(_ sender: UIButton) {
            performSegue(withIdentifier: "EditDoctorContactNumber", sender: self)
        }
        
}
    
