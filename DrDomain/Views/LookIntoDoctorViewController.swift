//
//  LookIntoDoctorViewController.swift
//  DrDomain
//
//  Created by TestUser on 17/05/2020.
//  Copyright © 2020 TestUser. All rights reserved.
//

import UIKit

class LookIntoDoctorViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{
    
    //variable
    var thisDoctor: Doctor = Doctor()
   
    
    //UI elements
    @IBOutlet weak var imgDoctorProfileImage: UIImageView!
    @IBOutlet weak var lblDoctorName: UILabel!
    @IBOutlet weak var btnMakeCall: UIButton!
    @IBOutlet weak var lblDoctorDomain: UILabel!
    @IBOutlet weak var lblDoctorRating: UILabel!
    @IBOutlet weak var lblTotalReviewers: UILabel!
    @IBOutlet weak var btnBookAppointment:CustomButton!
    
    @IBOutlet weak var UIViewDomainBox: UIView!
    @IBOutlet weak var UIViewWorkingHospitalBox: UIView!
    @IBOutlet weak var UIViewEmailBox: UIView!
    
    @IBOutlet weak var lblDomain: UILabel!
    @IBOutlet weak var lblWorkingHospital: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var cvDoctorEducation: UICollectionView!
    @IBOutlet weak var cvDoctorSocialPlatform: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadDescription()
        
        cvDoctorEducation.delegate = self
        cvDoctorEducation.dataSource = self
        cvDoctorSocialPlatform.delegate = self
        cvDoctorSocialPlatform.dataSource = self
        
        btnBookAppointment.layer.cornerRadius = 0
        
        //setup linker
        ViewControllersLinkers.lookIntoDoctorVC = self
        
        //remove the "none" value in social platform array
        thisDoctor.socialplatform?.removeFirst()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == self.cvDoctorEducation
        {
            return thisDoctor.education!.count
        }
            
       else
        {
            return thisDoctor.socialplatform!.count
        }
       
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.cvDoctorEducation
        {
            var cell: DoctorEducationCollectionViewCell
                   
            cell = cvDoctorEducation.dequeueReusableCell(withReuseIdentifier: "DoctorEducation", for: indexPath) as! DoctorEducationCollectionViewCell
                      
            cell.setupEducationText(thisDoctor.education![indexPath.row])
                   
            return cell
        }
        
        else
        {
            var cell: ReadOnlySocialPlatformCollectionViewCell
            
            cell = cvDoctorSocialPlatform.dequeueReusableCell(withReuseIdentifier: "DoctorSocialPlatform", for: indexPath) as! ReadOnlySocialPlatformCollectionViewCell
            
            cell.setupTextTapppedGesture()
            cell.setupSocialMediaLinkText(thisDoctor.socialplatform![indexPath.row])
            
            return cell
        } 
        
    }
    
    
    @IBAction func btnMakeCall(_ sender: UIButton)
    {
        let url:NSURL = URL(string: "TEL://\(thisDoctor.phone!)")! as NSURL
        UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
    }
    
    
    func loadDescription()
    {
        lblDoctorName.text = thisDoctor.name
        lblDoctorDomain.text = thisDoctor.domain
        
        imgDoctorProfileImage.layer.cornerRadius = imgDoctorProfileImage.frame.height/2
        imgDoctorProfileImage.layer.borderWidth = 3
        imgDoctorProfileImage.clipsToBounds = true
        
        //get working hospital
        let locationDict = thisDoctor.location
        var workingLocation = ""
        
        locationDict?.forEach({ (key, value) in
            workingLocation = value as! String
        })
        
        lblDomain.text = thisDoctor.domain
        lblWorkingHospital.text = workingLocation
        lblEmail.text = thisDoctor.email
        
        let doctorProfileImgURLstr = thisDoctor.profileImgURL
               
        let doctorProfileImgURL = URL(string: doctorProfileImgURLstr!)
                   
        URLSession.shared.dataTask(with: doctorProfileImgURL!, completionHandler: {
                       
        (data, response, error) in
                       
        if error != nil
        {
            print(error!)
            return
        }
               
        DispatchQueue.main.async
        {
        self.imgDoctorProfileImage.image = UIImage(data: data!)
        }
                       
        }).resume()
        
        
        if thisDoctor.totalPeopleRated == 0
        {
            
            lblDoctorRating.text = "N/A"
            lblTotalReviewers.text = "0 reviewers"
            
        }
            
        else
        {
            let doctorRating = thisDoctor.totalRating!/Double(thisDoctor.totalPeopleRated!)
            
            //round up to 1 decimal place
            let roundedRating = doctorRating.roundTo(places: 1)
            
            lblDoctorRating.text = String(roundedRating)
            
            let totalPeopleRated = String(thisDoctor.totalPeopleRated!)
            
            lblTotalReviewers.text = "(\(totalPeopleRated) reviewers)"
        }
        
        
        //set button disabled if doctor not accepting any appointment
        if !thisDoctor.acceptAppoint!
        {
            btnBookAppointment.isEnabled = false
            btnBookAppointment.backgroundColor = UIColor.systemRed
            btnBookAppointment.setTitle("Not Available", for: .normal)
        }
        
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationViewController = segue.destination as! SelectAppointmentDateViewController
        
        if segue.identifier == "SelectDateTimePage"
        {
            destinationViewController.thisDoctor = self.thisDoctor
        }
        
    }
    
    
    
    
}





extension Double {
    
    func roundTo(places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
    
}
