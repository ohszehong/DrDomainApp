//
//  SocialPlatformCollectionViewCell.swift
//  DrDomain
//
//  Created by TestUser on 12/05/2020.
//  Copyright © 2020 TestUser. All rights reserved.
//

import UIKit

class SocialPlatformCollectionViewCell: UICollectionViewCell {
    
    //UI elements
    //default cell
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var lblInfoText: UIButton!

    //added cell
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var lblInfoTextStr: UILabel!
    @IBOutlet weak var iconImageForAddedCell: UIImageView!
    
    //variables
    var indexRow: Int = 0
    var parentCollectionView: UICollectionView?
    
    
    func setupCommon(_ iconImageName: String, _ celltype: String)
    {
        if celltype == "addedCell"
        {
            iconImageForAddedCell.image = UIImage(named: iconImageName)
        }
        else if celltype == "defaultCell"
        {
            iconImage.image = UIImage(named: iconImageName)
        }
        
    }
    
    func setupInfoTextStr(_ InfoTextStr: String)
    {
        lblInfoTextStr.text = InfoTextStr
        lblInfoTextStr.sizeToFit()
    }
    
    func setupbtnInfoText(_ InfoTextLink: String)
    {
        lblInfoText.setTitle(InfoTextLink, for: .normal)
    }
    
    @IBAction func addNewLink(_ sender: UIButton) {
        print(123)
    }
    
    func setupIndex(_ indexRow: Int)
    {
        self.indexRow = indexRow
    }

    @IBAction func btnDeleteCell(_ sender: UIButton) {
        
        
        let UC = UserControllers()
        let parentViewController = PatientPersonalInfoViewController()
        
        UC.deleteSocialPlatform(indexRow)
        {
            (socialplatformArray) in
            
            parentViewController.userSocialPlatform = socialplatformArray
            
        }
     
        DispatchQueue.main.async {
            self.parentCollectionView!.reloadData()
        }
        
        print(indexRow)
        
        
    }
    
}
