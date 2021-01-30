//
//  UIExtension.swift
//  EatWhatLah
//
//  Created by Apple on 26/1/21.
//

import UIKit

extension UIView {

       public func addShadowToView(shadow_color: UIColor,offset: CGSize,shadow_radius: CGFloat,shadow_opacity: Float,corner_radius: CGFloat) {
           self.layer.shadowColor = shadow_color.cgColor
           self.layer.shadowOpacity = shadow_opacity
           self.layer.shadowOffset = offset
           self.layer.shadowRadius = shadow_radius
           self.layer.cornerRadius = corner_radius
       }
   }
