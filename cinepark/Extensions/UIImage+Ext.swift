//
//  UIImage+Ext.swift
//  cinepark
//
//  Created by Abdulsalam Mansour on 6/23/20.
//  Copyright © 2020 abdulsalam. All rights reserved.
//

import UIKit

extension UIImage {
    
    func alpha(_ value:CGFloat) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(at: CGPoint.zero, blendMode: .normal, alpha: value)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
}
