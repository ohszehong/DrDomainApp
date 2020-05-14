//
//  CustomButton.swift
//  DrDomain
//
//  Created by TestUser on 08/05/2020.
//  Copyright © 2020 TestUser. All rights reserved.
//

import Foundation
import UIKit

class CustomButton: UIButton
{
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        setupButton()
    }
    
    required init?(coder aDecorder: NSCoder)
    {
        super.init(coder: aDecorder)
        setupButton()
    }
    
    
    func setupButton()
    {
        setShadow()
    
        layer.cornerRadius = 15
        layer.borderWidth = 1.0
        tintColor = UIColor.white
        layer.borderColor = UIColor.lightGray.cgColor
    }
    
    //set button shadow
    private func setShadow()
    {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0.0, height: 4.0)
        layer.shadowRadius = 5
        layer.shadowOpacity = 0.4
        clipsToBounds = true
    }
    
}
