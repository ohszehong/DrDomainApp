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
    
    //get the user info from previous view controller
    var userInfoDict: NSMutableDictionary = [:]
    var userSocialPlatform: Array<String> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadDescription()
        //set delegate for collection view
        self.cvSocialPlatform.delegate = self
        self.cvSocialPlatform.dataSource = self

    }
    
    override func viewWillAppear(_ animated: Bool) {
        reloadNameAndPhone()
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
            }
        }
        
        else if segue.identifier == "EditContactNumber"
        {
            if let destinationViewController = segue.destination as? EditInfoPopUpViewController
            {
                destinationViewController.editBoxTitle = "Change Phone Number"
                destinationViewController.editTextplaceholder = "Enter new phone number"
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
