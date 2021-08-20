//
//  ViewNewHost.swift
//  Redis
//
//  Created by Geovane Ferreira on 08/06/18.
//  Copyright © 2018 Geovane Ferreira. All rights reserved.
//

import UIKit
import Foundation

class ViewNewHost: UIViewController {
    
    @IBOutlet weak var txthost: UITextField!
    @IBOutlet weak var txtPort: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtNameHost: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func btnAdd(_ sender: Any) {
        let hostNew = HostRedis()
        hostNew.host = txthost.text!
        hostNew.name = txtNameHost.text!
        
        if let converted =  Int32(txtPort.text!) {
            hostNew.port = converted
        } else {
            hostNew.port = 6379
        }
        
        hostNew.auth = txtPassword.text!
        Configs.sharedInstance.add(resultado: hostNew)
      
        _ = navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func btnAddExampleHost(_ sender: Any) {
           let hostNew = HostRedis()
           hostNew.host = "tecsuleletronica.com.br"
           hostNew.name = "Example Test Host Redis"
           hostNew.port = 6178
           hostNew.auth = ""
           Configs.sharedInstance.add(resultado: hostNew)
        
            _ = navigationController?.popViewController(animated: true)
       }
    
}
