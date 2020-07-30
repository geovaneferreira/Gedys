//
//  ViewKeys.swift
//  Redis
//
//  Created by Geovane Ferreira on 02/06/2018.
//  Copyright © 2018 Geovane Ferreira. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
     let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
      tap.cancelsTouchesInView = false
      view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
       view.endEditing(true)
    }
}

struct cellData {
    var title = String()
    var opened = Bool()
    var subKeys = [String]()
}

class ViewKeys: UIViewController, UITableViewDataSource, UITableViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var tableKeys: UITableView!
    @IBOutlet weak var navItem: UINavigationItem!
    
    @IBOutlet weak var comboDB: UIPickerView!
    @IBOutlet weak var txtSearchKey: UITextField!
    var listKeys: Dictionary<String, cellData> = [:]
    
    @IBOutlet weak var activityStatus: UIActivityIndicatorView!
    let dbs = ["0","1","2","3","4","5","6","7","8","9","10","11","12","13","14","15"]
    
    var redis = Redis()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        comboDB.dataSource = self
        comboDB.delegate = self
        tableKeys.dataSource = self
        tableKeys.delegate = self
        tableKeys.backgroundColor = ViewsColor.sharedInstance.getcolor(type: "fundo1")
        tableKeys.separatorColor = ViewsColor.sharedInstance.getcolor(type: "separador")
        self.activityStatus.hidesWhenStopped = true;
        self.activityStatus.stopAnimating();
        self.hideKeyboardWhenTappedAround()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return listKeys.count
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 16
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return dbs[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        Configs.sharedInstance.dbselected = row
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(listKeys.count == 0){
            return 1
        }
        
        let vals = Array(listKeys)[section];
        if vals.value.opened == true {
            return vals.value.subKeys.count + 1;
        } else {
            return 1
        }
        //return listKeys.count
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if listKeys.count == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "Notification Cell", for: indexPath)
            return cell
        }
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Notification Cell", for: indexPath)
            let key = Array(listKeys)[indexPath.section].key
                   
            if(key.contains("📁")){
                cell.textLabel?.text = "\(key) ( \(listKeys[key]?.subKeys.count ?? 0) )"
            } else {
                cell.textLabel?.text = key
            }

            cell.backgroundColor = ViewsColor.sharedInstance.getcolor(type: "fundo1")
            cell.textLabel?.textColor = ViewsColor.sharedInstance.getcolor(type: "text1")

            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Notification Cell", for: indexPath)
            let keyVal = Array(listKeys)[indexPath.section].value.subKeys[indexPath.row - 1]
            cell.textLabel?.text = keyVal
            cell.backgroundColor = ViewsColor.sharedInstance.getcolor(type: "fundo1")
            cell.textLabel?.textColor = ViewsColor.sharedInstance.getcolor(type: "text1")
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let dados = Array(listKeys)[indexPath.section]
            if(dados.key.contains("📁 ")){
                if(dados.value.opened == true){
                    listKeys[dados.key]?.opened = false;
                    let sections = IndexSet.init(integer: indexPath.section)
                    tableView.reloadSections(sections, with: .none)
                } else {
                    listKeys[dados.key]?.opened = true;
                    let sections = IndexSet.init(integer: indexPath.section)
                    tableView.reloadSections(sections, with: .none)
                }
            } else {
                Configs.sharedInstance.keyselected = dados.key
                self.performSegue(withIdentifier: "seguedetailkey", sender: self)
            }
        } else {
            let dados = Array(listKeys)[indexPath.section].value.subKeys[indexPath.row - 1]
            Configs.sharedInstance.keyselected = dados
            self.performSegue(withIdentifier: "seguedetailkey", sender: self)
        }
    }
    
    @IBAction func getKeys(_ sender: Any) {
        self.activityStatus.startAnimating();
        DispatchQueue.main.async{
            self.getKeysOnRedis();
        }
    }
    
    @IBAction func addNewKey(_ sender: Any) {
        self.performSegue(withIdentifier: "segueNewKey", sender: self)
    }
    
    
     func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let contextItem = UIContextualAction(style: .destructive, title: "Delete") {  (contextualAction, view, boolValue) in
             self.connectRedis() {(err) in
               if let error = err {
                   print(error)
                   let alert1 = UIAlertController(title: "", message: "Failed to connect to Redis server", preferredStyle: .alert)
                   alert1.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) -> Void in }))
                   self.present(alert1, animated: true, completion: nil)
               }
               else {
                   self.redis.select(Configs.sharedInstance.dbselected, callback: { (redisError: NSError?) in
                       var keyName = ""
                       if(indexPath.row == 0){
                           keyName = Array(self.listKeys)[indexPath.section].key
                       } else {
                           keyName = Array(self.listKeys)[indexPath.section].value.subKeys[indexPath.row - 1]
                       }
                       
                       self.redis.del(keyName, callback: { (deleted: Int?, error: NSError?) in
                           if error != nil {
                               let alert1 = UIAlertController(title: "", message: "Failed to delete key", preferredStyle: .alert)
                               alert1.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) -> Void in }))
                               self.present(alert1, animated: true, completion: nil)
                           }
                           else {
                               //print("Redis Chaves deleted")
                               self.getKeysOnRedis()
                           }
                       })
                   })
               }
           }
        }
        let swipeActions = UISwipeActionsConfiguration(actions: [contextItem])
        return swipeActions
    }
    
    func getKeysOnRedis(){
        navItem.title = ""
        connectRedis() {(err) in
            if let error = err {
                print(error)
                let alert1 = UIAlertController(title: "", message: "Failed to connect to Redis server", preferredStyle: .alert)
                alert1.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) -> Void in }))
                self.present(alert1, animated: true, completion: nil)
                self.activityStatus.stopAnimating();
            }
            else {
                listKeys.removeAll()
                redis.select(Configs.sharedInstance.dbselected, callback: { (redisError: NSError?) in
                    redis.keys(pattern: txtSearchKey.text!) { (keys: [RedisString?]?, redisError2: NSError?) in
                        if redisError != nil {
                            let alert1 = UIAlertController(title: "", message: "Failed to search on Redis server", preferredStyle: .alert)
                            alert1.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) -> Void in }))
                            self.present(alert1, animated: true, completion: nil)
                        }
                        else {
                            if keys?.count == 0 {
                                let alert1 = UIAlertController(title: "", message: "Empty DB.", preferredStyle: .alert)
                                alert1.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) -> Void in }))
                                self.present(alert1, animated: true, completion: nil)
                            }
                            else {
                                navItem.title = "keys: \(keys?.count ?? 0)"
                                for key in keys! {
                                    let stringKey = "\(key?.asString ?? "")"
                                    if(stringKey.contains(":")){
                                        let sp = stringKey.split(separator: ":")[0]
                                        if(listKeys["📁 \(String(sp))"] != nil){
                                            listKeys["📁 \(String(sp))"]?.subKeys.append(stringKey)
                                            continue;
                                        }
                                        
                                        listKeys["📁 \(String(sp))"] = cellData(opened: false, subKeys: [stringKey])
                                        continue;
                                    }
                                    
                                     listKeys[stringKey] = cellData(opened: false, subKeys: [])
                                }
                                
                            }
                            self.tableKeys.reloadData()
                        }
                    }
                })
                self.activityStatus.stopAnimating();
            }
        }
    }
    
    func connectRedis (authenticate: Bool = false, callback: (NSError?) -> Void) {
        if !redis.connected {
            redis.connect(host: Configs.sharedInstance.hostselect.host, port: Configs.sharedInstance.hostselect.port) {(error: NSError?) in
                if authenticate {
                    redis.auth(Configs.sharedInstance.hostselect.auth, callback: callback)
                } else {
                    callback(error)
                }
            }
        } else {
            callback(nil)
        }
    }
    
    @IBAction func viewDBsSize(_ sender: Any) {
        self.performSegue(withIdentifier: "serverInfos", sender: self)
    }
}

