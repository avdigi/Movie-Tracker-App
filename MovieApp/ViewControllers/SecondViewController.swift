//
//  SecondViewController.swift
//  MovieApp
//
//  Created by Anthony DiGiovanni on 11/29/18.
//  Copyright © 2018 Anthony DiGiovanni. All rights reserved.
//

import UIKit

class SecondViewController: UITableViewController {

    let movieTitle: String = ""
    let movieId: String = ""
    var tableArray = [String] ()
    var tableIdArray = [String] ()
    
    @IBOutlet var myTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        SwiftyPlistManager.shared.start(plistNames: ["Data"], logging: true)
        myTable.delegate = self
        myTable.dataSource = self
        NotificationCenter.default.addObserver(self, selector: #selector(populateList), name: NSNotification.Name(rawValue: "load"), object: nil)
        
        self.populateList()
    }
    
    @objc func populateList(){
        let plistFile = "Data.plist"
        let directories = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
        let sourcePath = directories.appendingPathComponent(plistFile)
        let dictionary = NSDictionary(contentsOfFile: sourcePath as String)
        tableArray = [String]()
        tableIdArray = [String]()
        
        for (key, value) in dictionary! {
            tableArray.append(value as! String)
            tableIdArray.append(key as! String)
        }
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

extension SecondViewController {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell", for: indexPath) as UITableViewCell
        
        
        cell.textLabel?.text = self.tableArray[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableArray.count
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let indexPath = tableView.indexPathForSelectedRow
        let index = indexPath?.row
        let selectedId = tableIdArray[index ?? 0]
        
        let detailViewController = segue.destination as! DetailViewController
        
        detailViewController.movieId = selectedId;
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete){
            
            let selectedId = tableIdArray[indexPath.row]
            SwiftyPlistManager.shared.removeKeyValuePair(for: selectedId, fromPlistWithName: "Data") { (err) in
                if err == nil {
                    print("Removed Movie at ID: \(selectedId)")
                }
            }
            populateList()
        }
    }
}
