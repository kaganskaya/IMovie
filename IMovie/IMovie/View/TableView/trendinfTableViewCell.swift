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
                cell.imageView.downloadImageFrom(urlString: posterPath,posterSize:PosterSizes.BACK_DROP)
            }
        } else {
            
            cell.activity.alpha = 0.0
            cell.activity.stopAnimating()
        }
        return cell
        
        
    }
    
}
