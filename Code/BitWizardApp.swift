//
//  BitWizardApp.swift
//  BitWizard
//
//  Created by Nicky Taylor on 11/27/22.
//

import SwiftUI

@main
struct BitWizardApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    let app = ApplicationController()
    var body: some Scene {
        WindowGroup {
            MainContainerView(mainContainerViewModel: app.mainContainerViewModel)
                .onAppear {
                    appDelegate.realizeApp(app)
                }
                
                .background(Color.black)
                .preferredColorScheme(.dark)
        }
    }
}
