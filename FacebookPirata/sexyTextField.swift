//
//  sexyTextField.swift
//  FacebookPirata
//
//  Created by Omar Lenin Reyes Alonso on 07/11/16.
//  Copyright © 2016 Omar Lenin Reyes Alonso. All rights reserved.
//

import Foundation
import UIKit
class SexyTextField: UITextField{
    
    
    
    override func awakeFromNib() {
        layer.borderColor = shadowColor.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 25
        
        
       
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 5, dy: 5)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        
        return bounds.insetBy(dx: 5, dy: 5)
    }
}
