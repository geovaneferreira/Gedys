//
//  ViewKeyValue.swift
//  Redis
//
//  Created by Geovane Ferreira on 02/06/2018.
//  Copyright © 2018 Geovane Ferreira. All rights reserved.
//

import UIKit
import Foundation

class ViewKeyValue: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var txtValeuRedis: UITextView!
    @IBOutlet weak var txtKey: UITextField!
    
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var tableKeys: UITableView!
    
    @IBOutlet weak var viewComplexKey: UIView!
    @IBOutlet weak var viewSimpleKey: UIView!
    @IBOutlet weak var activityStatus: UIActivityIndicatorView!
    
    let redis = Redis()
    
    var keytype: String = ""
    var keyValueList = ["": ""]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        txtKey.text = Configs.sharedInstance.keyselected
        self.activityStatus.hidesWhenStopped = true;
        self.activityStatus.startAnimating();
        DispatchQueue.main.async{
            self.getKeyValueOnRedis();
        }
        //self.activityStatus.stopAnimating();
        self.view.bringSubview(toFront: viewSimpleKey)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return keyValueList.count
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableKeys.dequeueReusableCell(withIdentifier: "Notification Cell", for: indexPath)
        cell.textLabel?.text = Array(keyValueList)[indexPath.row].key
        if(keytype == "hash"){
            cell.detailTextLabel?.text = Array(keyValueList)[indexPath.row].value
            cell.detailTextLabel?.numberOfLines = 2
        } else {
            cell.detailTextLabel?.numberOfLines = 1
            cell.detailTextLabel?.text = ""
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selected = Array(keyValueList)[indexPath.row]
        Configs.sharedInstance.k_key_selected = selected.key
        Configs.sharedInstance.k_value_selected = selected.value
        Configs.sharedInstance.typekey_selected = keytype
        self.performSegue(withIdentifier: "segueEditItem", sender: self)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let contextItem = UIContextualAction(style: .destructive, title: "Delete") {  (contextualAction, view, boolValue) in
            switch self.keytype {
                case "hash": do {
                    self.redis.hdel(self.txtKey.text ?? "", fields: "\(Array(self.keyValueList)[indexPath.row].key)", callback: { (intErr: Int?, redisError: NSError?) in
                        self.view.bringSubview(toFront: self.viewSimpleKey)
                        if let error = redisError {
                            self.txtValeuRedis.text = "Erro na conexao com o redis \(error)"
                        }
                        else {
                            self.getKeyValueOnRedis();
                        }
                    })
                }
                break;
                case "list": do {
                    self.redis.lrem(self.txtKey.text ?? "", count: -1, value: "\(Array(self.keyValueList)[indexPath.row].key)", callback: { (intErr: Int?, redisError: NSError?) in
                            self.view.bringSubview(toFront: self.viewSimpleKey)
                            if let error = redisError {
                                self.txtValeuRedis.text = "Erro na conexao com o redis \(error)"
                            }
                            else {
                                self.getKeyValueOnRedis();
                            }
                        })
                    }
                   break;
                case "set":
                    do {
                        self.redis.srem(self.txtKey.text ?? "", members: "\(Array(self.keyValueList)[indexPath.row].key)", callback: { (intErr: Int?, redisError: NSError?) in
                             self.view.bringSubview(toFront: self.viewSimpleKey)
                             if let error = redisError {
                                 self.txtValeuRedis.text = "Erro na conexao com o redis \(error)"
                             }
                             else {
                                 self.getKeyValueOnRedis();
                             }
                         })
                     }
                   break;
                case "zset": do {
                    self.redis.zrem(self.txtKey.text ?? "", members: "\(Array(self.keyValueList)[indexPath.row].key)", callback: { (intErr: Int?, redisError: NSError?) in
                             self.view.bringSubview(toFront: self.viewSimpleKey)
                             if let error = redisError {
                                 self.txtValeuRedis.text = "Erro na conexao com o redis \(error)"
                             }
                             else {
                                 self.getKeyValueOnRedis();
                             }
                         })
                     }
                   break;
                default:
                   break;
            }
        }
        let swipeActions = UISwipeActionsConfiguration(actions: [contextItem])

        return swipeActions
    }
    
    @IBAction func startEdit(_ sender: Any) {
        txtValeuRedis.isEditable = true
        btnSave.isEnabled = true
        btnEdit.isEnabled = false
    }
    
    @IBAction func save(_ sender: Any) {
        txtValeuRedis.isEditable = false
        btnSave.isEnabled = false
        btnEdit.isEnabled = true
        redis.connect(host: Configs.sharedInstance.hostselect.host, port: Configs.sharedInstance.hostselect.port)  { (redisError: NSError?) in
            if let error = redisError {
                print(error)
            }
            else {
                //print("Connected to Redis")
                redis.set("\(Configs.sharedInstance.keyselected)", value: txtValeuRedis.text!) { (result: Bool, redisError: NSError?) in
                    if redisError != nil {
                        let alert1 = UIAlertController(title: "", message: "Erro na conexao com o redis", preferredStyle: .alert)
                        alert1.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) -> Void in }))
                        self.present(alert1, animated: true, completion: nil)
                    } else {
                        let alert1 = UIAlertController(title: "", message: "Chave atualizada com sucesso.", preferredStyle: .alert)
                        alert1.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) -> Void in }))
                        self.present(alert1, animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    func getKeyValueOnRedis(){
        redis.connect(host: Configs.sharedInstance.hostselect.host, port: Configs.sharedInstance.hostselect.port) { (redisError: NSError?) in
            if redisError != nil {
                //print(error)
                self.activityStatus.stopAnimating();
            }
            else {
                redis.select(Configs.sharedInstance.dbselected, callback: { (redisError: NSError?) in
                    redis.type(key: "\(Configs.sharedInstance.keyselected)") { (valeuKey: String?, redisError: NSError?) in
                        if let error = redisError {
                            txtValeuRedis.text = "Erro na conexao com o redis \(error)"
                        }
                        else {
                            keytype = valeuKey!
                            
                            switch keytype {
                            case "string": do {
                                redis.get("\(Configs.sharedInstance.keyselected)") { (valeuKey: RedisString?, redisError: NSError?) in
                                    self.view.bringSubview(toFront: viewSimpleKey)
                                    if let error = redisError {
                                        txtValeuRedis.text = "Erro na conexao com o redis \(error)"
                                    }
                                    else {
                                        txtValeuRedis.text = valeuKey?.asString
                                    }
                                }
                                break;
                                }
                            case "hash": do {
                                redis.hgetall("\(Configs.sharedInstance.keyselected)") { (rt: [String: RedisString], redisError: NSError?) in
                                    self.view.bringSubview(toFront: viewComplexKey)
                                    if let error = redisError {
                                        txtValeuRedis.text = "Erro ao obter chaves do hash no redis \(error)"
                                    }
                                    else {
                                        keyValueList.removeAll()
                                        for key in rt {
                                            keyValueList["\(key.key)"]="\(key.value)"
                                        }
                                        self.tableKeys.reloadData()
                                        //txtValeuRedis.text = retorno
                                    }
                                }
                                break;
                            }
                            case "list": do {
                                redis.lrange("\(Configs.sharedInstance.keyselected)", start: 0, end: -1) { (rt: [RedisString?]?, redisError: NSError?) in
                                    self.view.bringSubview(toFront: viewComplexKey)
                                    if let error = redisError {
                                        txtValeuRedis.text = "Erro ao obter chaves do list no redis \(error)"
                                    }
                                    else {
                                        keyValueList.removeAll()
                                        rt?.forEach { keyinsed in
                                            keyValueList["\(keyinsed?.asString ?? "")"]=""
                                        }

                                        self.tableKeys.reloadData()
                                        //txtValeuRedis.text = retorno
                                    }
                                }
                                break;
                            }
                            case "set": do {
                                redis.smembers("\(Configs.sharedInstance.keyselected)") { (rt: [RedisString?]?, redisError: NSError?) in
                                    self.view.bringSubview(toFront: viewComplexKey)
                                    if let error = redisError {
                                        txtValeuRedis.text = "Erro ao obter chaves do set no redis \(error)"
                                    }
                                    else {
                                        keyValueList.removeAll()
                                        rt?.forEach { keyinsed in
                                            keyValueList["\(keyinsed?.asString ?? "")"]=""
                                        }

                                        self.tableKeys.reloadData()
                                        //txtValeuRedis.text = retorno
                                    }
                                }
                                break;
                            }
                            case "zset": do {
                                redis.zrange("\(Configs.sharedInstance.keyselected)", start: 0, stop: -1) { (rt: [RedisString?]?, redisError: NSError?) in
                                    self.view.bringSubview(toFront: viewComplexKey)
                                    if let error = redisError {
                                        txtValeuRedis.text = "Erro ao obter chaves do zset no redis \(error)"
                                    }
                                    else {
                                        keyValueList.removeAll()
                                        rt?.forEach { keyinsed in
                                            keyValueList["\(keyinsed?.asString ?? "")"]=""
                                        }

                                        self.tableKeys.reloadData()
                                        //txtValeuRedis.text = retorno
                                    }
                                }
                                break;
                            }
                            default:
                                print("nao implementado \(keytype)")
                                break;
                            }
                        }
                    }
                })
                self.activityStatus.stopAnimating();
            }
        }
    }
}
