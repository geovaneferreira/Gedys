//
//  UserVehicles.swift
//  Tracker
//
//  Created by Geovane Ferreira on 08/03/17.
//  Copyright © 2017 Geovane Ferreira. All rights reserved.
//

import Foundation

class Configs {
    
    let fileCars = "hosts.txt";
    
    var hostselect:HostRedis = HostRedis()
    
    static let sharedInstance = Configs()
    var hostslist = [HostRedis]()
    var path:URL? = nil
    
    //-------
    var keyselected = ""
    var k_key_selected = ""
    var k_value_selected = ""
    var dbselected = 0
    var typekey_selected = ""
    
    
    init(){
        load()
    }
    
    func load(){
       if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            self.path = dir.appendingPathComponent(fileCars)
            do {
                let reader = try String(contentsOf: self.path!, encoding: String.Encoding.utf8)
                //if(reader.elementsEqual("")){
                if(reader == ""){
                    print("sem hosts em disco")
                    return;
                }
                print(reader)
                let jsonData = Data(reader.utf8)
                let decoder = JSONDecoder()
                do {
                    hostslist = try decoder.decode([HostRedis].self, from: jsonData)
                    print(hostslist)
                } catch {
                    print(error.localizedDescription)
                }

                print("hosts carregados!")
            }
            catch {
                print("erro")
                /* error handling here */
            }
        }
    }
    
    func adds(resultado: [HostRedis]){
           clear()
           //carlist = resultado
           
           let jsonEncoder = JSONEncoder()
           let jsonData = try! jsonEncoder.encode(resultado)
           let json = String(data: jsonData, encoding: String.Encoding.utf8)
           
           if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
               self.path = dir.appendingPathComponent(fileCars)
               do {
                try json?.write(to: self.path!, atomically: false, encoding: String.Encoding.utf8)
               }
               catch {/* error handling here */}
           }
           print("hosts salvos!")
           load()
    }
    
    func add(resultado: HostRedis){
        hostslist.append(resultado)
        adds(resultado: hostslist)
    }
    
    func clear(){
        hostslist.removeAll()
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            self.path = dir.appendingPathComponent(fileCars)
            do {
                try "".write(to: self.path!, atomically: false, encoding: String.Encoding.utf8)
            }
            catch {/* error handling here */}
        }
        print("hosts deletados!")
    }
    
    func del(index: Int){
        hostslist.remove(at: index)
        adds(resultado: hostslist)
    }
    
    func exportJson() -> String{
        let jsonEncoder = JSONEncoder()
       
        jsonEncoder.outputFormatting = .prettyPrinted
        let data = try! jsonEncoder.encode(hostslist)
        
        return String(data: data, encoding: .utf8)!
    }
    
    func impotJson(jsoninput: String) -> String{
        let jsonData = Data(jsoninput.utf8)
        let decoder = JSONDecoder()
        do {
            hostslist = try decoder.decode([HostRedis].self, from: jsonData)
            adds(resultado: hostslist)
            print(hostslist)
            return "ok"
        } catch {
            return "invalid json"
        }
    }
}


// Hosts model
class HostRedis: Codable {
    var auth = ""
    var host = ""
    var keys_pattern = "*"
    var name = ""
    var namespace_separator = ":"
    var port:Int32 = 6379
    var ssh_port:Int32 = 22
    var timeout_connect:Int32 = 60000
    var timeout_execute:Int32 = 60000
}
