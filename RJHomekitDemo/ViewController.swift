//
//  ViewController.swift
//  RJHomekitDemo
//
//  Created by zhoucan on 2016/12/28.
//  Copyright © 2016年 verfing. All rights reserved.
//

import UIKit
import HomeKit

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    
    @IBOutlet weak var tableView: UITableView!
    var tool:HMTool?
    var rooms = [HMRoom](){
    
        didSet{
         
            self.tableView.reloadData()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tool = HMTool()
        tool?.initHomeKit()
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.allHomesComplition), name: NSNotification.Name(rawValue: "getAllHomes"), object: nil)
        
        
    }
    
    
    
    //通知
    func allHomesComplition()  {
        
        let homeManager  = tool?.homeManager
        
        guard let homes = homeManager?.homes else {
            return
        }
        
        for home in homes {
            
            if home.isPrimary {
                self.title = home.name
                self.rooms = home.rooms
            }
            
        }
        

        
    }
    @IBAction func addRoomAction(_ sender: Any) {
        
        let alertController = UIAlertController.init(title: "新增room", message: "", preferredStyle: .alert)
        
        alertController.addTextField { (text) in
            
        }
        let cancelAction = UIAlertAction.init(title: "取消", style: .cancel) { (_) in
            
        }
        
        let confirmAction = UIAlertAction.init(title: "确定", style: .default) { (_) in
            
            let text = alertController.textFields?.first?.text
            
            if text?.isEmpty == true {return}
            
            guard let homes = self.tool?.homeManager?.homes else {return}
            
            
            
            for item in homes{
            
               
                if item.name == self.title{
                
                   item.addRoom(withName: text!, completionHandler: { (room, error) in
                
                    if error == nil{
                     
                        self.rooms = item.rooms
                    
                    }
                    
                   })
                
                }
              
            
            }
            
            
            
            
            
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(confirmAction)
        
        present(alertController, animated: true, completion: nil)
        
    }
    

    //Action
    @IBAction func switchHomeAction(_ sender: Any) {
        
        guard let homes = self.tool?.homeManager?.homes else {
            
            return
            
        }
        
        let alertController = UIAlertController.init(title: "切换Home", message: "", preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction.init(title: "取消", style: .cancel) { (_) in
            
        }
        
        
        
        for item in homes{
        
         
            let confirmAction = UIAlertAction.init(title: item.name, style: .default) { (_) in
                
                self.title = item.name
                 self.rooms = item.rooms
            }
            
            alertController.addAction(confirmAction)
        
        }
        
          let confirmAction = UIAlertAction.init(title: "新增Home", style: .default) {[weak self] (_) in
            
            self?.addHome()
            
            
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(confirmAction)
        
        present(alertController, animated: true, completion: nil)

        
    }
    
    
    
    
    func addHome()  {
     
        
        let alertController = UIAlertController.init(title: "新增home", message: "", preferredStyle: .alert)
        
        alertController.addTextField { (textfiels) in
            
        }
        
        let cancelAction = UIAlertAction.init(title: "取消", style: .cancel) { (_) in
            
        }
        
        let confirmAction = UIAlertAction.init(title: "确定", style: .default) { (_) in
            
            let text = alertController.textFields?.first?.text
            
            if text?.isEmpty == true {return}
            
            self.tool?.homeManager?.addHome(withName: text!, completionHandler: { (home, error) in
                print(error ?? "addHome()")
            })
            
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(confirmAction)
        
        present(alertController, animated: true, completion: nil)
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  self.rooms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let identifer = "cell"
        
        var cell = tableView.dequeueReusableCell(withIdentifier: identifer)
        
        if cell == nil {
            cell = UITableViewCell.init(style: .default, reuseIdentifier: identifer)
        }
        cell?.textLabel?.text = rooms[indexPath.row].name
        
        return cell!
    }


}

