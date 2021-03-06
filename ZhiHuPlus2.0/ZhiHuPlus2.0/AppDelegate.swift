//
//  AppDelegate.swift
//  ZhiHuPlus2.0
//
//  Created by Tengfei on 16/2/28.
//  Copyright © 2016年 tengfei. All rights reserved.
//

import UIKit
import MMDrawerController


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var drawer:MMDrawerController?
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        NotificationCenter.default.addObserver(self, selector: #selector(AppDelegate.LunchLoadHadOk(_:)), name: NSNotification.Name(rawValue: LunchLoadNotication), object: nil)
        let launchVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "launchVc") as! LaunchViewController

        
        // Override point for customization after application launch.
        let sd = UIStoryboard.init(name: "Main", bundle: nil)
        let homeVc = sd.instantiateViewController(withIdentifier: "home") as! HomeViewController
        let nav_homeVc = UINavigationController(rootViewController: homeVc)
        let leftVc = sd.instantiateViewController(withIdentifier: "leftSide") as! LeftSideViewController
        
        drawer = MMDrawerController(center: nav_homeVc, leftDrawerViewController: leftVc)
        drawer?.showsShadow = false
        drawer?.maximumLeftDrawerWidth = 200.0
        drawer?.openDrawerGestureModeMask = .all
        drawer?.closeDrawerGestureModeMask = .all
//        drawer?.setDrawerVisualStateBlock({ (drawerController, drawerSide, percentVisible) -> Void in
//            let block:MMDrawerControllerDrawerVisualStateBlock
//            block =
//        })
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = UIColor.white
        window?.rootViewController = launchVC//drawer!
        window?.makeKeyAndVisible()
        return true
    }
    
    
    // MARK: - Action
    func LunchLoadHadOk(_ noti: Notification) {
        window?.rootViewController = drawer!
        window!.makeKeyAndVisible()
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

