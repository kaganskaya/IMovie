//
//  TVViewControler.swift
//  IMovie
//
//  Created by liza_kaganskaya on 4/4/19.
//  Copyright © 2019 liza_kaganskaya. All rights reserved.
//

import UIKit
import TMDBSwift

class TVViewControler: UIViewController {

    @IBOutlet weak var TVCollectionView: UICollectionView!
    
    var cancelRequest: Bool = false

    
    override func viewDidLoad() {
        super.viewDidLoad()
        TVCollectionView.delegate = self as UICollectionViewDelegate
        TVCollectionView.dataSource = self as UICollectionViewDataSource
        TVCollectionView.reloadData()
        getTvShows()
    }
    
    var tvShows:[TVMDB] = []
   
    func getTvShows(onPage page: Int = 1){
       
        guard !cancelRequest else { return }
        
        TMDBConfig.apikey = "63f43d701067d757b85757bdb44a9a26"
        
        TVMDB.ontheair(page:page, language:"en") {
            (client, TVdb) in
            if client.error == nil {
                
                self.tvShows = TVdb!
                
                
                
                DispatchQueue.main.async {
                    self.TVCollectionView.reloadData()
                }
                
            }
        }
    }
}

extension TVViewControler: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tvShows.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
            let movie = tvShows[indexPath.row]
            guard let detailVC = storyboard?.instantiateViewController(withIdentifier: "movieTVDetail") as? DetailTVViewController else { return }
            detailVC.tv = movie
            detailVC.tvID = movie.id
            self.showDetailViewController(detailVC, sender: self)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let tvCell = collectionView.dequeueReusableCell(withReuseIdentifier: "popularTv", for: indexPath) as! TVCell
        
        let tv = tvShows[indexPath.row]
        
        tvCell.TVName.text = tv.name
        tvCell.AirDate.text = ("Original Air Date: " + (tv.first_air_date!))
        
        if let posterPath = tv.poster_path {
            
            DispatchQueue.main.async {
                tvCell.activity.alpha = 0.0
                tvCell.activity.stopAnimating()
                tvCell.imageView.downloadImageFrom(urlString: posterPath, posterSize:PosterSizes.ORIGINAL_POSTER)
            }
        } else {
            
            tvCell.activity.alpha = 0.0
            tvCell.activity.stopAnimating()
        }
        return tvCell
    }
    
    
    
    
}
