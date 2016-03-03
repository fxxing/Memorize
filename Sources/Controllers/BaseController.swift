//
//  ViewController.swift
//  Memorize
//
//  Created by Fengxiang Xing on 2/4/16.
//  Copyright © 2016 Fengxiang Xing. All rights reserved.
//

import UIKit

@objc class BaseCotroller: UIViewController {

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: NSStringFromClass(self.dynamicType).componentsSeparatedByString(".").last, bundle: NSBundle.mainBundle())
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func alert(msg: String) {
        let alertView = UIAlertView(title: "", message:msg, delegate: nil, cancelButtonTitle: "OK")
        alertView.show()
    }
}
