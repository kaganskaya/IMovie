//
//  commingSoonCell.swift
//  IMovie
//
//  Created by liza_kaganskaya on 3/30/19.
//  Copyright © 2019 liza_kaganskaya. All rights reserved.
//

import UIKit
import TMDBSwift

class commingSoonTableCell: UITableViewCell {

    var movies:[MovieMDB] = []

    var cancelRequest: Bool = false

    @IBOutlet weak var upcommingColView: UICollectionView!
    
    override func awakeFromNib() {
        upcommingColView.delegate = self
        upcommingColView.dataSource = self
        getUpcoming()
    }
    private func getUpcoming(onPage page: Int = 1){
        
        guard !cancelRequest else { return }
        
        TMDBConfig.apikey = "63f43d701067d757b85757bdb44a9a26"
        
        MovieMDB.upcoming(page:page, language:"en") {
            (client, movieDB) in
            if client.error == nil {
                
                self.movies = movieDB!
            
                
                
            DispatchQueue.main.async {
                self.upcommingColView.reloadData()
            }
            
            if let pagesTotal = client.pageResults?.total_pages, page < pagesTotal {
                   guard !self.cancelRequest else {
                       print("Cancel request deinied")
                       return
                    }
            }
        
            } else if let _ = client.error,let tryAgain = client.error?.userInfo["Retry-After"] as? Int {
                print("Retry after: \(tryAgain) seconds")
                DispatchQueue.main.async {
                   // self.getUpcoming(onPage: page)
                }
            }else{
                print("Error code: \(String(describing: client.error?.code))")
                print("There was an error: \(String(describing: client.error?.userInfo))")
            }
            }
            
            
        }
}
extension commingSoonTableCell: UICollectionViewDataSource, UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "upcomingCell", for: indexPath) as! commingSonnCell
        
        let movie = movies[indexPath.row]
        
            cell.releaseDateM.text = ("Release Date: " + (movie.release_date!))
            cell.titleN.text = movie.title!
  
        if let posterPath = movie.backdrop_path {
            
                    DispatchQueue.main.async {
                        cell.activity.alpha = 0.0
                        cell.activity.stopAnimating()
                        cell.iamgeView.downloadImageFrom(urlString: posterPath)
                    }
                } else {
            
            cell.activity.alpha = 0.0
            cell.activity.stopAnimating()
        }
        return cell
        
        
    }
    
        
    }
        


