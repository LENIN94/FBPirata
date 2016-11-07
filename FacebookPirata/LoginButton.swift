//
//  LoginButton.swift
//  FacebookPirata
//
//  Created by Omar Lenin Reyes Alonso on 07/11/16.
//  Copyright © 2016 Omar Lenin Reyes Alonso. All rights reserved.
//

import UIKit

class LoginButton: UIButton {

    
    override func awakeFromNib() {
        
        
        layer.backgroundColor = UIColor(red: 171/255.0, green: 208/255.0, blue: 83/255.0, alpha: 1).cgColor
        layer.cornerRadius = 5
        layer.shadowColor = shadowColor.cgColor
        layer.shadowOffset = CGSize(width: 5, height: 5)
        layer.shadowRadius = 5
        tintColor = UIColor.white
    }

}
