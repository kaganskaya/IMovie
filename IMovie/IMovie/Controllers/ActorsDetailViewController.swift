//
//  ActorsDetailViewController.swift
//  IMovie
//
//  Created by liza_kaganskaya on 4/20/19.
//  Copyright © 2019 liza_kaganskaya. All rights reserved.
//

import UIKit
import TMDBSwift

class ActorsDetailViewController: UIViewController {

    @IBOutlet weak var actorName: UILabel!
    @IBOutlet weak var actorImage: UIImageView!
    
    @IBOutlet weak var activity: UIActivityIndicatorView!
    
    @IBOutlet weak var credits: UICollectionView!
    @IBOutlet weak var bio: UITextView!
    @IBAction func close(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)

    }
    
    var person: PersonResults!
    
    
    var shows: [MovieMDB] = []
    var cast = [PersonMovieCast]()
    
    var personID: Int?
    var cancelRequest: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        credits.delegate = self as! UICollectionViewDelegate
        credits.dataSource  = self as! UICollectionViewDataSource
        
        
        activity.startAnimating()
        guard personID != nil else { return }
        
        actorName.text = person.name
        
        PersonMDB.person_id(personID: self.personID!) {
            (client,person) in
            
            self.bio.text = person?.biography
            
            if let posterPath = person!.profile_path {
                
                DispatchQueue.main.async {
                    
                    self.actorImage.downloadImageFrom(urlString: posterPath,posterSize:PosterSizes.ORIGINAL_POSTER)
                }
            }}
        
        PersonMDB.movie_credits(personID: self.personID!, language: "en") {
            (client, credits) in
            self.cast = (credits?.cast)!
            
            DispatchQueue.main.async {
                 self.activity.alpha = 0.0
                 self.activity.stopAnimating()
                  self.credits.reloadData()
                }
        }
        
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    
}

extension ActorsDetailViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
           return self.cast.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

       let movieCell = collectionView.dequeueReusableCell(withReuseIdentifier: "creditsCell", for: indexPath) as! ActorDetailCell

          let cast_one = self.cast[indexPath.row]

           if let posterPath = cast_one.poster_path {
            
                DispatchQueue.main.async {
                    movieCell.activity.alpha = 0.0
                    movieCell.activity.stopAnimating()
                    movieCell.actorFilmImage.downloadImageFrom(urlString: posterPath, posterSize:PosterSizes.ORIGINAL_POSTER)
                }
            } else {
                
                movieCell.activity.alpha = 0.0
                movieCell.activity.stopAnimating()
            }

        
        return movieCell
    }
    
   
    
}

