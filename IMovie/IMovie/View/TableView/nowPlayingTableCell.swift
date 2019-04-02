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
extension nowPlayingTableCell: UICollectionViewDataSource,UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return films.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "nowPlaying", for: indexPath) as! nowPlayingCell
        
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

