//
//  SearchViewController.swift
//  IMovie
//
//  Created by liza_kaganskaya on 4/5/19.
//  Copyright © 2019 liza_kaganskaya. All rights reserved.
//

import UIKit
import TMDBSwift

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
   

    @IBOutlet weak var searchTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var films:[MovieMDB] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTableView.delegate = self
        searchTableView.dataSource=self
        searchTableView.reloadData()
        searchBar.delegate = self as UISearchBarDelegate
        searchBarSearchButtonClicked(searchBar)
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let query = searchBar.text ?? ""
        
        SearchMDB.multiSearch(query: query, page: 1, includeAdult: true, language: "eng", region: "US") {
            (client,movieDb, TVDb, personb) in
            self.films = movieDb
            
            DispatchQueue.main.async {
                self.searchTableView.reloadData()
                self.searchBar.text = nil
                self.searchBar.endEditing(true)

            }
         
        }
       
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true) //Hide the keyboard
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return films.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath) as! SearchTableCell
        let film = films[indexPath.row]
        cell.film = film
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 125
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let movie = films[indexPath.row]
        let detailVC = storyboard?.instantiateViewController(withIdentifier: "movieDetail") as? DetailViewController
        detailVC!.movie = movie
        detailVC!.movieID = movie.id
        self.showDetailViewController(detailVC!, sender: self)
    }
}

