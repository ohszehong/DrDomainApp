//
//  PatientPersonalInfoViewController.swift
//  DrDomain
//
//  Created by TestUser on 12/05/2020.
//  Copyright © 2020 TestUser. All rights reserved.
//

import UIKit

class PatientPersonalInfoViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
 
    
    
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
    
    
    //get the user info from previous view controller
    var userInfoDict: NSMutableDictionary = [:]
    var userSocialPlatform: Array<String> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadDescription()
        //set delegate for collection view
        self.cvSocialPlatform.delegate = self
        self.cvSocialPlatform.dataSource = self
        
        //set the linker
        ViewControllersLinkers.patientInfoVC = self
       
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
        let PC = PatientControllers()
        PC.getCurrentUserInfoSet { (User) in
        self.userInfoDict["name"] = User.name
        self.userInfoDict["phone"] = User.phone
        }
    }
    
    func loadDescription()
    {
        lblGender.text = userInfoDict["gender"] as? String
        lblName.text = userInfoDict["name"] as? String
        lblContactNumber.text = userInfoDict["phone"] as? String
        lblEmail.text = userInfoDict["email"] as? String
        
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
        return userSocialPlatform.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var cell: SocialPlatformCollectionViewCell
        
        //if is first element of array
        if indexPath.row == 0
        {
            cell = cvSocialPlatform.dequeueReusableCell(withReuseIdentifier: "DefaultCell", for: indexPath) as! SocialPlatformCollectionViewCell
            
            cell.setupCommon("socialmedialinkgrey", "defaultCell")
            cell.setupbtnInfoText("Add new link")
            cell.parentCollectionView = self.cvSocialPlatform
        }
        
        else
        {
            cell = cvSocialPlatform.dequeueReusableCell(withReuseIdentifier: "AddedCell", for: indexPath) as! SocialPlatformCollectionViewCell
            
         
            cell.setupCommon("socialmedialink", "addedCell")
            cell.setupInfoTextStr(userSocialPlatform[indexPath.row])
            cell.setupIndex(indexPath.row)
            cell.parentCollectionView = self.cvSocialPlatform
            cell.setupTextTapppedGesture()
            cell.setupUserRole("patient")
            
        }
    
        return cell
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "EditName"
        {
            if let destinationViewController = segue.destination as? EditInfoPopUpViewController
            {
                destinationViewController.editBoxTitle = "Change Name"
                destinationViewController.editTextplaceholder = "Enter new name"
                destinationViewController.userRole = "patient"
            }
        }
        
        else if segue.identifier == "EditContactNumber"
        {
            if let destinationViewController = segue.destination as? EditInfoPopUpViewController
            {
                destinationViewController.editBoxTitle = "Change Contact Number"
                destinationViewController.editTextplaceholder = "Enter new phone number"
                destinationViewController.userRole = "patient"
            }
        }
        
        else if segue.identifier == "AddNewLink"
        {
            if let destinationViewController = segue.destination as? AddNewLinkPopUpViewController
            {
                destinationViewController.userRole = "patient"
            }
        }
    
    }
    
    @IBAction func btnEditName(_ sender: UIButton) {
        performSegue(withIdentifier: "EditName", sender: self)
    }
    
    @IBAction func btnEditContactNumber(_ sender: UIButton) {
        performSegue(withIdentifier: "EditContactNumber", sender: self)
    }
    
    
    
    
}


extension String {
    var isValidURL: Bool {
        let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        if let match = detector.firstMatch(in: self, options: [], range: NSRange(location: 0, length: self.utf16.count)) {
            // it is a link, if the match covers the whole string
            return match.range.length == self.utf16.count
        } else {
            return false
        }
    }
}
