
//
//  AppDelegate.swift
//  Melmel
//
//  Created by Work on 25/03/2016.
//  Copyright © 2016 Melmel. All rights reserved.
//

import UIKit
import UserNotifications
import CoreData
import CoreLocation
import Firebase
import FirebaseMessaging

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,UNUserNotificationCenterDelegate  {
    enum RemoteNotificationLinkType:String{
        case Post = "post"
        case Discount = "discount"
    }

    var window: UIWindow?
    var locationManager:CLLocationManager?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        // Set up managed object context
        
        
        
        
        // Configure Tab bar
        let tabNavCntr = window?.rootViewController as? UITabBarController
        
        for tabBarItem in (tabNavCntr?.tabBar.items)!{
            tabBarItem.image = tabBarItem.image?.withRenderingMode(.alwaysOriginal)
        }
        
        let melGuideNavCntr = tabNavCntr!.viewControllers![0] as? UINavigationController
        let melGuideTableViewCntr = melGuideNavCntr!.viewControllers[0] as? MelGuideTableViewController
        melGuideTableViewCntr!.managedObjectContext = self.managedObjectContext
        
        // Set up location manager
        locationManager = CLLocationManager()
        locationManager?.requestWhenInUseAuthorization()
        //UIApplication.shared.setStatusBarStyle(.lightContent, animated: true)
        
        
        
        
        // Setup init screen
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if !UserDefaults.standard.bool(forKey: "hasSeenIntroduction") {
            let rootCtrl = storyboard.instantiateViewController(withIdentifier: "introductionPageViewCtrl")
            self.window?.rootViewController = rootCtrl
            UserDefaults.standard.set(true, forKey: "hasSeenIntroduction")
        } else {
            let rootCtrl = storyboard.instantiateViewController(withIdentifier: "tabBarCtrl")
            self.window?.rootViewController = rootCtrl
        }
        
        // Configure Firebase Messaging
        FIRApp.configure()
        
        
        // New version of configuring remote notification on iOS 10.0
        if #available(iOS 10.0, *) {
            let authOptions : UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_,_ in })
            
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            // For iOS 10 data message (sent via FCM)
            FIRMessaging.messaging().remoteMessageDelegate = self
            
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.tokenRefreshNotification),
                                               name: .firInstanceIDTokenRefresh,
                                               object: nil)
        
        
        
        // Old version for configuring remote notification
        
//        let settings: UIUserNotificationSettings =
//                            UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
//                        application.registerUserNotificationSettings(settings)
        application.registerForRemoteNotifications()
        
        
        
        return true
    }
    
    

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        FIRMessaging.messaging().disconnect()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        
        // Set application icon badge number to zero
        application.applicationIconBadgeNumber = 0
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    // MARK: - Core Data stack
    
    lazy var applicationDocumentsDirectory: URL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "Melmel.CoreDataExample" in the application's documents Application Support directory.
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1]
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = Bundle.main.url(forResource: "Melmel", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.appendingPathComponent("SingleViewCoreData.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject?
            dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject?
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }
    func tokenRefreshNotification(notification:NSNotification){
        
        let refreshedToken = FIRInstanceID.instanceID().token()
        print("InstanceId token:\(refreshedToken)")
        connectToFirebaseMessaging()
    }
    
    func connectToFirebaseMessaging() {
        
        FIRMessaging.messaging().connect { (error) in
            if error != nil {
                print("Unable to connect \(error)")
            } else {
                print("Connected to Firebase Messaging")
            }
        }
    }

    
    

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        //print(userInfo["url"])
        if let linkType = userInfo["type"] {
            let linkTypeString = linkType as! String
            
            let tabNavCtrl = window?.rootViewController as? UITabBarController
            
            if linkTypeString == "post" {
                tabNavCtrl?.selectedIndex = 0
                let tabNavCtrlNavCtrl = tabNavCtrl?.viewControllers?[0] as! UINavigationController
                let NavRootVC = tabNavCtrlNavCtrl.viewControllers[0] as! MelGuideTableViewController
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let webVC = storyboard.instantiateViewController(withIdentifier: "postWebVC") as! PostWebPageViewController
                webVC.webRequestURLString = userInfo["url"] as? String
                webVC.postid = userInfo["id"] as? String
                webVC.postTitle = userInfo["title"] as? String
                NavRootVC.navigationController?.pushViewController(webVC, animated: true)
                
            } else if linkTypeString == "discount" {
                tabNavCtrl?.selectedIndex = 1
                let tabNavCtrlNavCtrl = tabNavCtrl?.viewControllers?[1] as! UINavigationController
                let NavRootVC = tabNavCtrlNavCtrl.viewControllers[0] as! DiscountTableViewController
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let webVC = storyboard.instantiateViewController(withIdentifier: "webVC") as! DiscountWebViewController
                webVC.webRequestURLString = userInfo["url"] as? String
                webVC.discountTitle = userInfo["title"] as? String
//                webVC.navigationItem.setRightBarButton(nil, animated: true)
                webVC.navigationItem.title = "墨尔本优惠"
                NavRootVC.navigationController?.pushViewController(webVC, animated: true)
            }
            
            
            
            print(linkTypeString)
            
        }
    }

}

extension AppDelegate:FIRMessagingDelegate{
    func applicationReceivedRemoteMessage(_ remoteMessage: FIRMessagingRemoteMessage) {
        print("%@", remoteMessage.appData)
    }
}

