//  ViewNewKey.swift
//  Redis
//
//  Created by Geovane Ferreira on 03/06/2018.
//  Copyright © 2018 Geovane Ferreira. All rights reserved.
//

import UIKit
import Foundation

class ViewNewKey: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var listdb: UIPickerView!
    @IBOutlet weak var listKeyType: UIPickerView!
    @IBOutlet weak var txtValue: UITextView!
    @IBOutlet weak var txtKey: UITextField!
    @IBOutlet weak var viewComplexKey: UIView!
    @IBOutlet weak var txtKeyComplex: UITextView!
    @IBOutlet weak var txtValueComplex: UITextView!
    
    @IBOutlet weak var viewSimpleKey: UIView!
    
    let dbs = ["0","1","2","3","4","5","6","7","8","9","10","11","12","13","14","15"]
    let typesKey = ["String","List","Hash"]
    var dbIndex = 0
    var typekeyIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        listdb.tag = 0
        listdb.dataSource = self
        listdb.delegate = self
        listKeyType.tag = 1
        listKeyType.dataSource = self
        listKeyType.delegate = self
        
        self.hideKeyboardWhenTappedAround()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case 0:
            return 16
        default:
            return 3
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag {
        case 0:
            return dbs[row]
        default:
            return typesKey[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView.tag {
        case 0:
            return dbIndex = row
        case 1:
            typekeyIndex = row
            switch typesKey[row] {
                case "String":
                    self.view.bringSubview(toFront: viewSimpleKey)
                    break;
                case "List":
                    self.view.bringSubview(toFront: viewSimpleKey)
                    break;
                case "Hash":
                    self.view.bringSubview(toFront: viewComplexKey)
                    break;
                default:
                    break;
            }
        default:
            return
        }
    }
    
    @IBAction func AddKeyValue(_ sender: Any) {
        UtilsRedis.sharedInstance.addKeyValue(db: Int(dbs[dbIndex])!, typekey: typesKey[typekeyIndex], key: txtKey.text!, value: txtValue.text!, k_key: txtKeyComplex.text!, k_value: txtValueComplex.text!)
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
}
