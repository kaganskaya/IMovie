//
//  trendinfTableViewCell.swift
//  IMovie
//
//  Created by liza_kaganskaya on 4/3/19.
//  Copyright © 2019 liza_kaganskaya. All rights reserved.
//

import UIKit
import TMDBSwift

class trendinfTableViewCell: UITableViewCell {

    
    @IBOutlet weak var trendingColView: UICollectionView!
    
    var films:[MovieMDB] = []
    var cancelRequest: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        trendingColView.delegate = self
        trendingColView.dataSource = self
        getTrending()
    }
    private func getTrending(onPage page: Int = 1){
        
        guard !cancelRequest else { return }
        
        TMDBConfig.apikey = "63f43d701067d757b85757bdb44a9a26"
        
        MovieMDB.popular(page:page) {
            (client, movieDB) in
            if client.error == nil {
                
                self.films = movieDB!
                
                
                
                DispatchQueue.main.async {
                    self.trendingColView.reloadData()
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
                }
            }else{
                print("Error code: \(String(describing: client.error?.code))")
                print("There was an error: \(String(describing: client.error?.userInfo))")
            }
        }
        
        
    }
    
}
extension trendinfTableViewCell: UICollectionViewDataSource,UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return films.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "trendingCell", for: indexPath) as! trendingCell
        
        let film = films[indexPath.row]
        
        
        if let posterPath = film.backdrop_path {
            
            DispatchQueue.main.async {
                cell.activity.alpha = 0.0
                cell.activity.stopAnimating()
                cell.imageView.downloadImageFrom(urlString: posterPath)
            }
        } else {
            
            cell.activity.alpha = 0.0
            cell.activity.stopAnimating()
        }
        return cell
        
        
    }
    
}
