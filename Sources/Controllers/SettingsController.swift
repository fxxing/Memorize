//
//  ViewController.swift
//  Memorize
//
//  Created by Fengxiang Xing on 2/4/16.
//  Copyright © 2016 Fengxiang Xing. All rights reserved.
//

import UIKit

@objc class SettingsController: BaseCotroller {

    @IBAction func back() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func updateLists() {
        let count = DataManager.sharedInstance().importLists()
        self.alert("Imported \(count) word(s)")
    }
    
    @IBAction func deleteLists() {
        DataManager.sharedInstance().deleteLists()
        self.alert("Delete success")
    }
}

