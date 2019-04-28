//
//  DetailViewController.swift
//  IMovie
//
//  Created by liza_kaganskaya on 4/6/19.
//  Copyright © 2019 liza_kaganskaya. All rights reserved.
//

import UIKit
import SafariServices
import TMDBSwift

class DetailViewController: UIViewController {

    @IBOutlet weak var trailersCollectionView: UICollectionView!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var ratingBar: RatingProgressView!
    @IBOutlet weak var filmDesc: UITextView!
    @IBOutlet weak var runTime: UILabel!
    @IBOutlet weak var filmTitle: UILabel!
    @IBOutlet weak var releaseDate: UILabel!
   
  
    @IBOutlet weak var filmImage: UIImageView!
    
    @IBAction func closeBut(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)

    }
    var movie: MovieMDB!
    var movieID: Int?
    var videos:[VideosMDB]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        trailersCollectionView.delegate = self
        trailersCollectionView.dataSource  = self
        
        self.perform(#selector(animateProgress), with: nil, afterDelay: 0.5)
        
       // guard movie != nil else { return }
        
        filmTitle.text = movie.title
        filmDesc.text = movie.overview
        releaseDate.text = ("Release Date: " + movie.release_date!)
        
        MovieMDB.movie(movieID: movieID!) {
            (client, movieDeatil) in
            
            DispatchQueue.main.async {
                if let runTime = movieDeatil?.runtime{
                    self.runTime.text = "Runtime: \(runTime) min"
                }
                
            }
        }
        
        if let average = movie.vote_average {
            let rating = String(format:"%.1f", average)
            ratingLabel.text = "\(rating)"
        }
        
     
        if let bannerPath = movie.backdrop_path {
            DispatchQueue.main.async {
                self.filmImage.downloadImageFrom(urlString: bannerPath, posterSize:PosterSizes.ORIGINAL_POSTER )
            }
        }
        

        MovieMDB.videos(movieID: movieID!) { (client, videosMD) in
            self.videos = videosMD
            DispatchQueue.main.async {
                self.trailersCollectionView.reloadData()
            }
        }
        
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    
    @objc func animateProgress() {
        
        let cP = self.view.viewWithTag(101) as! RatingProgressView
        cP.setAnimation(duration: 0.7, value: 0.2)
        cP.trackColor = UIColor.lightGray
        
        let average = movie.vote_average!
        let one = 1.0...1.9
        let two = 2.0...2.9
        let three = 3.0...3.9
        let four = 4.0...4.9
        let five = 5.0...5.9
        let six = 6.0...6.9
        let seven = 7.0...7.9
        let eight = 8.0...8.9
        let nine = 9.0...9.9
        let ten = 10.0
        
        switch average {
        case one:
            cP.setAnimation(duration: 0.7, value: 0.1)
            cP.progressColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
            break
        case two:
            cP.setAnimation(duration: 0.7, value: 0.2)
            cP.progressColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
            break
        case three:
            cP.setAnimation(duration: 0.7, value: 0.3)
            cP.progressColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
            break
        case four:
            cP.setAnimation(duration: 0.7, value: 0.4)
            cP.progressColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
            break
        case five:
            cP.setAnimation(duration: 0.7, value: 0.5)
            cP.progressColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
            break
        case six:
            cP.setAnimation(duration: 0.7, value: 0.6)
            cP.progressColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
            break
        case seven:
            cP.setAnimation(duration: 0.7, value: 0.7)
            cP.progressColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
            break
        case eight:
            cP.setAnimation(duration: 0.7, value: 0.8)
            cP.progressColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
            break
        case nine:
            cP.setAnimation(duration: 0.7, value: 0.9)
            cP.progressColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
            break
        case ten:
            cP.setAnimation(duration: 0.7, value: 1.0)
            cP.progressColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
            break
            
        default:   cP.setAnimation(duration: 0.7, value: 0.0)
        cP.progressColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
            break
            
        }
       
    }
   
    @objc func tapVideo(_ sender: UITapGestureRecognizer){
        let location = sender.location(in: self.trailersCollectionView)
        let indexPath = self.trailersCollectionView.indexPathForItem(at: location)
        
        if let index = indexPath {
            let video_one = self.videos![index[1]]
            if let video_key = video_one.key{
                let videoURL = URL(string:"https://www.youtube.com/watch?v=" + video_key)

                if let videourl = videoURL{
                    print(videourl)
                    
                    let safariVC = SFSafariViewController(url: videourl)
                    present(safariVC, animated: true, completion: nil)
                }
            }
        }
    }
    
}

extension DetailViewController: UICollectionViewDataSource,UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
   
        if collectionView == self.trailersCollectionView{
            if let number = self.videos?.count {
                return number
            }
            else{
                return 0
            }
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let trailerCell = collectionView.dequeueReusableCell(withReuseIdentifier: "trailerCell", for: indexPath) as! trailersCel
       
        if collectionView == self.trailersCollectionView {
            let video_one = self.videos![indexPath.row]
            if let video_key = video_one.key {
                let videoThumbURL = URL(string: "https://img.youtube.com/vi/"+video_key+"/0.jpg")
                let url = videoThumbURL
                let data = try? Data(contentsOf: url!)
                trailerCell.imageView.image = UIImage(data: data!)
                print("Image URL: \(String(describing: data)) and \(String(describing: videoThumbURL))")
                
                
            } 
            
            trailerCell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapVideo(_:))))
        }
        
        return trailerCell
        
    }
}
