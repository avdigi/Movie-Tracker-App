//
//  FirstViewController.swift
//  MovieApp
//
//  Created by Anthony DiGiovanni on 11/29/18.
//  Copyright © 2018 Anthony DiGiovanni. All rights reserved.
//

import UIKit

class FirstViewController: UITableViewController {
    
    var tableArray = [String] ()
    var tableImgArray = [String] ()
    var tableDescArray = [String] ()
    var tableYearArray = [String] ()
    var tableIdArray = [String] ()
    
    var moviePage = 1;
    let defaultURL = "https://api.themoviedb.org/3/discover/movie?api_key=bddb4ea29ff40e0a867542ed691d361f&language=en-US&sort_by=popularity.desc&page=1"
    let imageUrl = "https://image.tmdb.org/t/p/w500"

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        
        let firstUrl = defaultURL + "&page=1"
        parseJSON(jsonURL: firstUrl)
    }
    
    func parseJSON(jsonURL: String) {
        let url = URL(string: jsonURL)
        //populate list with API information
        let task = URLSession.shared.dataTask(with: url!) {(data, response, error) in
            
            guard error == nil else {
                print ("parseJSON: error tripped")
                return
            }
            
            guard let content = data else {
                print("parseJSON: No data recieved")
                return
            }
            
            guard let json = (try? JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers)) as? [String: Any] else {
                print ("parseJSON: Data does not contain JSON")
                return
            }
            
            
            for item in json["results"] as! [Dictionary<String, Any>] {
                let movieTitle = item["title"] as! String
                let movieId = item["id"] as! Int
                let movieDesc = item["overview"] as! String
                let movieYear = item["release_date"] as! String
                
                //movie background doesnt always exist so check for it
                if(self.nullToNil(value: item["backdrop_path"]) == nil){
                    self.tableImgArray.append("null.jpg")
                } else {
                    let movieBackdropExt = item["backdrop_path"] as! String
                    let movieBackdropURL = self.imageUrl + movieBackdropExt
                    self.tableImgArray.append(movieBackdropURL)
                }
                
                
                self.tableArray.append(movieTitle)
                self.tableIdArray.append("\(movieId)")
                self.tableDescArray.append(movieDesc)
                self.tableYearArray.append(movieYear)
            }
            
            print(self.tableArray)
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        task.resume()
    }
    
    func nullToNil(value : Any?) -> Any? {
        if value is NSNull {
            return nil
        } else {
            return value
        }
    }
}

extension FirstViewController {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as UITableViewCell
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
    
    //enables infinite scrolling via lazy loading & pagination
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == tableArray.count{
            moviePage = moviePage + 1
            let moviePageStr = String(moviePage)
            let nextUrl = defaultURL + "&page=" + moviePageStr
            
            parseJSON(jsonURL: nextUrl)
        }
    }
    
}
