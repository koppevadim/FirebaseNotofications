//
//  AppDelegate.swift
//  FirebaseNotofications
//
//  Created by Vadim Koppe on 28.09.16.
//  Copyright © 2016 Vadim Koppe. All rights reserved.
//

import UIKit
import UserNotifications

import Firebase
import FirebaseMessaging
import FirebaseInstanceID



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, FIRMessagingDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        guard let imageURL = Bundle.main.url(forResource: "1", withExtension: "gif") else {
            return true
        }
        
        let attachment = try! UNNotificationAttachment(identifier: "1", url: imageURL, options: .none)
        
        let content = UNMutableNotificationContent()
        content.categoryIdentifier = "conference"
        content.title = "Новое сообщение! 💩"
        content.subtitle = "Это тестовое сообщение с изображением"
        content.body = "Myownconferne тестовая нотификация с помощью firebase"
        content.attachments = [attachment, attachment]
        
        let request = UNNotificationRequest(
            identifier: "1", content: content, trigger: nil)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: { (error) in
            if let error = error {
                print(error)
            }else{
                print("notification added")
            }
        })
        
        UNUserNotificationCenter.current().delegate = self
        FIRMessaging.messaging().remoteMessageDelegate = self
        
        application.registerForRemoteNotifications()
        
        FIRApp.configure()
        
        FIRMessaging.messaging().connect { (error) in
            if (error != nil) {
                print("Unable to connect with FCM. \(error)")
            } else {
                print("Connected to FCM.")
            }
        }
        
        return true
    }
    
    func applicationReceivedRemoteMessage(_ remoteMessage: FIRMessagingRemoteMessage) {
        print("%@", remoteMessage.appData)
        guard let imageURL = Bundle.main.url(forResource: "myownconference", withExtension: "png") else {
            return
        }
        
        let attachment = try! UNNotificationAttachment(identifier:
            "myownconference", url: imageURL, options: .none)
        
        let content = UNMutableNotificationContent()
        content.categoryIdentifier = "conference"
        content.title = "New notification! 💩"
        content.subtitle = "This is new notification with animated image"
        content.body = "This is new notification with animated image with firebase"
        content.attachments = [attachment]
        
        let request = UNNotificationRequest(
            identifier: "myownconference", content: content, trigger: nil)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: { (error) in
            if let error = error {
                print(error)
            }else{
                print("notification added")
            }
        })
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}



extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        NotificationCenter.default.post(name:NSNotification.Name(rawValue: "com.akovana.FirebaseNotifications"), object: .none)
        completionHandler(.alert)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("Response received for \(response.actionIdentifier)")
        completionHandler()
    }
}

extension AppDelegate {
    @nonobjc func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Registration for remote notifications failed")
        print(error.localizedDescription)
    }
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("Registered with device token: \(deviceToken.hexString)")
    }
}

