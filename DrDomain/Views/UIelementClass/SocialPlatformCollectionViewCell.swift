//
//  SocialPlatformCollectionViewCell.swift
//  DrDomain
//
//  Created by TestUser on 12/05/2020.
//  Copyright © 2020 TestUser. All rights reserved.
//

import UIKit
import SafariServices

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
    var userRole = ""
    
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
    
    func setupUserRole(_ userRole: String)
    {
        self.userRole = userRole
    }
    
    func setupTextTapppedGesture()
    {
        let textTappedGesture = UITapGestureRecognizer(target: self, action: #selector(handleOpenLink))
        
        self.lblInfoTextStr.addGestureRecognizer(textTappedGesture)
        
        self.lblInfoTextStr.isUserInteractionEnabled = true
    }
    
    @objc func handleOpenLink()
    {
        let urlString = lblInfoTextStr.text!
        let validUrlString = urlString.hasPrefix("http") ? urlString : "http://\(urlString)"
        let url = URL(string: validUrlString)
        let vc = SFSafariViewController(url: url!)
        ViewControllersLinkers.patientInfoVC?.present(vc, animated: true, completion: nil)
        
    }
    
    func setupInfoTextStr(_ InfoTextStr: String)
    {
        lblInfoTextStr.text = InfoTextStr
    }
    
    func setupbtnInfoText(_ InfoTextLink: String)
    {
        lblInfoText.setTitle(InfoTextLink, for: .normal)
    }
    
    func setupIndex(_ indexRow: Int)
    {
        self.indexRow = indexRow
    }

    @IBAction func btnDeleteCell(_ sender: UIButton) {
        
        
        let UC = UserControllers()
        
        UC.deleteSocialPlatform(indexRow, userRole)
        {
            (socialplatformArray) in
            
            //use the linker to access to PatientInfoPersonalViewController elements
            ViewControllersLinkers.patientInfoVC?.userSocialPlatform = socialplatformArray
            
            self.parentCollectionView?.performBatchUpdates({
                let indexSet = IndexSet(integer: 0)
                self.parentCollectionView?.reloadSections(indexSet)
            }, completion: nil)

        
    
        }
        
    }
    
}
