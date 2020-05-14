//
//  CustomTextField.swift
//  DrDomain
//
//  Created by TestUser on 08/05/2020.
//  Copyright © 2020 TestUser. All rights reserved.
//

import Foundation
import UIKit

class CustomTextField: UITextField
{
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        setupTextField()
    }
    
    required init?(coder aDecorder: NSCoder)
    {
        super.init(coder: aDecorder)
    }
    
    func setupTextField()
    {
        setShadow()

        layer.cornerRadius = 25
        layer.borderWidth = 3.0
        layer.borderColor = UIColor.darkGray.cgColor
    }
    
    //set button shadow
    private func setShadow()
    {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        layer.shadowRadius = 3
        layer.shadowOpacity = 0.3
        clipsToBounds = true
        layer.masksToBounds = false
    }
    
}
