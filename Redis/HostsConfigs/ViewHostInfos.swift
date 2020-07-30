//
//  ViewHostInfos.swift
//  Redis Cli Management
//
//  Created by Geovane Ferreira on 07/07/20.
//  Copyright © 2020 Geovane Ferreira. All rights reserved.
//

import Foundation
import UIKit

class ViewHostInfos: UIViewController {
    @IBOutlet weak var txtInfos: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        txtInfos.text = ""
        loadInfoServer()
    }
    
    func loadInfoServer(){
        let redis = Redis()
        
        redis.connect(host: Configs.sharedInstance.hostselect.host, port: Configs.sharedInstance.hostselect.port)  { (redisError: NSError?) in
          if let error = redisError {
              print(error)
              let alert1 = UIAlertController(title: "", message: "Failed to connect to Redis server", preferredStyle: .alert)
              alert1.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) -> Void in }))
              self.present(alert1, animated: true, completion: nil)
          }
          else {
              redis.info(callback: {(info: RedisString?, redisError: NSError?) in
                txtInfos.text = info?.asString
              });
          }
      }
    }
}
