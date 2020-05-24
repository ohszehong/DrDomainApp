//
//  ReadOnlySocialPlatformCollectionViewCell.swift
//  DrDomain
//
//  Created by TestUser on 23/05/2020.
//  Copyright © 2020 TestUser. All rights reserved.
//

import UIKit
import SafariServices

class ReadOnlySocialPlatformCollectionViewCell: UICollectionViewCell
{
    @IBOutlet weak var lblSocialMediaLink: UILabel!
    
    
    func setupSocialMediaLinkText(_ linkText: String)
    {
        lblSocialMediaLink.text = linkText
    }
    
    func setupTextTapppedGesture()
    {
        let linkTappedGesture = UITapGestureRecognizer(target: self, action: #selector(handleOpenLink))
        
        self.lblSocialMediaLink.addGestureRecognizer(linkTappedGesture)
        
        self.lblSocialMediaLink.isUserInteractionEnabled = true
    }
    
    @objc func handleOpenLink()
    {
        let urlString = lblSocialMediaLink.text!
        let validUrlString = urlString.hasPrefix("http") ? urlString : "http://\(urlString)"
        let url = URL(string: validUrlString)
        let vc = SFSafariViewController(url: url!)
        ViewControllersLinkers.lookIntoDoctorVC?.present(vc, animated: true, completion: nil)
        
    }
    
}
