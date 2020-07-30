//
//  ViewExportImport.swift
//  Redis
//
//  Created by Geovane Ferreira on 29/06/20.
//  Copyright © 2020 Geovane Ferreira. All rights reserved.
//

import Foundation
import UIKit
import MobileCoreServices

class ViewExportImport: UIViewController, UIDocumentPickerDelegate {

    @IBOutlet weak var txtImportHosts: UITextView!
    @IBOutlet weak var btnImport: UIBarButtonItem!
    
    override func viewDidLoad() {
       super.viewDidLoad()
       txtImportHosts.text = Configs.sharedInstance.exportJson()
    }
       
   override func didReceiveMemoryWarning() {
       super.didReceiveMemoryWarning()
       // Dispose of any resources that can be recreated.
   }
    
    @IBAction func ImportHosts(_ sender: Any) {
        if(!txtImportHosts.text.isEmpty){
            
          let alert = UIAlertController(title: "Hosts Connections", message: "Do you want to replace all hosts?", preferredStyle: .alert)
          alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
                switch action.style{
                case .default:
                    Configs.sharedInstance.impotJson(jsoninput: self.txtImportHosts.text)
//                    let alert2 = UIAlertController(title: "Hosts Connections", message: "Saved", preferredStyle: UIAlertController.Style.alert)
//                    alert2.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
//                    self.present(alert2, animated: true, completion: nil)
//                    self.txtImportHosts.text = Configs.sharedInstance.exportJson()
//                    print("default")
                
                case .cancel:
                      print("cancel")

                case .destructive:
                      print("destructive")


          }}))
          alert.addAction(UIAlertAction(title: "No", style: .default, handler: nil))
          self.present(alert, animated: true, completion: nil)
            
        } else {
           let alert = UIAlertController(title: "Hosts", message: "Empty Json input.", preferredStyle: UIAlertController.Style.alert)
           alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
           self.present(alert, animated: true, completion: nil)
        }
    }
    @IBAction func export(_ sender: Any) {
        let activity = UIActivityViewController(
          activityItems: [Configs.sharedInstance.path!],
          applicationActivities: nil
        )
        activity.popoverPresentationController?.barButtonItem = sender as? UIBarButtonItem

        // 3
        present(activity, animated: true, completion: nil)
    }
    @IBAction func importFile(_ sender: Any) {
        let documentPicker = UIDocumentPickerViewController(documentTypes: [kUTTypePlainText as String], in: .import)
               documentPicker.delegate = self
               documentPicker.allowsMultipleSelection = false
               present(documentPicker, animated: true, completion: nil)
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        
        guard let selectedFileURL = urls.first else {
            return
        }
        
        let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let sandboxFileURL = dir.appendingPathComponent(selectedFileURL.lastPathComponent)
        
        if FileManager.default.fileExists(atPath: sandboxFileURL.path) {
            print("Deletando Arquivo antigo")
            do {
                try FileManager.default.removeItem(at: sandboxFileURL)
            } catch {
                print("Error: \(error)")
                return
            }
        }
        do {
            try FileManager.default.copyItem(at: selectedFileURL, to: sandboxFileURL)
            print("Copied file!")
            Configs.sharedInstance.load()
            txtImportHosts.text = Configs.sharedInstance.exportJson()
//            let alert2 = UIAlertController(title: "Hosts Connections", message: "Saved", preferredStyle: UIAlertController.Style.alert)
//            alert2.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        }
        catch {
            print("Error: \(error)")
        }
    }
}

