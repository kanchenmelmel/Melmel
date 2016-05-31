//
//  ReachabilityManager.swift
//  Melmel
//
//  Created by Work on 30/05/2016.
//  Copyright © 2016 Melmel. All rights reserved.
//

import Foundation
import SystemConfiguration



class ReachabilityManager {
    static var sharedReachabilityManager = ReachabilityManager()
    
    
    
    var reachability:Reachability?
    let reachabilityChangedNotification = "ReachabilityChangedNotification"
    
    init(){
        do {
            reachability = try Reachability.reachabilityForInternetConnection()
        } catch {
            return
        }
        
       // NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.reachabilityChanged(_:)), name: reachabilityChangedNotification, object: reachability)
        
    }
    
    func isReachable() -> Bool {
        return (reachability?.isReachable())!
    }
    
    func isReachableViaWiFi() -> Bool {
        return (reachability?.isReachableViaWiFi())!
    }
    
    func isReachableViaWWAN() -> Bool {
        return (reachability?.isReachableViaWWAN())!
    }
    
    
    
    
//    @objc func reachabilityChanged(note:NSNotification){
//        let reachability = note.object as! Reachability
//        
//        if reachability.isReachable(){
//            if reachability.isReachableViaWiFi(){
//                networkStatus = .isReachableViaWiFi
//            }else {
//                networkStatus = .isReachableViaWWAN
//            }
//            
//        } else {
//            networkStatus = .notReachable
//        }
//    }
    
}