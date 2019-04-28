//
//  nowPlayingTableCell.swift
//  IMovie
//
//  Created by liza_kaganskaya on 4/3/19.
//  Copyright © 2019 liza_kaganskaya. All rights reserved.
//

import UIKit
import TMDBSwift

class nowPlayingTableCell: UITableViewCell {

    var films:[MovieMDB] = []
    var cancelRequest: Bool = false
    @IBOutlet weak var nowPlayingCollectionView: UICollectionView!
    
    override func awakeFromNib() {
        nowPlayingCollectionView.delegate = self
        nowPlayingCollectionView.dataSource = self
        getNowPlaying()
    }
    private func getNowPlaying(onPage page: Int = 1){
        
        guard !cancelRequest else { return }
        
        TMDBConfig.apikey = "63f43d701067d757b85757bdb44a9a26"
        
        MovieMDB.nowplaying(page:page) {
            (client, movieDB) in
            if client.error == nil {
                
                self.films = movieDB!
                
                
                
                DispatchQueue.main.async {
                    self.nowPlayingCollectionView.reloadData()
                }
                
            }
        }
        
        
    }

}
extension nowPlayingTableCell: UICollectionViewDataSource,UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return films.count
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let mainViewController = parentViewController as? MainViewConroller {
            let movie = films[indexPath.row]
            guard let detailVC = mainViewController.storyboard?.instantiateViewController(withIdentifier: "movieDetail") as? DetailViewController else { return }
            detailVC.movie = movie
            detailVC.movieID = movie.id
            mainViewController.show(detailVC, sender: self)
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "nowPlaying", for: indexPath) as! nowPlayingCell
        
        let film = films[indexPath.row]
        
        
        if let posterPath = film.poster_path {
            
            DispatchQueue.main.async {
                cell.activity.alpha = 0.0
                cell.activity.stopAnimating()
                cell.imageView.downloadImageFrom(urlString: posterPath,posterSize:PosterSizes.ROW_POSTER)
            }
        } else {
            
            cell.activity.alpha = 0.0
            cell.activity.stopAnimating()
        }
        return cell
        
        
    }
    
}

