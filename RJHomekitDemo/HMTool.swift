//
//  HMTool.swift
//  RJHomekitDemo
//
//  Created by zhoucan on 2016/12/28.
//  Copyright © 2016年 verfing. All rights reserved.
//

import UIKit
import Foundation
import HomeKit

class HMTool: NSObject{

    var  homeManager:HMHomeManager?
    
    func initHomeKit()  {
        
        homeManager = HMHomeManager.init()
        homeManager?.delegate = self
    }
    
    
    func addHome(homeName:String)  {
        
        homeManager?.addHome(withName: homeName, completionHandler: { (home, error) in
            
            print(home ?? "addHome-home")
            print(error ?? "addHome-error")
        })
        
    }
    
    
    func removeHome(home:HMHome)  {
        
        homeManager?.removeHome(home, completionHandler: { (error) in
            
            print(error ?? "removeHome-error")
        })
        
    }
    
}


extension HMTool:HMHomeManagerDelegate{

    func homeManagerDidUpdateHomes(_ manager: HMHomeManager) {
        
        //所有的home
        print(manager.homes)
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "getAllHomes"), object: nil)
        
        
    }
    
    func homeManager(_ manager: HMHomeManager, didAdd home: HMHome) {
        
        
       print("成功添加了" + home.name)
        
    }
    
    func homeManagerDidUpdatePrimaryHome(_ manager: HMHomeManager) {
       
        print( "primary home 更新了")
        
    }
    
    func homeManager(_ manager: HMHomeManager, didRemove home: HMHome) {
        
        print("移除了" + home.name)
    }
    
    
}
