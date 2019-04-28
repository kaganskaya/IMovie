//
//  PopularActorsTableCell.swift
//  IMovie
//
//  Created by liza_kaganskaya on 4/3/19.
//  Copyright © 2019 liza_kaganskaya. All rights reserved.
//

import UIKit
import TMDBSwift

class PopularActorsTableCell: UITableViewCell {
    
    var actors:[PersonResults] = []
   
    var cancelRequest: Bool = false
    
    @IBOutlet weak var actorsViewController: UICollectionView!
    
    override func awakeFromNib() {
        actorsViewController.delegate = self as! UICollectionViewDelegate
        actorsViewController.dataSource = self as! UICollectionViewDataSource
        getActors()
    }
    private func getActors(onPage page: Int = 1){
       
        guard !cancelRequest else { return }
        
        TMDBConfig.apikey = "63f43d701067d757b85757bdb44a9a26"
        
        PersonMDB.popular(page:page) {
            (client, actorMDB) in
            if client.error == nil {
                
                self.actors = actorMDB!
                
                
                
                DispatchQueue.main.async {
                    self.actorsViewController.reloadData()
                }
            }
        }
        
        
    }
    
}

extension PopularActorsTableCell: UICollectionViewDataSource,UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return actors.count
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let mainViewController = parentViewController as? MainViewConroller {
            guard actors.count > indexPath.row else { return }
            let actor = actors[indexPath.row]
            
            
            guard let detailVC = mainViewController.storyboard?.instantiateViewController(withIdentifier: "actorDetail") as? ActorsDetailViewController else { return }
            detailVC.person = actor
            detailVC.personID = actor.id
            
            mainViewController.show(detailVC, sender: self)
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "actorCell", for: indexPath) as! PopularActorsCell
        
        let actor = actors[indexPath.row]
        
      
        if let posterPath = actor.profile_path {
            
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
