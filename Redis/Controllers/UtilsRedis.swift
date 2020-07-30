//
//  UtilsRedis.swift
//  Redis Cli Management
//
//  Created by Geovane Ferreira on 07/07/20.
//  Copyright © 2020 Geovane Ferreira. All rights reserved.
//

import Foundation
import UIKit

class UtilsRedis: UIViewController {
    
    static let sharedInstance = UtilsRedis()

    func addKeyValue(db: Int, typekey: String, key: String, value: String, k_key: String, k_value: String){
        let redis = Redis()
    
        redis.connect(host: Configs.sharedInstance.hostselect.host, port: Configs.sharedInstance.hostselect.port)  { (redisError: NSError?) in
            if let error = redisError {
                print(error)
            }
            else {
                redis.select(db, callback: { (redisError: NSError?) in
                    switch typekey.lowercased() {
                    case "string":
                        redis.set(key, value: value) { (result: Bool, redisError: NSError?) in
                            if redisError != nil {
                                let alert1 = UIAlertController(title: "", message: "Error connecting to redis", preferredStyle: .alert)
                                alert1.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) -> Void in }))
                                self.present(alert1, animated: true, completion: nil)
                            }
                        }
                        break;
                    case "list":
                       redis.lpush(key, values: value) {(numberSet: Int?, error: NSError?) in
                            if redisError != nil {
                                let alert1 = UIAlertController(title: "", message: "Error connecting to redis", preferredStyle: .alert)
                                alert1.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) -> Void in }))
                                self.present(alert1, animated: true, completion: nil)
                            }
                        }
                        break;
                    case "hash":
                        redis.hset(key, field: k_key, value: k_value){ (newField: Bool, error: NSError?) in
                            if redisError != nil {
                                let alert1 = UIAlertController(title: "", message: "Error connecting to redis", preferredStyle: .alert)
                                alert1.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) -> Void in }))
                                self.present(alert1, animated: true, completion: nil)
                            }
                        }
                        break;
                    default:
                        break;
                    }
                })
            }
        }
    }

}
