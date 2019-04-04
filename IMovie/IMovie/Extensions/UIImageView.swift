//
//  UIImageView.swift
//  IMovie
//
//  Created by liza_kaganskaya on 4/1/19.
//  Copyright © 2019 liza_kaganskaya. All rights reserved.
//

import Foundation
import UIKit


let IMAGE_BASE_URL = "https://image.tmdb.org/t/p/"
var posterSizes = ["w92", "w154", "w185", "w342", "w500", "w780", "w1280", "original"]


   
    struct PosterSizes {
        static let BACK_DROP = posterSizes[6]
        static let ROW_POSTER = posterSizes[2]
        static let DETAIL_POSTER = posterSizes[3]
        static let ORIGINAL_POSTER = posterSizes[6]
    }

extension UIImageView {
    
    
    func downloadImageFrom(urlString: String, posterSize:String) {
        
        let baseURL = URL(string: IMAGE_BASE_URL)!
        let url = baseURL.appendingPathComponent(posterSize).appendingPathComponent(urlString)
        
        downloadImageFrom(url: url)
    }
    
    func downloadImageFrom(url: URL) {
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async {
                let imageToCache = UIImage(data: data)
                self.image = imageToCache
            }
            }.resume()
        
    }
    func rounded() {
        let radius = self.frame.width/2.0
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
    
}
