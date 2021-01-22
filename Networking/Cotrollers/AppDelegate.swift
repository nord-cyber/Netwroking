//
//  AppDelegate.swift
//  Networking
//
//  Created by Alexey Efimov on 25/07/2018.
//  Copyright © 2018 Alexey Efimov. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import Firebase
import GoogleSignIn

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    
    
 func application( _ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? ) -> Bool {
    ApplicationDelegate.shared.application( application, didFinishLaunchingWithOptions: launchOptions )
    
    FirebaseApp.configure()
    GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
    return true
    
 }
    
    func application( _ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:] ) -> Bool {
        ApplicationDelegate.shared.application( app, open: url, sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplication.OpenURLOptionsKey.annotation] )
        
        return GIDSignIn.sharedInstance().handle(url)
    }


    
    
    var window: UIWindow?

    var bgCompletionHandler: (() -> ())?

    func application(_ application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: @escaping () -> Void) {
        bgCompletionHandler = completionHandler
        completionHandler()
    }

}

