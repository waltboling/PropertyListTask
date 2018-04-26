//
//  ViewController.swift
//  PropertyListTask
//
//  Created by Jon Boling on 4/25/18.
//  Copyright © 2018 Walt Boling. All rights reserved.
//

//
//  ViewController.swift
//  PropertyListDemo
//
//  Created by Jon Boling on 4/25/18.
//  Copyright © 2018 Walt Boling. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    
    
    let plistUrl = Bundle.main.url(forResource: "People", withExtension: "plist")
    let fileManager = FileManager.default
    var people: [Dictionary<String, Any>]?
    var file: URL?
    
    func documentsDirectoryFileURL() -> URL? {
        do {
            let document = try fileManager.url(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask, appropriateFor: nil, create: false)
            file = document.appendingPathComponent("People.plist")
            return file
        } catch {
            print("Error getting file path.")
            return nil
        }
    }
    
    func fileExistsInDocumentsDirectory() -> Bool {
        if let file = documentsDirectoryFileURL() {
            let fileExists = FileManager().fileExists(atPath: file.path)
            return fileExists
        }
        
        return false
    }
    
    func seedDataToDocumentsDirectory() {
        do {
            let plistData = try Data(contentsOf: plistUrl!)
            
            if let file = documentsDirectoryFileURL() {
                try plistData.write(to: file)
            }
        } catch {
            print("Error writing file.")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if fileExistsInDocumentsDirectory() == false {
            seedDataToDocumentsDirectory()
        }
        
        var plistFormat = PropertyListSerialization.PropertyListFormat.xml
        
        do {
            let plistData = try Data(contentsOf: documentsDirectoryFileURL()!)
            people = try PropertyListSerialization.propertyList(from: plistData, options: [], format: &plistFormat) as? [Dictionary<String, Any>]
            let plistXML = fileManager.contents(atPath: file!.path)
            people = try PropertyListSerialization.propertyList(from: plistXML!, options: .mutableContainersAndLeaves, format: &plistFormat) as! [Dictionary<String, Any>]
            
            if let people = people {
                for person in people {
                    print("First Name: \(String(describing: person["First Name"])), Last Name: \(String(describing: person["Last Name"])), Age: \(String(describing: person["Age"]))")
                }
                let serializedData = try PropertyListSerialization.data(fromPropertyList: people, format: PropertyListSerialization.PropertyListFormat.xml, options: 0)
                if let file = documentsDirectoryFileURL() {
                    try serializedData.write(to: file)
                    print(file)
                }
            }
        } catch {
            print("Error")
        }
    }
 
    @IBAction func showTblView(_ sender: Any) {
        performSegue(withIdentifier: "toTableView", sender: self)
    }
    
    @IBAction func saveData(_ sender: Any) {
        var plistFormat = PropertyListSerialization.PropertyListFormat.xml
        
        do {
            let plistData = try Data(contentsOf: documentsDirectoryFileURL()!)
            people = try PropertyListSerialization.propertyList(from: plistData, options: [], format: &plistFormat) as? [Dictionary<String, Any>]
            
            if var people = people {
                print("THERE ARE PEOPLE")
                let newPerson = ["First Name" : firstNameField.text as! String, "Last Name" : lastNameField.text as! String] as [String : Any]
                people.append(newPerson)
               
                let serializedData = try PropertyListSerialization.data(fromPropertyList: people, format: PropertyListSerialization.PropertyListFormat.xml, options: 0)
                if let file = documentsDirectoryFileURL() {
                    try serializedData.write(to: file)
                    print(file)
                }
                print(people)
            }
        } catch {
            print("Error")
        }
    }
}



