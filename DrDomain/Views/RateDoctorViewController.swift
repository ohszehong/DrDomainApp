//
//  RateDoctorViewController.swift
//  DrDomain
//
//  Created by TestUser on 23/05/2020.
//  Copyright © 2020 TestUser. All rights reserved.
//

import UIKit
import Cosmos
import TinyConstraints

class RateDoctorViewController: UIViewController {

    //UI elements
    @IBOutlet weak var imgDoctorProfileImg: UIImageView!
    @IBOutlet weak var lblDoctorName: UILabel!
    @IBOutlet weak var lblDoctorDomain: UILabel!
    @IBOutlet weak var UIViewContainer: UIView!
    @IBOutlet weak var imgThankYou: UIImageView!
    @IBOutlet weak var lblThankYou: UILabel!
    
    //variables
    var thisDoctor: Doctor = Doctor()
    let PC = PatientControllers()
    
    //cosmos view
    lazy var cosmosView: CosmosView =
    {
        var starRatingView = CosmosView()
        
        //cosmosView settings
        starRatingView.settings.filledImage = UIImage(named: "filledStar")?.withRenderingMode(.alwaysOriginal)
        
        starRatingView.settings.emptyImage = UIImage(named: "unfilledStar")?.withRenderingMode(.alwaysOriginal)
        
        starRatingView.settings.fillMode = .half
        
        //addGesture
        let starRatingTappedGesture = UITapGestureRecognizer(target: self, action: #selector(handleRateDoctor))
        
        starRatingView.addGestureRecognizer(starRatingTappedGesture)
        starRatingView.isUserInteractionEnabled = true
        
        return starRatingView
    }()
    
    override func viewWillDisappear(_ animated: Bool) {
         self.imgThankYou.isHidden = true
         self.lblThankYou.isHidden = true
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupProfileImgView()
        loadDescription()
        
        UIViewContainer.addSubview(cosmosView)
        setupCosmosView()
        
        lblThankYou.layer.borderWidth = 1.5
        lblThankYou.layer.borderColor = UIColor.systemGreen.cgColor
        
    }
    
    @objc func handleRateDoctor()
    {
        cosmosView.didTouchCosmos =
        {
         rating in
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                              
                           //delay the dismiss process
                           self.dismiss(animated: true, completion: nil)
                                               
            }
                               
        
           self.PC.rateDoctor(self.thisDoctor.UID!, rating)
            
               
            self.imgThankYou.isHidden = false
            self.lblThankYou.isHidden = false
        
                
        }
    }
 
    
    func setupCosmosView()
    {
        cosmosView.translatesAutoresizingMaskIntoConstraints = false
        let horizontalConstraint = cosmosView.centerXAnchor.constraint(equalTo: UIViewContainer.centerXAnchor)
        
        horizontalConstraint.isActive = true
        
        let verticalConstraint = cosmosView.centerYAnchor.constraint(greaterThanOrEqualTo: UIViewContainer.centerYAnchor,constant: 98)
        
        verticalConstraint.isActive = true
        
        UIViewContainer.addConstraints([horizontalConstraint,verticalConstraint])
    }
    
    
    func loadDescription()
    {
        lblDoctorName.text = thisDoctor.name
        lblDoctorDomain.text = thisDoctor.domain
          
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
            self.imgDoctorProfileImg.image = UIImage(data: data!)
        }
                  
        }).resume()
        
      }
    
    
    func setupProfileImgView()
    {

        imgDoctorProfileImg.layer.cornerRadius =
        imgDoctorProfileImg.frame.height/2
        imgDoctorProfileImg.layer.borderWidth = 2
        imgDoctorProfileImg.layer.borderColor = UIColor.white.cgColor
        imgDoctorProfileImg.clipsToBounds = true
        
    }
    
    @IBAction func btnCancel(_ sender: UIButton)
    {
        dismiss(animated: true, completion: nil)
    }
    
}
