//
//  SearchTableCell.swift
//  IMovie
//
//  Created by liza_kaganskaya on 4/5/19.
//  Copyright © 2019 liza_kaganskaya. All rights reserved.
//

import UIKit
import TMDBSwift

class SearchTableCell: UITableViewCell {
    
    @IBOutlet weak var searchImage: UIImageView!
    
    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var releaseDate: UILabel!
    
    var film:MovieMDB?{
        didSet{
            reloadData()
        }
    }
    
    func reloadData(){
        
        DispatchQueue.main.async {
            self.title.text = self.film?.title
            self.releaseDate.text = self.film?.release_date
        }
        if let posterPath = film?.poster_path {
            
            DispatchQueue.main.async {
                self.searchImage.downloadImageFrom(urlString: posterPath,posterSize:PosterSizes.DETAIL_POSTER)
            }
        } 
        
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        reloadData()

    }

    

    
}
