//
//  DoctorInfoCollectionViewCell.swift
//  DrDomain
//
//  Created by TestUser on 17/05/2020.
//  Copyright © 2020 TestUser. All rights reserved.
//

import UIKit

class DoctorEducationCollectionViewCell: UICollectionViewCell {
    
    //UI elements
    @IBOutlet weak var lblEducationInPersonalInfo: UILabel!
    @IBOutlet weak var lblEducation: UILabel!
    
    func setupEducationText(_ education: String)
    {
        lblEducation.text = education
    }
    
    func setupEducationTextForPersonalInfo(_ education: String)
    {
        lblEducationInPersonalInfo.text = education
    }
    
}
