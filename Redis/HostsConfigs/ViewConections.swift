//
//  ViewConections.swift
//  Redis
//
//  Created by Geovane Ferreira on 02/06/2018.
//  Copyright © 2018 Geovane Ferreira. All rights reserved.
//

import Foundation
import UIKit

class ViewConections: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableConnections: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableConnections.dataSource = self
        tableConnections.delegate = self
        tableConnections.backgroundColor = ViewsColor.sharedInstance.getcolor(type: "fundo1")
        tableConnections.separatorColor = ViewsColor.sharedInstance.getcolor(type: "separador")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Configs.sharedInstance.hostslist.count
    }
    
    @IBAction func newHost(_ sender: Any) {
         self.performSegue(withIdentifier: "segueNewHost", sender: self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        DispatchQueue.main.async{
            self.tableConnections.reloadData();
        }
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Notification Cell", for: indexPath)
        cell.textLabel?.text = Configs.sharedInstance.hostslist[indexPath.row].name
        cell.textLabel?.font = UIFont.systemFont(ofSize: 15.0)
        cell.detailTextLabel?.text = Configs.sharedInstance.hostslist[indexPath.row].host
        cell.detailTextLabel?.numberOfLines = 2
        cell.backgroundColor = ViewsColor.sharedInstance.getcolor(type: "fundo1")
        cell.textLabel!.textColor = ViewsColor.sharedInstance.getcolor(type: "text1")
        cell.detailTextLabel?.textColor = ViewsColor.sharedInstance.getcolor(type: "text2")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Configs.sharedInstance.hostselect = Configs.sharedInstance.hostslist[indexPath.row]
        self.performSegue(withIdentifier: "segueKeys", sender: self)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let contextItem = UIContextualAction(style: .destructive, title: "Delete") {  (contextualAction, view, boolValue) in
            Configs.sharedInstance.del(index: indexPath[1])
            DispatchQueue.main.async{
                self.tableConnections.reloadData();
            }
        }
        let swipeActions = UISwipeActionsConfiguration(actions: [contextItem])

        return swipeActions
    }
}

