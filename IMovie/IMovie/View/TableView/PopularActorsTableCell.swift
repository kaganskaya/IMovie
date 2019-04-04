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

extension PopularActorsTableCell: UICollectionViewDataSource,UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return actors.count
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
