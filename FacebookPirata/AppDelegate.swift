//
//  AppDelegate.swift
//  FacebookPirata
//
//  Created by Omar Lenin Reyes Alonso on 04/11/16.
//  Copyright © 2016 Omar Lenin Reyes Alonso. All rights reserved.
//

import UIKit
import Firebase
import FirebaseInstanceID
import FirebaseMessaging
import FBSDKCoreKit
import UserNotifications
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    open func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(app, open: url, options: options)
    }
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
              /* if #available(iOS 8.0, *){
            let settings: UIUserNotificationSettings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            
            application.registerUserNotificationSettings(settings)
            application.registerForRemoteNotifications()
        }else{
            
            let types: UIRemoteNotificationType = [.alert, .badge, .sound ]
            
            application.registerForRemoteNotifications(matching: types)
            
            
        }*/
        FIRApp.configure()

        connectToFBM()
        
        if #available(iOS 10.0, *){
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(options: authOptions, completionHandler: {_,_ in})
            
            UNUserNotificationCenter.current().delegate = self
            FIRMessaging.messaging().remoteMessageDelegate = self
            
            
            
        }else{
            let settings: UIUserNotificationSettings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
               NotificationCenter.default.addObserver(self, selector: #selector(self.tokenRefreshNotification(notification:)), name: NSNotification.Name.firInstanceIDTokenRefresh, object: nil)
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
    //    FIRMessaging.messaging().disconnect()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    
    //((((((
        FBSDKAppEvents  .activateApp()
    
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    func tokenRefreshNotification(notification: NSNotification){
        let refreshedToken = FIRInstanceID.instanceID().token()
        
        print("Instance token : \(refreshedToken)")
        connectToFBM()
    }
    
    func connectToFBM(){
        FIRMessaging.messaging().connect{
            error in
            
            if error != nil{
                print("no se puede conectar")
            }else{
                print("Conectado a FCM")
            }
        }
    }

  
 

}





@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {
    
    // Receive displayed notifications for iOS 10 devices.
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        // Print message ID.
        print("Message ID: \(userInfo["gcm.message_id"]!)")
        
        // Print full message.
        print("%@", userInfo)
        
        
        let alertController = UIAlertController(title: "PUSH Notification", message: "\(userInfo)", preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "Aceptar", style: .default, handler: nil)
        
        alertController.addAction(alertAction)
        
       
    self.window?.rootViewController?.present(alertController, animated: true, completion: nil)
    
    }
    
}

extension AppDelegate : FIRMessagingDelegate {
    // Receive data message on iOS 10 devices.
    func applicationReceivedRemoteMessage(_ remoteMessage: FIRMessagingRemoteMessage) {
        print("%@", remoteMessage.appData)
        
        
        let ss = remoteMessage.appData as? Dictionary<String,AnyObject>
        
        print("datos iiiiii :     \(ss)   ")
        
        for x in ss! {
            print("posicion:   \(x)")
        }

       
        
       let alertController = UIAlertController(title: "PUSH Notification", message: "\(remoteMessage.appData))", preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "Aceptar", style: .default, handler: nil)
        
        alertController.addAction(alertAction)
        
        
        self.window?.rootViewController?.present(alertController, animated: true, completion: nil)
    }
}




