//
//  UIView+XIB.swift
//  Memorize
//
//  Created by Fengxiang Xing on 2/9/16.
//  Copyright © 2016 Fengxiang Xing. All rights reserved.
//

import Foundation


extension UIView {
    class func fromNib<T : UIView>(nibNameOrNil: String? = nil) -> T {
        let v: T? = fromNib(nibNameOrNil)
        return v!
    }
    
    class func fromNib<T : UIView>(nibNameOrNil: String? = nil) -> T? {
        var view: T?
        let name: String
        if let nibName = nibNameOrNil {
            name = nibName
        } else {
            // Most nibs are demangled by practice, if not, just declare string explicitly
            name = "\(T.self)".componentsSeparatedByString(".").last!
        }
        let nibViews = NSBundle.mainBundle().loadNibNamed(name, owner: self, options: nil)
        for v in nibViews {
            if let tog = v as? T {
                view = tog
            }
        }
        return view
    }
}