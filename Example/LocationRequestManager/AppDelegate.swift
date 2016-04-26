//
//  AppDelegate.swift
//  LocationRequestManager
//
//  Created by Juan Cruz Ghigliani on 04/25/2016.
//  Copyright (c) 2016 Juan Cruz Ghigliani. All rights reserved.
//

import UIKit
import CoreLocation
import LocationRequestManager

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    let locationRequestManager: LocationRequestManager = LocationRequestManager()
    var basicRequest:LocationRequest?
    var timeoutRequest:LocationRequest?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        
        self.basicRequest = LocationRequest{(currentLocation:CLLocation?,error: NSError?)->Void in
            print("\(self.basicRequest!.status) - \(currentLocation) - \(error)")
        }
        
        self.timeoutRequest = LocationRequest{(currentLocation:CLLocation?,error: NSError?)->Void in
            print("\(self.timeoutRequest!.status) - \(currentLocation) - \(error)")
        }

        self.timeoutRequest!.desiredAccuracy = 0
        self.timeoutRequest!.timeout = 10

        locationRequestManager.performRequest(self.basicRequest!)
        
        locationRequestManager.performRequest(self.timeoutRequest!)

        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

