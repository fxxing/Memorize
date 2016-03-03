//
//  AppDelegate.swift
//  Memorize
//
//  Created by Fengxiang Xing on 2/4/16.
//  Copyright © 2016 Fengxiang Xing. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool { 
        let rootNavigationController = UINavigationController(rootViewController: TaskController())
        rootNavigationController.navigationBarHidden = true
        
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.window!.backgroundColor = UIColor.whiteColor()
        self.window!.rootViewController = rootNavigationController
        self.window!.makeKeyAndVisible()
        
        return true
    }

}

