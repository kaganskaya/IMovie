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
    private func getUpcoming(){
        self.movies.removeAll()
        guard !cancelRequest else { return }
        
        TMDBConfig.apikey = "63f43d701067d757b85757bdb44a9a26"
        for number in (1...3) {
        MovieMDB.upcoming( page:number) {
            (client, movieDB) in
            if client.error == nil {
                let date = NSDate()
                
                for i in movieDB!{

                    if (i.release_date?.description)! > date.description {
                        self.movies.append(i)
                    }
                }
                
                print(self.movies.count)

                
            DispatchQueue.main.async {
                self.upcommingColView.reloadData()
            }
            
            }
            }}
            
        }
}
extension commingSoonTableCell: UICollectionViewDataSource, UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
        if let mainViewController = parentViewController as? MainViewConroller {
            guard movies.count > indexPath.row else { return }
            let movie = movies[indexPath.row]
            guard let detailVC = mainViewController.storyboard?.instantiateViewController(withIdentifier: "movieDetail") as? DetailViewController else { return }
            detailVC.movie = movie
            detailVC.movieID = movie.id
            mainViewController.show(detailVC, sender: self)
        }
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
                        cell.iamgeView.downloadImageFrom(urlString: posterPath, posterSize:PosterSizes.ORIGINAL_POSTER)
                    }
                } else {
            
            cell.activity.alpha = 0.0
            cell.activity.stopAnimating()
        }
        return cell
        
        
    }
    
        
    }
        


