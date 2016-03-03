//
//  UIView+XIB.swift
//  Memorize
//
//  Created by Fengxiang Xing on 2/9/16.
//  Copyright © 2016 Fengxiang Xing. All rights reserved.
//

import Foundation


extension UIColor {
    class func fromHex(hex: Int) -> UIColor {
        return UIColor(red: CGFloat((hex & 0xff0000) >> 16) / 256, green: CGFloat((hex & 0xff00) >> 8) / 256, blue: CGFloat(hex & 0xff) / 256, alpha: 1)
    }
}