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
    
//    var reachableCallback:{() -> Void}
//    var unreachableCallback:() -> Void
    
    init(){
        do {
            reachability = Reachability()
        } catch {
            return
        }
        
       // NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.reachabilityChanged(_:)), name: reachabilityChangedNotification, object: reachability)
    }
    
    func isReachable() -> Bool {
        return (reachability?.isReachable)!
    }
    
    func isReachableViaWiFi() -> Bool {
        return (reachability?.isReachableViaWiFi)!
    }
    
    func isReachableViaWWAN() -> Bool {
        return (reachability?.isReachableViaWWAN)!
    }
    
    func setupReachability(hostname:String?, useClosure:Bool) {
        do {
            let reachability = hostname == nil ? Reachability() : Reachability(hostname: hostname!)
            self.reachability = reachability
        } catch ReachabilityError.FailedToCreateWithAddress(let address) {
            print("Unable to create\nReachability with address:\n\(address)")
            return
        } catch {}
        
        if useClosure {
            reachability?.whenReachable = {(reachability) in
                // Do something when reachable
            }
            reachability?.whenUnreachable = {(reachability) in
                // Do something when unReachable
            }
        } else {
            NotificationCenter.default.addObserver(self, selector: #selector(self.reachabilityChanged(_:)), name: NSNotification.Name(rawValue: reachabilityChangedNotification), object: reachability)
        }
    }
    
    @objc func reachabilityChanged(_ note:Notification) {
        let reachability = note.object as! Reachability
        if reachability.isReachable{
//            reachableCallback()
        } else {
//            unreachableCallback()
        }
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
