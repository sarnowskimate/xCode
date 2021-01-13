//
//  CustomImageView.swift
//  Instagram Clone
//
//  Created by Mateusz Sarnowski on 15/07/2020.
//  Copyright © 2020 Mateusz Sarnowski. All rights reserved.
//

import UIKit

var imageCache = [String: UIImage]()

class CustomImageView: UIImageView {
    
    var lastImgUrlUsedToLoadImage: String?
    
    func loadImage(with urlString: String) {
        // set image to nil
        self.image = nil
        
        // set last imageUrlUsedToLoadImage
        lastImgUrlUsedToLoadImage = urlString
        
        // check if image exists in cache
        if let cachedImage = imageCache[urlString] {
            image = cachedImage
            return
        }
        
        guard let url = URL(string: urlString) else { fatalError() }
        
        URLSession.shared.dataTask(with: url) { (data, urlResponse, error) in
            if let safeError = error {
                print("Failed to fetch data with error: ", safeError.localizedDescription)
            }
            
            if self.lastImgUrlUsedToLoadImage != url.absoluteString {
                return
            }
            
            guard let imageData = data else { fatalError() }
            let photoImage = UIImage(data: imageData)
            
            imageCache[url.absoluteString] = photoImage
            
            DispatchQueue.main.async {
                self.image = photoImage
            }
        }.resume()
    }
}
