//
//  LoginHeaderView.swift
//  FacebookPirata
//
//  Created by Omar Lenin Reyes Alonso on 07/11/16.
//  Copyright © 2016 Omar Lenin Reyes Alonso. All rights reserved.
//

import UIKit

class LoginHeaderView: UIView {

    override func awakeFromNib() {
        layer.shadowColor = shadowColor.cgColor
        layer.shadowOffset = CGSize(width: 5, height: 5)
        layer.shadowOpacity =  1.0
    }

}
