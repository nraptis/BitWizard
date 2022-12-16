//
//  AppDelegate.swift
//  BitWizard
//
//  Created by Nicky Taylor on 12/12/22.
//

import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {
    
    weak var app: ApplicationController?
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        print("applicationDidBecomeActive!!!")
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        print("applicationWillResignActive!!!")
    }
    
    func applicationDidReceiveMemoryWarning(_ application: UIApplication) {
        print("MEMORY WARNING!!!")
        app?.handleMemoryWarning()
    }
    
    func realizeApp(_ app: ApplicationController) {
        self.app = app
    }
    
}
