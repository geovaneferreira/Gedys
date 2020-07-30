//
//  ViewEditValueHashs.swift
//  Redis Cli Management
//
//  Created by Geovane Ferreira on 07/07/20.
//  Copyright © 2020 Geovane Ferreira. All rights reserved.
//

import Foundation
import UIKit

class ViewEditValueHashs: UIViewController{
    
    @IBOutlet weak var lblKey: UITextField!
    @IBOutlet weak var lblTxt: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblKey.text = Configs.sharedInstance.k_key_selected
        lblTxt.text = Configs.sharedInstance.k_value_selected
    }
    
    @IBAction func salvar(_ sender: Any) {
        UtilsRedis.sharedInstance.addKeyValue(db: Configs.sharedInstance.dbselected, typekey: Configs.sharedInstance.typekey_selected, key: Configs.sharedInstance.keyselected, value: "nil", k_key: lblKey.text ?? "", k_value: lblTxt.text ?? "")
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
}
