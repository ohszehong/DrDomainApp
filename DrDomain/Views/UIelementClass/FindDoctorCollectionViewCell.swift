//
//  FindDoctorCollectionViewCell.swift
//  DrDomain
//
//  Created by TestUser on 16/05/2020.
//  Copyright © 2020 TestUser. All rights reserved.
//

import UIKit

class FindDoctorCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var btnLookDoctor: UIButton!
    @IBOutlet weak var lblDoctorName: UILabel!
    @IBOutlet weak var lblDoctorDomain: UILabel!
    @IBOutlet weak var lblDoctorDesc: UILabel!
    @IBOutlet weak var UIViewSideBar: UIView!
    
    let superView = ViewControllersLinkers.searchDoctorResultVC
    
    //variables
    var thisDoctor: Doctor = Doctor()
    
    func setupDoctor(_ doctor: Doctor)
    {
        self.thisDoctor = doctor
        
        lblDoctorName.text = thisDoctor.name
        lblDoctorDomain.text = thisDoctor.domain
        
    }
    
    func setupBorder()
    {
        layer.borderWidth = 1
        layer.borderColor = UIColor.black.cgColor
    }
    
    @IBAction func btnLookDoctor(_ sender: UIButton) {
        
        superView!.selectedDoctor = self.thisDoctor
        superView!.performSegue(withIdentifier: "LookIntoDoctorPage", sender: self)
    }
    
    
    
}
