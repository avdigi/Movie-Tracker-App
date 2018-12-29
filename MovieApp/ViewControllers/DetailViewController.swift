//
//  DetailViewController.swift
//  MovieApp
//
//  Created by Anthony DiGiovanni on 12/15/18.
//  Copyright © 2018 Anthony DiGiovanni. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var movieYearLabel: UILabel!
    @IBOutlet weak var movieDescLabel: UILabel!
    @IBOutlet weak var movieImageView: UIImageView!
    
    var imageUrl = "https://image.tmdb.org/t/p/w500"
    let defaultURL = "https://api.themoviedb.org/3/movie/"
    let defaultAPIEnd = "?api_key=bddb4ea29ff40e0a867542ed691d361f&language=en-US"
    
    var movieId: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //Add button if movieId does not exist in plist
        
        SwiftyPlistManager.shared.start(plistNames: ["Data"], logging: true)
        
        SwiftyPlistManager.shared.getValue(for: movieId, fromPlistWithName: "Data"){ (result,err) in
            if err != nil {
                let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addToPlist))
                self.navigationItem.rightBarButtonItem = addButton
            }
        }
        self.movieDescLabel.sizeToFit()
        let detailUrl = defaultURL + movieId + defaultAPIEnd
        parseJSON(jsonURL: detailUrl)
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
            
            let movieTitle = json["original_title"] as! String
            let movieDesc = json["overview"] as! String
            let movieYear = json["release_date"] as! String
                
            DispatchQueue.main.async {
                if(self.nullToNil(value: json["poster_path"]) == nil){
                } else {
                    let movieBackdropExt = json["poster_path"] as! String
                    let movieBackdropURL = self.imageUrl + movieBackdropExt
                    let imgUrlEncoded = URL(string: movieBackdropURL)
                    self.movieImageView.load(url: imgUrlEncoded!)
                }
                self.movieTitleLabel.text = movieTitle
                self.movieYearLabel.text = movieYear
                self.movieDescLabel.text = movieDesc
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
    
    @objc func addToPlist(){
        let selectedMovieId = self.movieId
        let selectedMovieTitle = self.movieTitleLabel.text!
        let dataPlistName = "Data"
        
        SwiftyPlistManager.shared.start(plistNames: [dataPlistName], logging: true)
        SwiftyPlistManager.shared.addNew(selectedMovieTitle, key: selectedMovieId!, toPlistWithName: dataPlistName){(err) in
            if err == nil {
                print("Added Movie ID: \(selectedMovieId ?? "Unknown") Movie Title: \(selectedMovieTitle) into \(dataPlistName).plist")
            }
        }
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
        self.navigationItem.rightBarButtonItem = nil
    }
}

extension UIImageView {
    func load(url: URL){
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data){
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
