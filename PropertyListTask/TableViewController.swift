//
//  SecondViewController.swift
//  PropertyListTask
//
//  Created by Jon Boling on 4/25/18.
//  Copyright © 2018 Walt Boling. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
    var people = [Dictionary<String, Any>]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let fileManager = FileManager.default
        let path: URL?
        
        do {
            let document = try fileManager.url(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask, appropriateFor: nil, create: false)
            path = document.appendingPathComponent("People.plist")
            people = NSArray(contentsOf: path!) as! [Dictionary<String, Any>]
            print(path)
        } catch {
            print("error")
        }
    }
        
    //tableView controls
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath as IndexPath)
        let person = people[indexPath.row]
        
        cell.textLabel!.text = (person["First Name"] as! String) + " " + (person["Last Name"] as! String)

        return cell
    }

}
